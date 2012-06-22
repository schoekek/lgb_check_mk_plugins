#!/bin/sh

# This script is called by the Check_MK PostgreSQL plugin in order to
# execute an SQL query.

# It is your task to adapt this script so that the PostgreSQL environment
# is setup and the correct user chosen to execute psql.

# The script will get the query on stdin and shall output the
# result on stdout. Error messages goes to stderr.

POSTGRE_DB=$1
if [ -z "$POSTGRE_DB" ] ; then
    echo "Usage: $0 POSTGRE_DB" >&2
    exit 1
fi

su postgres -c "psql --tuples-only -d $POSTGRE_DB "
