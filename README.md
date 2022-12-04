# Mike's dotfiles

Easy usage: `curl -FSsl https://mjt.sh`

## What's included?

Configuration files for `vim`, `git`, `bash`, `zsh`, and `fzf`.

## Clean-up

Occasionally it's good to clean up a repo like this one since history is less important after stuff has been working for a while. 

1. Tag the most recent commit that's been used for a long time
2. Reset the git repo and force push

```bash
git checkout --orphan newstart main
git commit -a -m "Fresh start"

# Overwrite the old master branch reference with the new one
git branch -M newstart main
git push --force origin main
```
