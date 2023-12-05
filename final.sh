#!/bin/bash

#3 December 2023
#IS480KB

#This script checks an Ubuntu 20.04 system for compliance with the specified
#category 1 and 2 STIGS.


#STIGID: UBTU-20-010012
#CAT 1
#This command checks the sudo group and shows the members that have access to
#security functions.

grep sudo /etc/group

#If a user that should not have access to security functions is listed,
#remove them from the sudo group by entering this command.

# sudo gpasswd -d <username> sudo


#STIGID: UBTU-20-010405
#CAT 1
#This command checks to see if the telnet package is installed.

dpkg -l | grep telnetd

#This command asks the user if they would like to uninstall the telnet
#package, then reads the input from the user and depending on the answer,
#uninstalls the telnet package or tells the user that the package is not
#installed.

read -p "Would you like to uninstall telnet? y/n: " confirm
if [[ "$confirm" == [yY] ]]; then
	sudo apt-get remove telnetd && echo "Telnet package uninstalled"
else
	echo "Telnet package not installed."
fi

#STIGID: UBTU-20-010406
#CAT 1
#This command checks to see if the rsh-server package is installed.

dpkg -l | grep rsh-server

#This command asks the user if they would like to uninstall the rsh-server
#package, then reads the input from the user, and depending on the answer,
#uninstalls the rsh-server package or tells the user that the package is not
#installed.

read -p "Would you like to uninstall the rsh-server package? y/n: " confirm
if [[ "$confirm" == [yY] ]]; then
        sudo apt-get remove rsh-server
        echo "rsh-server package uninstalled"
else
        echo "rsh-server package not installed."
fi

#STIGID: UBTU-20-010063
#CAT 2
#This puts the command in a variable to be able to call back later if needed. Then
#calls and runs the command in the variable which checks to see if the system has
#multifactor authentication packages installed.

CheckPckg=$(dpkg -l | grep libpam-pkcs11)
echo $CheckPckg


#This command checks to see if the  packages neecessary for multifactor
#authentication are installed. If they are installed, no further action
#required, if the packages are not already installed, it will ask the user
#if they would like to install the packages and if user input is yes, it
# will install the packages.

if [[ -n "$CheckPckg" ]];then
	echo "Packages are installed."
else
	read -p "Would you like to install the packages? y/n: " confirm
		if [[ "$confirm" == [yY] ]]; then
			sudo apt install libpam-pkcs11
		fi
fi


#STIGID: UBTU-20-010064
#CAT 2
##This puts the command in a variable to be able to call back later if needed. Then
#calls and runs the command in the variable which checks to see if the system has
#the necessary package required to accept PIV credentials.

ChkP=$(dpkg -l | grep opensc-pkcs11)
echo $ChkP

#This command checks to see if the  package necessary for PIV
#credentials is installed. If it is installed, no further action
#required, if the package is not already installed, it will ask the user
#if they would like to install the package and if user input is yes, it
# will install the package.


if [[ -n "$ChkP" ]];then
        echo "Package is installed."
else
        read -p "Would you like to install the package? y/n: " confirm1
                if [[ "$confirm1" == [yY] ]]; then
                        sudo apt-get install opensc-pkcs11
                fi
fi

