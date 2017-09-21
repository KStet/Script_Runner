#!/bin/bash

#arg1 is the filepath to the list of ip addresses

arg1=$1

if [ $(dpkg -l | grep -c nmap) = 0 ]
then
        sudo apt-get install -qy nmap &>/dev/null
fi

if [ $(echo $arg1) ]
then
	readarray -t array < $arg1
else
	myip=$(ip a | grep 'inet ' | tr -s ' ' | cut -d ' ' -f3 | cut -d '/' -f1 | grep -v '127.0.0.1')
	ip=$(echo $myip | cut -d '.' -f1-3)
	array=( $(nmap -p 22 -T4 --open $ip.1-250 | grep -o $ip.[0-9]* | grep -v $myip))
	$array>IP_arrays.txt
fi


#assumes ssh key for all computers are already in place
#should add check for this and if they arent create them
for i in ${array[@]}
do
        ssh loud@$i './.update.sh'
done
