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
# Wrapper script for the creation of a FEWS database user on PostgreSQL.
# It is assumed 
# 1. the psql executable is located in the user's PATH
# 2. the database to restore it in has the same encoding
#
# Return Values:
#  none
#
# Command line options and arguments
#  $1: database to create
#  $2: user
#  $3: directory for data tablespace
#  $4: directory for index tablespace
#

# Function to inform the user on usage
# Arguments : none
function print_usage() {
  echo "Wrapper script for the creation of a FEWS database and user on PostgreSQL."
  echo "It is assumed the psql executable is located in the user's PATH."
  echo
  echo "Usage: $0 <database> <username> <data_path> <index_path>"
  echo "  where:"
  echo "    <database>: database to create"
  echo "    <username>: database owner user"
  echo "    <data_path>: directory for data tablespace"
  echo "    <index_path>: directory for index tablespace"
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
if (( 4 > $# || $# > 5)) ; then
 echo
 echo "ERROR: Wrong number of arguments: found $#, expected 4."
 echo
 print_usage
 exit 1
fi

if (( $# == 4 )) ; then
  read -sp 'Password: ' password
else
  password=$5
fi

# Run the sql sqript
psql -f db_user_creation.sql -d "postgres" -U "postgres" -v database=$1 -v username=$2 -v password=\'$password\' -v data_path=\'$3\' -v index_path=\'$4\'
