#!/bin/bash

#----------------------------------------------
# Run Script for CU Boulder Data Ingests
#
#----------------------------------------------

#Import Passwords for system processes
source syspwd
export HARVESTER_INSTALL_DIR=/usr/share/vivo/vivo-harvester


#Set Date, Default Folder, Data Folders, Backup File Prefix
#ROOT=~/Source  --my local source
ROOT=/usr/local/vivo/dat-files

DATE=$(date +"%Y%m%d")
OLD=cub-old-data
NEW=cub-new-data
TARFILE=cub-update
INSTITUTE=CUB

# Create directory structure if run on new machine/vagrant instance.
#     Prevents unnecessary manual setup for new users.
if [ ! -d $ROOT ]; then
  mkdir $ROOT
fi
if [ ! -d $ROOT/$OLD ]; then
  mkdir $ROOT/$OLD
fi
if [ ! -d $ROOT/$NEW]; then
  mkdir $ROOT/$NEW
fi

# Supply the location of the detailed log file which is generated during the script.
#	If there is an issue with a harvest, this file proves invaluable in finding
#	a solution to the problem. It has become common practice in addressing a problem
#	to request this file. The passwords and usernames are filtered out of this file
#	to prevent these logs from containing sensitive information.
echo "Full Logging in OVERALL.$DATE.log"
if [ ! -d logs ]; then
  mkdir logs
fi
cd logs
touch OVERALL.$DATE.log
ln -sf OVERALL.$DATE.log OVERALL.latest.log
cd ..


# Call Oracle Database - Pass Script File and Recieve Files
echo exit | sqlplus $OR_USER/$OR_PWD@SERVER @oracle-scripts/vivo_extract_cub.sql

# Move files into position for review from Laon
rm -rf $ROOT/$OLD/*
cp -R $ROOT/$NEW/* $ROOT/$OLD/
rm -rf $ROOT/$NEW/*
scp SERVER:/tmp/fis_* $ROOT/$NEW/

# Create backup of output files
tar -cvzf $ROOT/$TARFILE'-'$DATE.tar.gz $ROOT/$NEW/fis_*

cd pythonReview

# Get system default python path
PYTHON=$(which python)

# Run Comparison program based on last run
$PYTHON reviewForChanges.py $ROOT/$OLD/ $ROOT/$NEW/ $INSTITUTE ../fileRunMap
