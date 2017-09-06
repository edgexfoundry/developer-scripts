#!/bin/bash

# The user must define this path
Full path
dbpath="/home/youngc/edgex/db"
Short path
dirname="/home/youngc/edgex"


clear
echo
echo "This script will do the following:"
echo "-- Ask you to supply a user name: a user name is needed to set folder ownership"
#echo "-- Ask you where you would like to locate the Mongo Database."
echo "-- Create folders, if necessary, for the database."
echo "-- Start database creation (without --auth)."
echo "-- Initialize the database for Edgex."
echo "-- Shutdown the database."
echo "-- Verify all processes of Mongo are stopped."
echo "-- Start the database again (using --auth). "
echo
echo

# Ask for a user name
echo "What is the non-root user name who will own the folders where the database will be stored:"
echo

# read the non-root user name
read name
echo

# Confirm the user name
echo "Is this what you meant to write?"
echo
echo $name
echo

# TODO
# add the y/n to continue code


# Ask you where you would like to locate the Mongo Database
#echo "Where would you like to the Mongo Database to reside?"
#echo "Example: /home/tester/edgex/db"
#echo

## Read the location of the data base
#read dbpath

## Ask if this is correct
#echo
#echo "Is this what you meant to write?  $dbpath"
#echo

# TODO
#enter the y/n to continue code

# folder creation and change ownership
echo "Checking to see if $dbpath exist?"
echo
if [ ! -d $dbpath  ] 
then
    echo
    echo "The folder doesn't exist. "
    echo

    echo "Now creating $dbpath"
    sudo mkdir -p $dbpath
    echo

    echo "Folder created"
    echo

# DEBUG
#    echo "Who is the owner of the folder"
#    OWNS=$(stat -c '%U' $dbpath)
#    echo $OWNS
#    echo 

    echo "Changing the file owner to $name"
    sudo chown -R $name:$name $dirname
    echo
    echo "File owner changed"
    echo

# DEBUG
#    echo "Who is the owner of the folder"
#    OWNS=$(stat -c '%U' $dbpath)
#    echo $OWNS
#    echo

    echo "Folder creation is complete, moving to next step"
    echo

else
    echo "File exists -> moving to next step"
    echo
fi

# Start the database creation (without --auth)
#sudo mongod --dbpath $dbpath
#echo

# Initialize the database for edgex 
#sudo mongo < init_mongo.js
#echo

# Shutdown the database
#sudo mongod --dbpath $dbpath --shutdown
#echo

# Verify all the processes of Mongo are stopped
#killpid=`sudo netstat -ntlp | grep mongod | awk '{print $7}' | sed 's/\/.*//'`
#echo This is the pid that needs to die: $killpid
#sudo kill -9 $killpid
#sudo netstat -tulnp | grep mongod
    

# Start the database (using --auth)
#sudo mongod --dbpath $dbpath --auth


