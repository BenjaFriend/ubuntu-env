#!/bin/bash

# If a dry run is enabled then we will just print out what will happen
# instead of actually installing anything. Useful for debugging and 
# UX! 
dry_run_flag=false
has_snap=false

print_usage() {
  echo "OVERVIEW: Installs any packages and adds any PPA's in the 'apt-packs.txt' file."
  echo " "
  echo "OPTIONS:"
    printf "\t-h\tHelp. Prints this message!\n"
  printf "\t-d\tDry Run. If this flag is set then nothing will actually be installed, only printed out to the screen\n"
}

# parse cmd args
while getopts 'dh' flag; do
  case "${flag}" in
    d) dry_run_flag=true ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ "$dry_run_flag" = true ] ; then
  printf "Doing a dry run! Nothing will actually be installed! :)\n\n"
fi

## Test to see if snap is installed on this machine
snap -h > /dev/null
if [ $? -eq 0 ]; then
  echo Snap detected. Noice
  has_snap=true
fi

# If this machine is missing snap, then attempt to install it
if [ "$has_snap" = false ] ; then
  printf "NOTE: snap is not installed on this machine! Installing...\n\n"
    if [ "$dry_run_flag" = false ] ; then
      apt install snapd
      snap -h > /dev/null
      if [ $? -eq 0 ]; then
        echo Snap installed successfully!
        has_snap=true
      else
        echo Snap could not be isntalled!
      fi
    fi
  
fi

# Make sure only root can run our script
if [ "$(id -u)" != "0" ] && [ "$dry_run_flag" = false ] ; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

outText='output.log'
packagesFile='packs.txt'
ppa_prefix='ppa:'
snap_prefix='snap '

# Gotta get those tastey updates first
echo apt-update and ugprade
if [ "$dry_run_flag" = false ] ; then
  apt-get update -y > $outText
  apt-get upgrade -y > $outText
fi

# For each line in the packages file
while IFS="" read -r p || [ -n "$p" ]
do
  # If it starts with "ppa:" than we need to add the repo key
  if [[ $p = $ppa_prefix* ]] 
  then
	  printf 'Adding PPA key\t \"%s\"...\n' "$p"
    if [ "$dry_run_flag" = false ] ; then
      add-apt-repository $p > $outText
      apt update -y > $outText
    fi
  elif [[ $p = $snap_prefix* ]] && [ "$has_snap" = true ] 
  then 
      snapPkg=$(cut -d " " -f2- <<< "$p")
      printf 'Snap install\t \"%s\"...\n' "$snapPkg"
      if [ "$dry_run_flag" = false ] ; then
        snap install $snapPkg > $outText
      fi
  # Otherwise we can just apt-install it
  else
	  printf 'Apt Install\t \"%s\" ...\n' "$p"
    
    if [ "$dry_run_flag" = false ] ; then
      apt-get install $p -y  > $outText
    fi
  fi	  
done < $packagesFile


# ZSH install!! Weee
echo Set ZSH as default! 
if [ "$dry_run_flag" = false ] ; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  chsh -s $(which zsh)
fi

# Download some mouse cursors that I like! 
echo Download SpaceK cursors!
if [ "$dry_run_flag" = false ] ; then
  tar xzf ./resources/SpaceKCursors.tar.gz -C /usr/share/icons
fi

# Download the Jetbrains font! 
echo Download the Jetbrains font!
if [ "$dry_run_flag" = false ] ; then
  wget https://download.jetbrains.com/fonts/JetBrainsMono-2.001.zip?_ga=2.234557790.1795287856.1600537666-526302441.1600537666
fi