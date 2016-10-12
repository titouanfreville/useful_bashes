#!/bin/bash
# ### COLORS ### #
green="\\033[1;32m"
red="\\033[1;31m"
# ### ### #
echo "Installation of Git Update tools."
echo "This is tool can be used to update every git repository in a given file. It will be intalled in /usr/bin so you need admin rights."
echo
echo ">>>> Going with admin rights"
sudo echo "You can be admin" || { echo -e "$red You don't have admin rights. Contact your Sys Admin to install the tool" && exit 666; }
cd /tmp
echo
echo ">>>> Getting sources"
{ git clone git@github.com:titouanfreville/usefull_bashes.git || git clone https://github.com/titouanfreville/usefull_bashes.git; } \
&& echo -e "$green Resources well getted" || { echo -e "$red Did not get correctly the resources. Check what went wrong" && exit 1; }
echo
echo ">>>> Installing"
{ sudo cp usefull_bashes/git_update/git_update* /usr/bin/; } && echo -e "$green Install Complete" || { echo -e '$red Installation failed' && exit 2; }
echo 
echo ">>>> Cleaning before exit"
sudo rm -rf /tmp/usefull_bashes
echo "If the tools where corrected installed, you shall have an help message display : "
echo "---------- HELP ? -------------------"
git_update.sh -h && echo -e "$green You are ready" || \
{ echo -e "$red The tool is not correctly installed :'( Something is messed. Check what." && exit 3; }
echo "-------------------------------------"
