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
# 
# Wrapper script for the creation of schema and tables for a FEWS open database on PostgreSQL.
# It is assumed the psql executable is located in the user's PATH
# 
#
# Return Values:
#  none
#
# Command line options and arguments
#  $1: database for FEWS system
#  $2: database owner user
#   
#

# Number of required arguments for this script
NUM_REQUIRED_ARGUMENTS=2

# Function to inform the user on usage
# Arguments : none
function print_usage() {
  echo "Wrapper script for the creation of schema and tables"
  echo "for a FEWS open database on PostgreSQL."
  echo "It is assumed the psql executable is located in the user's PATH."
  echo
  echo "Usage: $0 <database> <username>"
  echo "  where:"
  echo "    <database>: database for FEWS open database"
  echo "    <username>: database owner user"
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
psql -f open_schema_creation.sql -d $1 -U $2 -v database=$1 -v username=$2 
