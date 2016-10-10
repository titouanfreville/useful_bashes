#!/bin/bash
# Git update function. -----------------------------------------------------------------
check_specific () {
	for el in ${!def_branches_asso[@]}
	do
		[ $debug -eq 0 ] && echo 'Provided element $1'
		[ $debug -eq 0 ] && echo 'Current key checked ${el}'
		if [[ $1 == *"$el"* ]]
			then 
			[ $debug -eq 0 ] && echo "In specific case"
			flock ~/git_updating_lock git_update_component.sh ${def_branches_asso[$el]}
			return  0
		else 
			[ $debug -eq 0 ] && echo "Not in specific case"
		fi
	done
	return 1
}

check_repo () {
	cd $1
	[ $debug -eq 0 ] && echo "Path to look : $1"
	for repo in ${1}/*
	do
		[ $debug -eq 0 ] && echo "Repo :::: $repo" 
		if [[ -d ${repo} ]]
		then
			[ $debug -eq 0 ] && echo "Checking if directory is a git repo"
			if [[ -d ".git" ]]
			then
				[ $debug -eq 0 ] && echo "Updating ${repo} ####### "
				check_specific $repo
				if [ $? -eq 0 ]
					then 
						[ $debug -eq 0 ] && echo 'Done specific way'
					else 			
						flock ~/git_updating_lock git_update_component.sh 'master'
				fi
				[ $debug -eq 0 ] && echo "Done #######"
			fi
			check_repo ${repo}
		fi
	done
}
# --------------------------------------------------------------------------------------
# Running process --------------------------------------------------------------
# ### Process Variables ### #
# Get options passed
TEMP=`getopt -o dhqyb: --long --debug,help,non-interactive,quiet,default-branch: -n 'Softgallery Tools Initialisation' -- "$@"`
# Help message to print for -h option (or when not providing correctly)
HELP_MESSAGE="Usage: git_update.sh [OPTIONS] BASE_LOOKING_PATH

This is a small who will look into every directory of provided path to check and update git repository.
This script require getopt to run. (Install gnu-getopt to run from mac).

Options:
  -b, --default-branch    Default branch for given repository pattern. Foramt : \"REPOSITORY=BRANCH\". 
                          (ex: -b̀ \"SPECIFIC=MY_BRANCH\" will match every element containing SPECIFIC).
  -d, --debug             Debug. Run the script with debug information.
  -h, --help              Print this help.
  -q, --quiet             Silencing scripts. Render testing and getting resources non interactive by default.
  -y, --non-interactive   Run process non interactively.
"
# Set tasks variables to false and quick_conf to interactive (dv : docker_verion,
# se : set_env, te : test_env, gr: ger_resources, s=serve, t=test, i: interactivity,
# ser_sil=verbosity of server block).
dv=1; se=1; te=1; gr=1; s=1; t=1; i=0; ser_sil="";
# Default for branch name. 
default_branches=""
# Associative array using repo name as Key and default branch as Value.
declare -A def_branches_asso
key_array=''
tab_length=-1
# Debug variable
debug=1
# ### ### #
################################################################################
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
    -b|--default-branch)
      default_branches+=($2)
      shift 2;;
    -d|--debug)
      debug=0;shift;;
    -q|--quiet)
      quiet=0;shift;;
    -y|--non-interactive)
      interactive=1;shift;;
    --) shift; break;;
    *) echo "You provided a wrong option"; echo $HELP_MESSAGE; exit 1;;
  esac
done
[ $debug -eq 0 ] && echo "---------------------------------------------------------------------------------"
[ $debug -eq 0 ] && echo "Updating git at :: $(date)"

[ $debug -eq 0 ] && echo "Base arguments in -d :::: ${default_branches[@]}"
if [ ! -z default_branches ]
then
	for el in "${default_branches[@]}"
	do
		if [ ! -z $el ]
		then 
			[ $debug -eq 0 ] && echo "Element ::::: $el"
			el_array=(${el//=/ })
			[ $debug -eq 0 ] && echo "Element array :::: ${el_array[@]}"
			key_array+=(${el_array[0]})
			[ $debug -eq 0 ] && echo "Key only array :::: ${key_array[@]}"
			tab_length=$[tab_length+1]
			[ $debug -eq 0 ] && echo "Table length :::: ${tab_length}"
			def_branches_asso[${el_array[0]}]=${el_array[1]}
			[ $debug -eq 0 ] && echo "Map in loop :::: KEYS : ${!def_branches_asso[@]} VALUES : ${def_branches_asso[@]}"
		fi
	done
fi
[ $debug -eq 0 ] && echo "Full map : ${def_branches_asso[@]}"
check_repo $1
[ $debug -eq 0 ] && echo "---------------------------------------------------------------------------------"
# Done ---------------------------------------------------------------------------------
