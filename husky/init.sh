# Husky 9 sources this file before every hook, in every repository (~/.config/husky/init.sh).
# It runs in husky's own shell: never exit here and never touch "$@" (the hook's arguments).

# citiesapps/web commit gate queue (personal, this machine only).
#
# A commit that stages a file the related-test lookup cannot follow (a lint rule, a ui-framework
# style source, a test config, a deleted file) runs the complete unit suites of every affected
# project, each with one Vitest fork per CPU. Several agent sessions committing such files at once
# ran those suites side by side and held 8+ GB for over an hour. So, for those commits only:
#   1. wait until no other worktree of the clone is running them (a lock in the git common dir,
#      which every worktree shares), printing who holds the turn;
#   2. run the affected projects one after another (NX_PARALLEL=1) instead of up to eight at once.
# Ordinary commits (related specs only) never wait. A holder that died (killed hook) is detected by
# its pid and replaced. If the lock cannot be written at all, the commit runs unqueued.
# Known limits: two waiters can clear the same dead lock at once and both run (the old behaviour);
# a reused pid keeps waiters waiting until that unrelated process ends.
if [ "$n" = "commit-msg" ] &&
  git config --get remote.origin.url 2>/dev/null | grep -Eq '[:/]citiesapps/web(\.git)?$' &&
  node --input-type=module -e '
    import { execFileSync } from "node:child_process";
    import { pathToFileURL } from "node:url";
    // The gate decides with this function too; branches older than it are never queued.
    const { unitTestArgs } = await import(
      pathToFileURL(`${process.cwd()}/scripts/husky/unit-test-args.mjs`).href
    );
    const staged = (revision) =>
      execFileSync(
        "git",
        ["diff", "--cached", "--name-only", "--no-renames", "--diff-filter=ACMRD", "-z", revision],
        { encoding: "utf8" }
      )
        .split("\0")
        .filter(Boolean);
    let files = staged("HEAD");
    // Like the gate, a merge authors only the paths that differ from the incoming side too.
    try {
      execFileSync("git", ["rev-parse", "-q", "--verify", "MERGE_HEAD"], { stdio: "ignore" });
      const incoming = new Set(staged("MERGE_HEAD"));
      files = files.filter((file) => incoming.has(file));
    } catch {}
    process.exit(files.length > 0 && unitTestArgs(files, process.cwd())[0] === "run" ? 0 : 1);
  ' 2>/dev/null; then
  export NX_PARALLEL=1
  ca_lock="$(git rev-parse --path-format=absolute --git-common-dir)/commit-gate-unit-suites.lock"
  ca_temp="$ca_lock.$$"
  ca_waiting=
  ca_tries=0
  # The lock appears complete in one step: write a temp file, then hard-link it into place.
  if echo "$$ $PWD" >"$ca_temp" 2>/dev/null; then
    until ln "$ca_temp" "$ca_lock" 2>/dev/null; do
      if read -r ca_pid ca_dir <"$ca_lock" 2>/dev/null; then
        ca_tries=0
        if kill -0 "$ca_pid" 2>/dev/null; then
          if [ -z "$ca_waiting" ]; then
            echo "Waiting for the full unit suites another worktree is running (pid $ca_pid, $ca_dir)."
            ca_waiting=1
          fi
          sleep 2
        else
          rm -f "$ca_lock"
        fi
      else
        # ln failed, yet there is no lock to read: retry briefly, then run unqueued.
        ca_tries=$((ca_tries + 1))
        if [ "$ca_tries" -ge 5 ]; then
          ca_lock=
          break
        fi
      fi
    done
    rm -f "$ca_temp"
  else
    ca_lock=
  fi
  if [ -n "$ca_lock" ]; then
    # Release on any exit of husky's shell, but only a lock that is still ours.
    trap 'read -r ca_pid ca_dir <"$ca_lock" 2>/dev/null && [ "$ca_pid" = "$$" ] && rm -f "$ca_lock"' EXIT
    trap 'exit 129' HUP
    trap 'exit 130' INT
    trap 'exit 143' TERM
  fi
fi
