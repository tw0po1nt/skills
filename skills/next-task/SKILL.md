---
name: next-task
description: Retire the current feature branch and reset to the default branch before starting the next task.
disable-model-invocation: true
---

This skill resets the repository to a clean starting point. It removes the current feature branch and returns you to the default branch, synchronized with origin. This skill does not start the next task. It does not look up a ticket or create a new branch. That decision belongs to another skill.

## 1. Find the default branch

Run `git remote show origin`, or read `origin/HEAD`, to find the default branch name. Do not assume the default branch is `main`. Some repositories use `master` or another name.

Done when: You have the name of the default branch.

## 2. Handle the already-on-default case

If the current branch is the default branch, no feature branch exists to retire. In this case, run `git pull --ff-only`. Report that no cleanup was necessary. Stop here. Do not continue to the steps below.

## 3. Check the working tree is clean

Run `git status --porcelain` to check the working tree. Any output means uncommitted changes exist.

If the working tree is dirty, refuse to continue. Report the uncommitted files and stop. Do not stash, discard, or change these files.

Done when: The working tree is clean, or you have refused and stopped.

## 4. Confirm the branch is safe to delete

A branch is safe to delete only after its work has landed in the default branch. Check the following conditions in order.

1. **PR status.** Run `gh pr view <branch> --json state,mergedAt`. If the command reports a merged pull request, the branch is safe to delete. A squash-merged branch never becomes an ancestor of the default branch. For this reason, a merged pull request overrides the git ancestry check.
2. **Git ancestry.** Run this check only when `gh` finds no pull request for the branch, or when `gh` is not available. Run `git merge-base --is-ancestor <branch> <default>`. If the branch is an ancestor of the default branch, the branch is safe to delete.

If neither check confirms the branch has landed, refuse to continue. Report that no merged pull request exists and that the branch is not merged into the default branch. Do not force the deletion.

Done when: You have confirmed the branch is safe to delete, or you have refused and stopped.

## 5. Retire the branch

After you confirm the branch is safe to delete, complete these steps in order.

1. Run `git checkout <default>`.
2. Run `git pull --ff-only`.
3. Delete the local feature branch with `git branch -D <branch>`. Use the force flag because you already verified the merge in step 4. The git ancestry check alone cannot detect a squash merge.

Do not delete the remote branch. Remote branch deletion is a separate, visible action. Leave this action to the user.

Done when: The current branch is the default branch, the default branch is up to date with origin, and the local feature branch no longer exists.
