#!/bin/bash
# Purpose: Automated user creation in the AWS
# How to: ./aws-iam-create-user.sh <entry file format .csv>
# Entry file column name: user, group, password
# Author: Jean Rodrigues
# ------------------------------------------

INPUT=$1
OLDIFS=$IFS
IFS=',;'

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

command -v dos2unix >/dev/null || { echo "dos2unix tool not found. Please, install dos2unix tools before running the script."; exit 1; }

dos2unix $INPUT

while read -r email team groups password || [ -n "$email" ]
do
    if [ "$email" != "email" ]; then
	    aws iam create-user --user-name $email
        aws iam create-login-profile --password-reset-required --user-name $email --password $password
        aws iam add-user-to-group --group-name $groups --user-name $email
	fi
    

done < $INPUT

IFS=$OLDIFS