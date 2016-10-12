#!/bin/bash# 

#### COLORS ### #
green="\\033[1;32m"
red="\\033[1;31m"
basic="\\033[0;39m"
blue="\\033[1;34m"
# ### ### #
# ### Actions Variables ### #
checkout=0
quiet=1
debug=1
# ### ### ##
# ### Process Variables ### #
# Get options passed
TEMP=`getopt -o dhq --long --debug,help,quiet -n 'Softgallery Tools Initialisation' -- "$@"`
# Help message to print for -h option (or when not providing correctly)
HELP_MESSAGE="Usage: git_update_component.sh [OPTIONS] ORIGIN_BRANCH

This is a component for git_update.sh script. It only update a repository using ORIGIN_BRANCH as merge origin. 
This script require getopt to run. (Install gnu-getopt to run from mac).

Be Careful : This script will not support merging in master* branch.

Options:
  -d, --debug             Debug. Run the script with debug information.
  -h, --help              Print this help.
  -q, --quiet             Silencing scripts. Render testing and getting resources non interactive by default.
"
################################################################################
source 
##################### GETTING ARGS #############################################
# REQUIRE : getopt. Should be available on most bash terminal ##################
# ENSURE : args variable setted with value provided by user   ##################
################################################################################
# [ $debug -eq 0 ] && echo "Provided arguments BEFORE Flag reading : $@"
eval set -- "$TEMP"
while true
do
  case "${1}" in
    -h|--help)
      echo "$HELP_MESSAGE"; exit 0;;
    -d|--debug)
      debug=0;shift;;
    -q|--quiet)
      quiet=0;shift;;
    --) shift; break;;
    *) echo "You provided a wrong option"; echo $HELP_MESSAGE; exit 1;;
  esac
done

checkout_branch=$1
if [ $# ]
base_branch=$(git branch | grep \* | cut -d ' ' -f2)
if [[ $base_branch == *'master'* ]]
	then echo -e "$red Not a normal use case. Only devil are allow to break Master"; exit 666;
fi
if [[ $checkout_branch == $base_branch ]]
	then checkout=1
fi

if [ $quiet -neq 0 ]
then
	[ $checkout -eq 0 ] && git stash
	[ $checkout -eq 0 ] && git checkout $checkout_branch
	[ $debug -eq 0 ] && echo "## Pulling "
	git pull
	[ $debug -eq 0 ] && echo "## Pulled "
	[ $checkout -eq 0 ] && git checkout $base_branch
	[ $debug -eq 0 ] && [ $checkout -eq 0 ] && echo "## Merging "
	[ $checkout -eq 0 ] && git merge $checkout_branch
	[ $debug -eq 0 ] && [ $checkout -eq 0 ] && echo "## Merged "
	[ $checkout -eq 0 ] && git push
	[ $debug -eq 0 ] && [ $checkout -eq 0 ] && echo "## Appling stash "
	[ $checkout -eq 0 ] && git stash apply
	[ $debug -eq 0 ] && [ $checkout -eq 0 ] && echo "## Applied "
	[ $checkout -eq 0 ] && git stash drop stash@{0}
else 

fi