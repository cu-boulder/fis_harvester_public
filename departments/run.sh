#!/bin/bash

#Copyright (c) 2010-2011 VIVO Harvester Team. For full list of contributors, please see the AUTHORS file provided.
#All rights reserved.
#This program and the accompanying materials are made available under the terms of the new BSD license which accompanies this distribution, and is available at http://www.opensource.org/licenses/bsd-license.html

# set to the directory where the harvester was installed or unpacked
# HARVESTER_INSTALL_DIR is set to the location of the installed harvester
#	If the deb file was used to install the harvester then the
#	directory should be set to /usr/share/vivo/harvester which is the
#	current location associated with the deb installation.
#	Since it is also possible the harvester was installed by
#	uncompressing the tar.gz the setting is available to be changed
#	and should agree with the installation location

if [[ -z "$HARVESTER_INSTALL_DIR" ]]; then
    export HARVESTER_INSTALL_DIR=/usr/local/vivo/vivo-harvester
fi
export HARVEST_NAME=dat-departments
export DATE=`date +%Y-%m-%d'T'%T`

# Add harvester binaries to path for execution
# The tools within this script refer to binaries supplied within the harvester
#	Since they can be located in another directory their path should be
#	included within the classpath and the path environment variables.
export PATH=$PATH:$HARVESTER_INSTALL_DIR/bin
export CLASSPATH=$CLASSPATH:$HARVESTER_INSTALL_DIR/bin/harvester.jar:$HARVESTER_INSTALL_DIR/bin/dependency/*
export CLASSPATH=$CLASSPATH:$HARVESTER_INSTALL_DIR/build/harvester.jar:$HARVESTER_INSTALL_DIR/build/dependency/*

# Exit on first error
# The -e flag prevents the script from continuing even though a tool fails.
#	Continuing after a tool failure is undesirable since the harvested
#	data could be rendered corrupted and incompatible.
set -e

# Supply the location of the detailed log file which is generated during the script.
#	If there is an issue with a harvest, this file proves invaluable in finding
#	a solution to the problem. It has become common practice in addressing a problem
#	to request this file. The passwords and usernames are filtered out of this file
#	to prevent these logs from containing sensitive information.
echo "Full Logging in $HARVEST_NAME.$DATE.log"
if [ ! -d logs ]; then
  mkdir logs
fi
cd logs
touch $HARVEST_NAME.$DATE.log
ln -sf $HARVEST_NAME.$DATE.log $HARVEST_NAME.latest.log
cd ..

#clear old data
# For a fresh harvest, the removal of the previous information maintains data integrity.
#	If you are continuing a partial run or wish to use the old and already retrieved
#	data, you will want to comment out this line since it could prevent you from having
# 	the required harvest data.  
rm -rf data


#Import CSV
# Takes the data from a comma-separated-values file and places it in a rdf using
#   the methods employed by VIVO's CSV to RDF (and similar requirements)
harvester-csvfetch -X csvfetch.config.xml


#Remove Older Data
# Remove the original construct Model by truncating it's contents using jenaconnect
harvester-jenaconnect -X delete.config.xml


#Execute Main Translate
# Modify our imported data using SPARQL into a new construct model
harvester-sparqltranslator -X departments.config.xml

#Execute Sub-Organization Translate 
# Add additional information regarding sub organizations using a SPARQL Query
harvester-sparqltranslator -X departments-sub.config.xml

#Execute URL Translate
# Add additional information regarding organization URL using a SPARQL Query
harvester-sparqltranslator -X departments-url.config.xml


#Generate URI's for blank nodes
# The sparql translate step for URL's generates a blank node for each web address.
#   process each blank node created into a proper URI so that it will be displayed
#   in the VIVO interface
harvester-renameblanknodes -X rename.config.xml


#Create initial backup
# Save a copy of the model for restoration
harvester-transfer -i ../vivo.model.xml -ImodelName=http://vitro.mannlib.cornell.edu/a/graph/ws_d_construct -d data/constructed-data

#Backup create timed backups
# In the overall ingest backups folder create a backup with the date and of this 
#   Ingest and a last file to be used for restoring the previous harvest 
echo "Backing up data in ../backups/department-data-$DATE"
cd ..
if [ ! -d backups ]; then
  mkdir backups
fi
cd backups
touch department-data-$DATE
touch department-data-last
cd ../departments


cp data/constructed-data ../backups/department-data-$DATE
cp data/constructed-data ../backups/department-data-last


#Output some counts
# To be eventually used in an email created by the system, process the 
#   constructed-data file for the various organizations we're hoping were ingested by
#   the harvest process.  Eventually this can be used to identify hazardous ingests 
#   When counts vary greatly from ingest to ingest.
ACDEPT=`cat data/constructed-data | grep '<rdf:type rdf:resource="http://vivoweb.org/ontology/core#AcademicDepartment' | wc -l`
DEPT=`cat data/constructed-data | grep '<rdf:type rdf:resource="http://vivoweb.org/ontology/core#Department' | wc -l`
CENTER=`cat data/constructed-data | grep '<rdf:type rdf:resource="http://vivoweb.org/ontology/core#Center' | wc -l`
COLLEGE=`cat data/constructed-data | grep '<rdf:type rdf:resource="http://vivoweb.org/ontology/core#College' | wc -l`
INST=`cat data/constructed-data | grep '<rdf:type rdf:resource="http://vivoweb.org/ontology/core#Institute' | wc -l`
LIB=`cat data/constructed-data | grep '<rdf:type rdf:resource="http://vivoweb.org/ontology/core#Library' | wc -l`
MUS=`cat data/constructed-data | grep '<rdf:type rdf:resource="http://vivoweb.org/ontology/core#Museum' | wc -l`
PROG=`cat data/constructed-data | grep '<rdf:type rdf:resource="http://vivoweb.org/ontology/core#Program' | wc -l`
SCHOOL=`cat data/constructed-data | grep '<rdf:type rdf:resource="http://vivoweb.org/ontology/core#School' | wc -l`


echo "Imported $ACDEPT Academic Departments"
echo "Imported $DEPT Departments"
echo "Imported $CENTER Centers"
echo "Imported $COLLEGE Colleges"
echo "Imported $INST Institutes"
echo "Imported $LIB Libraries"
echo "Imported $MUS Museums"
echo "Imported $PROG Programs"
echo "Imported $SCHOOL Schools"


echo 'Harvest completed successfully'
