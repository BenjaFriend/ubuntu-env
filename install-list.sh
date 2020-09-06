#!/bin/sh

echo updating...
apt-get update -y

echo upgrading...
apt-get upgrade -y

echo installing packages from `packages.txt`...
packagesFile='packages.txt'

while IFS="" read -r p || [ -n "$p" ]
do
  printf '%s\n' "$p"
  apt-get install $p -y
done < $packagesFile
