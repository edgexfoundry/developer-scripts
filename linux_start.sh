#!/bin/bash

# This shell script does a few things to help get a Ubuntu Desktop 16.04 system
# read to run EdgeX. Here is what the script does:
#
# X. Asks what is the user name of the person who will be running EdgeX
# X. If the /data/db directory is not on the system it creates it as 
#      well as changes ownership of the directory
# X.
# X.
# X.
# X.
# X.
# X.
# X.
# X.
# X.








clear
echo 
echo "What is the non-root user name you are using on the system:"

# read the non-root user name
read name
echo

#show the name being used
echo "The user name is: $name"
echo

# Directory needed if db initial setup
# TODO replace chad with data
dirsname="/chad/db"
dirname="/chad"

# TODO 
# Ask for the path of where you will want the working database to live
# You might have to go through the same file own change again


# folder creation and change ownership
echo "Does the $dirsname folder exist?"
echo
if [ ! -d $dirname  ] 
then
    echo "The folder doesn't exist. Now creating $dirname"
    sudo mkdir -p $dirname
    echo "Folder created"
    echo
    
    echo "Who is the owner of the folder"
    # TODO replace chad with data
    OWNS=$(stat -c '%U' /chad)
    echo $OWNS
    echo
    
    echo "Changing the file owner to $name"
    sudo chown -R $name:$name $dirname
    echo "File owner changed"
    echo
    
    echo "Who is the owner of the folder"
    # TODO replace chad with data
    OWNS=$(stat -c '%U' /chad)
    echo $OWNS
    echo

    echo "Folder creation is complete, moving to next step"
    echo

else
    echo "File exists -> moving to next step"
fi

# TODO
# first initialize this
# mongod --dbpath /data/db

# TODO
# second initialize this 
# mongod --dbpath /home/$USER/mongodb/db



