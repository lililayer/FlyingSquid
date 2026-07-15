#!/bin/bash

color_normal="\033[0m"
color_light_blue="\033[1;36m" # desired in the output standard
color_dark_blue="\033[3;34m"  # debuged in the output standard
color_light_purple="\033[0;35m" # Titles for input standard
color_high_purple="\033[1;95m" # puted in input standard
color_dark_purple="\033[0;35m" # asked in input standard
color_red="\033[1;91m"
color_green="\033[0;32m"
color_light_grey="\033[1;29m" # menu
color_dark_grey="\033[0;90m" # menu input

resources_directory=Resources
scripts_directory=$resources_directory/Scripts
msg_output_file=$resources_directory/temp_out.txt
msg_input_file=$resources_directory/ServerDirectory/temp_in.txt

# CHECK SAFEMODE

actual_user="$(whoami)"
if [[ $actual_user == "root" ]]; then
    echo -e ${color_red}
    echo Warning, you are logged in root !
    echo -e ${color_normal}
    passed=0
    while [[ $passed == 0 ]]; do
        read -p "Do you want to continue ? (y/N) " doContinue
        if [ "$doContinue" = "y" -o "$doContinue" = "Y" ]
        then
            passed=1
        elif [ "$doContinue" = "n" -o "$doContinue" = "N" -o "$doContinue" = "" ]
        then
            exit 1
        fi
    done

fi


# SETUP

clear
echo -e ${color_dark_grey}
cat ./$resources_directory/StartMessage.txt
echo
uname -a
echo 'starting server...'
./$scripts_directory/startserver.sh
ip a
echo -e ${color_normal}

# What server to connect with ?

passed=0
while [[ $passed == 0 ]]; do
    echo -e ${color_light_grey}
    echo "Please, enter the ip address of the server you want to comunicate with : "
    echo -e ${color_normal}
    echo -e ${color_dark_grey}
    read -p " > " server_ip
    echo -e ${color_normal}
    
    if ping -c 1 $server_ip &> /dev/null; then
        passed=1
    else
        echo -e ${color_red}
        echo "Host is down, please enter a valid host..."
        echo -e ${color_normal}
    fi
done

# APPLICATION

while [[ 1 == 1 ]]; do
    echo -e ${color_light_grey}
    read -p "(g) get message / (p) post message / (q) quit > " actionID
    echo -e ${color_normal}
    if [ "$actionID" = "g" ]
    then
        echo -e ${color_dark_blue}
        wget $server_ip:27015/temp_in.txt -O $msg_output_file
        msg=$(cat $msg_output_file)
        
        echo -e ${color_normal}
	echo -e ${color_light_blue}
        msg=$($scripts_directory/decode.sh $msg)
        echo $msg
        echo -e ${color_normal}
    elif [ "$actionID" = "p" ]
    then
    	echo -e ${color_light_purple}
    	echo "Message :"
    	echo -e ${color_normal}
    	echo -e ${color_high_purple}
        read -p " > " msg
        msg=$($scripts_directory/encode.sh $msg)
        echo -e ${color_normal}
        echo $msg > $msg_input_file
    elif [ "$actionID" = "q" ]
    then
        # exit SEA then exit...
        
    	exit
    fi
done
