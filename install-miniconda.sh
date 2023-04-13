#!/bin/bash

# Date        : Thu 13 Apr 13:59:37 CEST 2023
# Autor       : Leonid Burmistrov
# Description : 

LC_TIME=en_GB.UTF-8

##Locations
initial_dir=$PWD
install_log=$initial_dir/miniconda_install.log
rm -rf $install_log

function install_miniconda {
    # Install miniconda to /miniconda
    curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod u+x Miniconda3-latest-Linux-x86_64.sh
    $initial_dir/Miniconda3-latest-Linux-x86_64.sh -p $initial_dir/miniconda -b
    cd $initial_dir/miniconda/bin
    conda update -y conda
    cd $initial_dir
    rm Miniconda3-latest-Linux-x86_64.sh
    source $initial_dir/miniconda/etc/profile.d/conda.sh
    $PATH=$initial_dir/miniconda/bin:$PATH
    $PATH=$initial_dir/miniconda/condabin:$PATH
}

function printUsefulInfo {
    echo " ---> initial_dir          : $initial_dir"
}

function cleanAll {
    echo " ---> cleanAll : "
}

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d  : Download and install"
    echo " [0] -c  : clean"
    echo " [0] -h  : help"
}

if [ $# -eq 0 ] 
then    
    printHelp
else
    if [ "$1" = "-d" ]; then
	rm -rf $install_log
        date | tee $install_log
	install_miniconda | tee -a $install_log
        printUsefulInfo | tee -a $install_log
	date | tee -a $install_log
    elif [ "$1" = "-c" ]; then
	cleanAll
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi

#espeak "I have done"
