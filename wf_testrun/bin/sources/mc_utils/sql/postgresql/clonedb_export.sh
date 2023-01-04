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
# Wrapper script for the dump file creation of a Delft-FEWS database on PostgreSQL.
# It is assumed
# 1. the pg_dump executable is located in the user's PATH
# 2. when using this script for migration to a newer Postgres database, the tooling of the newer Postgres version is used
# 3. location for the dump file has sufficient disk space
#
# Return Values:
#  none
#
# Command line options and arguments
#  $1: database to create a dumpfile for
#  $2: dump file to create
#

# Number of required arguments for this script
NUM_REQUIRED_ARGUMENTS=2

# Function to inform the user on usage
# Arguments : none
function print_usage() {
  echo "Wrapper script for the dump file creation of a Delft-FEWS database on PostgreSQL."
  echo "It is assumed the pg_dump executable is located in the user's PATH."
  echo
  echo "Usage: $0 <src_database> <dump_file>"
  echo "  where:"
  echo "    <src_database>: Delft-FEWS database to dump"
  echo "    <dump_file>: file to store the dump file in"
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

# Create the dump file
pg_dump -U postgres --format c --blobs --dbname=$1 --file=$2
