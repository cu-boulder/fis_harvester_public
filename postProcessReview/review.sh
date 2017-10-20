#!/bin/bash

#Copyright (c) 2013 FIS Team. 

# set to the directory where the harvester was installed or unpacked
# HARVESTER_INSTALL_DIR is set to the location of the installed harvester
#	If the deb file was used to install the harvester then the
#	directory should be set to /usr/share/vivo/harvester which is the
#	current location associated with the deb installation.
#	Since it is also possible the harvester was installed by
#	uncompressing the tar.gz the setting is available to be changed
#	and should agree with the installation location
HARVESTER_INSTALL_DIR=~/Source/VIVO-Harvester
#HARVESTER_INSTALL_DIR=/usr/local/vivo/vivo-harvester
export HARVEST_NAME=post-process-review
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

# To make this script more usuable in other applications it requires you to pass 
#   references to the two VIVO's you wish to compare  This script defines the models
#   in those VIVO's (using the CAPITAL Modifier on the JenaConnects) that you wish to 
#   review and produces diffs for each  The sequence is *.sh OLD NEW when calling this 
#   script file
OLD=$1
NEW=$2

#Check for required inputs
if  [ "$NEW" == "" ]  || [ "$OLD" == "" ]
then
  echo "You must submit and new and old VIVO connection file to review"
  echo "The syntax should be review.sh NEW=/s/a/x OLD=/s/a/y "
  exit
else
  echo "The New VIVO Model information is located at $NEW"
  echo "The Old VIVO Model information is located at $OLD"
fi


# ModelsToReview are models that are capable of being diffed for changes
# these will run through a for loop where we're hoping the total number of 
# lines in the output is 4.  The four lines are
#   <?xml version="1.0"?>
#   <rdf:RDF>
#     <xmlns:rd"http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
#   </rdf:RDF>
#
modelsToReviewKeys[0]=faculty
modelsToReviewValues[0]=http://vitro.mannlib.cornell.edu/a/graph/ws_fm_construct
modelsToReviewKeys[1]=institutions
modelsToReviewValues[1]=http://vitro.mannlib.cornell.edu/a/graph/ws_i_construct
modelsToReviewKeys[2]=subject-areas
modelsToReviewValues[2]=http://vitro.mannlib.cornell.edu/a/graph/ws_sa_construct
modelsToReviewKeys[3]=faculty-subject-areas
modelsToReviewValues[3]=http://vitro.mannlib.cornell.edu/a/graph/ws_fm2sa_construct
modelsToReviewKeys[4]=faculty-researchOverviews
modelsToReviewValues[4]=http://vitro.mannlib.cornell.edu/a/graph/ws_fm2ro_construct
modelsToReviewKeys[5]=faculty-countries
modelsToReviewValues[5]=http://vitro.mannlib.cornell.edu/a/graph/ws_fm2c_construct
modelsToReviewKeys[6]=faculty-regions
modelsToReviewValues[6]=http://vitro.mannlib.cornell.edu/a/graph/ws_fm2r_construct


# ModelsToQuery require a query of values to be able to establish if the two 
# models are similar.  We'll use $key-query-x and loop through the given queries
# for a model
#
modelsToQueryKeys[0]=departments
modelsToQueryValues[0]=http://vitro.mannlib.cornell.edu/a/graph/ws_d_construct
modelsToQueryKeys[1]=faculty-positions
modelsToQueryValues[1]=http://vitro.mannlib.cornell.edu/a/graph/ws_fm2p_construct
modelsToQueryKeys[2]=faculty-degrees
modelsToQueryValues[2]=http://vitro.mannlib.cornell.edu/a/graph/ws_fm2dg_construct
modelsToQueryKeys[3]=faculty-urls
modelsToQueryValues[3]=http://vitro.mannlib.cornell.edu/a/graph/ws_fm2url_construct

#clear old data
# For a fresh harvest, the removal of the previous information maintains data integrity.
#	If you are continuing a partial run or wish to use the old and already retrieved
#	data, you will want to comment out this line since it could prevent you from having
# 	the required harvest data.  
rm -rf data

MATCHING_MODELS="The Good Models are  "
BAD_MODELS="The Bad Models Are: "

for i in "${!modelsToReviewKeys[@]}"
do
  key=${modelsToReviewKeys[$i]}
  value=${modelsToReviewValues[$i]}

  #output our data
  harvester-transfer -i $OLD -ImodelName=$value -o tbd.model.xml -OdbDir=data/old-$key-data/
  harvester-transfer -i $NEW -ImodelName=$value -o tbd.model.xml -OdbDir=data/new-$key-data/

  harvester-diff -m tbd.model.xml -MdbDir=data/old-$key-data/ -s tbd.model.xml -SdbDir=data/new-$key-data/ -d mainDump=data/$key-sub
  harvester-diff -s tbd.model.xml -SdbDir=data/old-$key-data/ -m tbd.model.xml -MdbDir=data/new-$key-data/ -d mainDump=data/$key-add
  
  ADDNUMOFLINES=$(wc -l < data/$key-add)
  SUBNUMOFLINES=$(wc -l < data/$key-sub)

  if [ "$SUBNUMOFLINES" == "4" ] && [ "$ADDNUMOFLINES" ==  "4" ]
  then
    MATCHING_MODELS="$MATCHING_MODELS\n $key"
  else
    BAD_MODELS="$BAD_MODELS\n $key \n  Number of Subtracted Elements: $SUBNUMOFLINES \n  Number of Added Elements: $ADDNUMOFLINES"
  fi
done



for i in "${!modelsToQueryKeys[@]}"
do
  key=${modelsToQueryKeys[$i]}
  value=${modelsToQueryValues[$i]}

  #output our data
  harvester-transfer -i $OLD -ImodelName=$value -o tbd.model.xml -OdbDir=data/old-$key-data/
  harvester-transfer -i $NEW -ImodelName=$value -o tbd.model.xml -OdbDir=data/new-$key-data/

  DATA_DIFF=""

  for f in $key-query-*
  do
    #echo "Doing query $f"
    query=$(cat $f)
    OLDCOUNT=`harvester-jenaconnect -j tbd.model.xml -JdbDir=data/new-$key-data/ -q "$query" | sed -n '4s/^.*[^0-9]\([0-9][0-9]*\).*/\1/p'`
    NEWCOUNT=`harvester-jenaconnect -j tbd.model.xml -JdbDir=data/old-$key-data/ -q "$query" | sed -n '4s/^.*[^0-9]\([0-9][0-9]*\).*/\1/p'`
    #echo "old count is $OLDCOUNT"
    #echo "new count is $NEWCOUNT"
    if [ $OLDCOUNT != $NEWCOUNT ]
    then
      DIFF=$((OLDCOUNT-NEWCOUNT))
      DATA_DIFF="$DATA_DIFF\n\t Query $f shows $DIFF elements different"
    fi
  done

  if [ "$DATA_DIFF" == "" ]
  then
    MATCHING_MODELS="$MATCHING_MODELS\n $key"    
  else 
    BAD_MODELS="$BAD_MODELS\n $key $DATA_DIFF"
  fi
done  

echo -e $MATCHING_MODELS
echo -e $BAD_MODELS

echo 'Harvest Review completed successfully'
