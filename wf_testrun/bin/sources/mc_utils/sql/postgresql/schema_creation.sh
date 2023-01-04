#!/bin/bash
# ================================================================
# Delft-FEWS
# ================================================================
#
# Software Info: http://www.delft-fews.com
# Contact Info:  Delft-FEWS Product Management (fews-pm@deltares.nl)
#
# (C) Copyright 2008, by Deltares
#                        P.O. Box 177
#                        2600 MH  Delft
#                        The Netherlands
#                        http://www.deltares.nl
#
# DELFT-FEWS: A platform for real time forecasting and water resources management.
# Delft-FEWS is expert data handling and model integration software for flood forecasting,
# drought and seasonal forecasting, and real-time water resources management
#
# ----------------------------------------------------------------
# Description:
# 
# Wrapper script for the creation of schema and tables for FEWS on PostgreSQL.
# It is assumed the psql executable is located in the user's PATH
# 
#
# Return Values:
#  none
#
# Command line options and arguments
#  $1: database for FEWS system
#  $2: database owner user
#  $3: mcId
#  $4: databaseIntId - unique offset in the synchronisation pool 0-97 for generating globalRowIds

#

# Number of required arguments for this script
NUM_REQUIRED_ARGUMENTS=4

# Function to inform the user on usage
# Arguments : none
function print_usage() {
  echo "Wrapper script for the creation of schema and tables for FEWS on PostgreSQL."
  echo "It is assumed the psql executable is located in the user's PATH."
  echo
  echo "Usage: $0 <database> <username> <mcId> <databaseIntId>"
  echo "  where:"
  echo "    <database>     : database for FEWS system"
  echo "    <username>     : database owner user"
  echo "    <mcId>         : master controller mcId"
  echo"     <databaseIntId>: databaseIntId - unique offset in the synchronisation pool 0-97 for generating globalRowIds"
}
# Process any command line options
while getopts "h" options; do
  case $options in 
   h ) print_usage  # help option
          exit 0;;
   \? ) print_usage  # unknown option
          exit 1;;
  esac
done

# Check if we have the right number of arguments
if (($# != $NUM_REQUIRED_ARGUMENTS));
then
 echo
 echo "ERROR: Wrong number of arguments: found $#, should be $NUM_REQUIRED_ARGUMENTS."
 echo
 print_usage
 exit 1
fi

# Run the sql sqript
psql -f schema_creation.sql -d $1 -U $2 -v database=$1 -v username=$2 -v mcId=$3 -v databaseIntId=$4
