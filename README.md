# gh-issue-creator

Simple script to create GitHub issues from a CSV file.

## Requirements

- [GitHub CLI](https://cli.github.com/)

## Usage

```bash
./create-issues.sh issues.csv username/repo
```

## Example

```bash
./create-issues.sh issues.csv tjcafferkey/gh-issue-creator
```

## CSV Format

```
title,body,labels
"Fix login bug","The login form doesn't validate email","bug,high-priority"
"Add new feature","Add a new feature to the product","feature,medium-priority"
"Fix bug in checkout","The checkout process doesn't handle errors","bug,low-priority"
```

## Notes

- The script will skip the first line of the CSV file (the headings)
- If there is an error with assigning labels, the issue will be created without labels.

## TODO

- Add better markdown support, perhaps using a UI?
- Add support for Assignees
- Add support for Project Boards
