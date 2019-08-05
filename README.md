# Mergeback

A simple github action to merge back master to a development branch.
￼
This action uses an optional environment variable:
- `BASE_BRANCH`
  The base branch where master changes should be merged to. Defaults to `develop`.

The action uses GitHub's REST API to create a PR and merge it remotely on GitHub's servers.
