# Git Update

Bash script who will go in your git repository and update your local work branch on main repo branch.

## How to use 

- Clone the repository `git clone git@github.com:titouanfreville/usefull_bashes.git || git clone https://github.com/titouanfreville/usefull_bashes.git`
- Add the repository to your path `export PATH=$PATH:$CLONE_ROOT/git_update`
- Run the script `git_update.sh $GIT_PATH`

## Simple install

[Get `installation.sh` script](http://freville.iiens.net/scripts/)
Run `installation.sh`

## What is it doing

This script will look on all the folder from the path provided to look for git repository. When on a git repository, it will save changes on local branch, checkout master or specified branch then merge the checked branch in the local branch. Then, he will applied the changes you did not pushed yet and removed the stash he created. **It will never merge something on master branch.**

