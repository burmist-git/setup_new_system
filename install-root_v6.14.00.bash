#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2019 - LBS - (Single person developer.)                 #
# Thu May 16 18:09:27 JST 2019                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                  script to download and install root_v6.14.00        #
# Input paramete:                                                      #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

LC_TIME=en_US.UTF-8

##Locations
roothomeDir=$PWD
version="6.14.00"
sourceHomeDir="root-$version"
duildDir=$roothomeDir/$sourceHomeDir-build
installDir=$roothomeDir/$sourceHomeDir-install

### Number of threads for compilation
nthreads=`(cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l)`
#For compilation we use one less thread than total number of threads 
let nthreads=nthreads-1

function buildPrerequisites {
    #Required packages:
    sudo apt-get install -y git
    sudo apt-get install -y dpkg-dev
    sudo apt-get install -y cmake
    sudo apt-get install -y g++
    sudo apt-get install -y gcc
    sudo apt-get install -y binutils
    sudo apt-get install -y libx11-dev
    sudo apt-get install -y libxpm-dev
    sudo apt-get install -y libxft-dev
    sudo apt-get install -y libxext-dev
    #Optional packages:
    sudo apt-get install -y gfortran 
    sudo apt-get install -y libssl-dev 
    sudo apt-get install -y libpcre3-dev 
    sudo apt-get install -y xlibmesa-glu-dev 
    sudo apt-get install -y libglew1.5-dev 
    sudo apt-get install -y libftgl-dev 
    sudo apt-get install -y libmysqlclient-dev 
    sudo apt-get install -y libfftw3-dev 
    sudo apt-get install -y graphviz-dev 
    sudo apt-get install -y libavahi-compat-libdnssd-dev 
    sudo apt-get install -y libldap2-dev 
    sudo apt-get install -y python
    sudo apt-get install -y python-dev
    sudo apt-get install -y python3
    sudo apt-get install -y python3-dev
    sudo apt-get install -y libxml2-dev 
    sudo apt-get install -y libkrb5-dev 
    sudo apt-get install -y libgsl0-dev 
    sudo apt-get install -y libqt4-dev
    sudo apt-get install -y libcfitsio-dev
}

function downloadRoot {
    wget https://root.cern.ch/download/root_v$version.source.tar.gz
}

function installRoot {
    #unpack
    tar -zxvf root_v$version.source.tar.gz
    #makebuild and install directories
    mkdir -p $duildDir
    mkdir -p $installDir
    cd $duildDir
    cmake -DCMAKE_INSTALL_PREFIX=$installDir $roothomeDir/$sourceHomeDir
    echo "nthreads = $nthreads"
    make -j$nthreads
    makeInstallRoot
}

function makeInstallRoot {
    #echo "makeInstallRoot"
    cd $duildDir
    make install
    cd $duildDir
}

function printUsefulInfo {
    echo " ---> thisroot.sh location : "
    ls $installDir/bin/thisroot.sh
}

function cleanAll {
    echo " ---> cleanAll : "
    rm -rf root-6.14.00  root-6.14.00-build  root-6.14.00-install  root_v6.14.00.source.tar.gz
}

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d  : Download and install"
    echo " [0] -bp : Build prerequisites"
    echo " [0] -sd : Download"
    echo " [0] -si : Install"
    echo " [0] -c  : clean"
    echo " [0] -h  : help"
}

if [ $# -eq 0 ] 
then    
    printHelp
else
    if [ "$1" = "-d" ]; then
	buildPrerequisites
	downloadRoot
	installRoot
	printUsefulInfo
    elif [ "$1" = "-bp" ]; then
	buildPrerequisites
    elif [ "$1" = "-sd" ]; then
	downloadRoot
    elif [ "$1" = "-si" ]; then
	installRoot
    elif [ "$1" = "-c" ]; then
	cleanAll
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi

#espeak "I have done"
