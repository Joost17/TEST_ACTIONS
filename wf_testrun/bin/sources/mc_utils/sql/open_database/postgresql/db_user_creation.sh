#!/bin/bash
#
# Delft FEWS
# Copyright (c) 2003-2012 Deltares. All Rights Reserved.
#
# Developed by:
# Tessella
# Tauro Kantorencentrum
# President Kennedylaan 19
# 2517 JK Den Haag
# The Netherlands
# email: info@tessella.com
# web:   www.tessella.com
#
# Project Ref: Tessella/NPD/7488
#
# File history
# Version           Date                           Author
# $Revision: 38183 $     $Date: 2012-11-23 17:56:23 +0100 (vr, 23 nov. 2012) $                       $Author: broek_f $
#
# Description:
# Wrapper script for the creation of an open database and user on PostgreSQL for use with FEWS.
# It is assumed the psql executable is located in the user's PATH
# 
#
# Return Values:
#  none
#
# Command line options and arguments
#  $1: database to create in database cluster
#  $2: user to create in database cluster
#  $3: new password of the user
#

# Number of required arguments for this script
NUM_REQUIRED_ARGUMENTS=3

# Function to inform the user on usage
# Arguments : none
function print_usage() {
  echo "Wrapper script for the creation of an open database"
  echo "and user on PostgreSQL for use with FEWS."
  echo "It is assumed the psql executable is located in the user's PATH."
  echo
  echo "Usage: $0 <database> <username> <password>"
  echo "  where:"
  echo "    <database>: database to create in database cluster"
  echo "    <username>: user to create in database "
  echo "    <password>: new password of the user"
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

# Run the sql sqript
psql -f db_user_creation.sql -d "postgres" -U "postgres" -v database=$1 -v username=$2 -v user_password=\'$3\' 

