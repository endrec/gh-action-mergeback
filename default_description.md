How to resolve merge conflicts
===

To resolve conflicts, you should check out these branches on your local machine, carefully edit the conflicting files, and merge the changes to the development branch.  
When you finished, push the resolved state to the development branch.
**Do NOT commit to `master`, as it can trigger an automated release: you could be accidentally releasing untested code if you did this.**

On your local copy of the repository, you should run:

```
git checkout master
git pull
git checkout ${BASE_BRANCH}
git pull
git merge master
```

Here git will tell you that you have conflicts. You should resolve those conflicts manually. When you finished, you need to commit and push the merge.

```
git commit
git push origin ${BASE_BRANCH}
```

Where to find help
---

- `git mergetool` is your friend.
- your IDE might include tools for conflict resolution.
- as always, github documentation is useful. https://help.github.com/en/articles/resolving-a-merge-conflict-using-the-command-line is a good starting point.

