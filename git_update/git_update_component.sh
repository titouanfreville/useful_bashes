#!/bin/bash
checkout_branch=$1
base_branch=$(git branch | grep \* | cut -d ' ' -f2)
if [[ $base_branch == *'master'* ]]
	then echo "Not a normal use case"; exit 1;
fi
git stash > /dev/null
git checkout $checkout_branch > /dev/null
echo "## Pulling " >> ~/git_update.logs
git pull >> ~/git_update.logs
echo "## Pulled " >> ~/git_update.logs
git checkout $base_branch >> /dev/null
echo "## Merging " >> ~/git_update.logs
git merge $checkout_branch >> ~/git_update.logs
echo "## Merged " >> ~/git_update.logs
git push >> ~/git_update.logs
echo "## Appling stash " >> ~/git_update.logs
git stash apply >> ~/git_update.logs
echo "## Applied " >> ~/git_update.logs
git stash drop stash@{0} > /dev/null