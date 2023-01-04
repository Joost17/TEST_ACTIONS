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
# clonedb_import.sh
# ----------------------------------------------------------------
# Description:
# Wrapper script for restoring a FEWS database dump file on PostgreSQL.
# It is assumed 
# 1. the psql executable is located in the user's PATH
# 2. Postgres database has sufficient diskspace
#
# Return Values:
#  none
#
# Command line options and arguments
#  $1: Delft-FEWS database to restore the dump file into
#  $2: dump file to restore
#

# Number of required arguments for this script
NUM_REQUIRED_ARGUMENTS=2

# Function to inform the user on usage
# Arguments : none
function print_usage() {
  echo "Wrapper script for the Database script to create a clone database schema on PostgreSQL."
  echo "It is assumed the psql executable is located in the user's PATH."
  echo
  echo "Usage: $0 <dst_database> <dump_file>"
  echo "  where:"
  echo "    <dst_database>: Delft-FEWS database to restore"
  echo "    <user>: Delft-FEWS user"
  echo "    <dump_file>: file to store the dump in"
  echo
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

# Restore the dump
pg_restore -U "postgres" --dbname=$1 $2
