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
export HARVEST_NAME=dat-faculty-countries
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


# Import CSV
# Takes the data from a comma-separated-values file and places it in a rdf using
# the methods employed by VIVO's CSV to RDF (and similar requirements)
harvester-csvfetch -X csvfetch.config.xml

# Remove the original construct Model
harvester-jenaconnect -X delete.config.xml

# Execute Translate using SPARQL
# Modify our imported data using SPARQL into a new construct model
harvester-sparqltranslator -X facultyCountries.config.xml

# Potentially another query to add "Country" Moniker to each country (testing without it)

# Save a copy of the model for restoration
harvester-transfer -i ../vivo.model.xml -ImodelName=http://vitro.mannlib.cornell.edu/a/graph/ws_fm2c_construct -d data/constructed-data

# Create a backup
echo "Backing up data in ../backups/facultyCountries-data-$DATE"
cd ..
if [ ! -d backups ]; then
  mkdir backups
fi
cd backups
touch facultyCountries-data-$DATE
touch facultyCountries-data-last
cd ../facultyCountries

cp data/constructed-data ../backups/facultyCountries-data-$DATE
cp data/constructed-data ../backups/facultyCountries-data-last

#Output some counts
FAC=`cat data/constructed-data | grep '<rdf:Description rdf:about="http://vivo.colorado.edu/individual/fisid_' | wc -l`
COUNTRIES=`cat data/constructed-data | grep 'geographicFocus rdf:resource="http://aims.fao.org/aos/geopolitical.owl#' | wc -l`


echo "Imported $COUNTRIES Countries for $FAC Faculty Members"

echo 'Harvest completed successfully'
