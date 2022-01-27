#!/bin/bash

# Date        : Wed May 26 13:36:10 CEST 2021
# Autor       : Leonid Burmistrov
# Description : 

LC_TIME=en_US.UTF-8

##Locations
g4homeDir=$PWD
sourceHomeDir="geant4.10.01.p02"
duildDir=$g4homeDir/geant4.10.01.p02-build
installDir=$g4homeDir/geant4.10.01.p02-install
installDataDir=$installDir/share/Geant4-10.1.2/data/

### Number of threads for compilation
nthreads=`(cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l)`
#For compilation we use one less thread than total number of threads 
let nthreads=nthreads-1

### Source and data location
erlangen_de="https://ftp.uni-erlangen.de/macports/distfiles/geant4/"
ucllnl_org="ftp://gdo-nuclear.ucllnl.org/LEND_GND1.3/"
geant4_cern_ch="http://geant4.cern.ch/support/source/"
local_archive_dir="/media/burmist/wdl01_1/nb-gred02/home2/geant4.10.04.p02/geant4.10.01.p02-build/"
packageList=(
    $erlangen_de'geant4.10.01.p02.tar.gz'
    $geant4_cern_ch'G4NDL.4.5.tar.gz'
    $geant4_cern_ch'G4EMLOW.6.41.tar.gz'
    $geant4_cern_ch'G4PhotonEvaporation.3.1.tar.gz'
    $geant4_cern_ch'G4RadioactiveDecay.4.2.tar.gz'
    $geant4_cern_ch'G4NEUTRONXS.1.4.tar.gz'
    $geant4_cern_ch'G4PII.1.3.tar.gz'
    $geant4_cern_ch'RealSurface.1.0.tar.gz'
    $geant4_cern_ch'G4SAIDDATA.1.1.tar.gz'
    $geant4_cern_ch'G4ABLA.3.0.tar.gz'
    $geant4_cern_ch'G4ENSDFSTATE.1.0.tar.gz'
    $ucllnl_org'LEND_GND1.3_ENDF.BVII.1.tar.gz'
)
nPackage=${#packageList[@]}
let nPackage=nPackage-1

function downloadGeant4 {
    for i in `seq 0 $nPackage`;
    do
	#echo ${packageList[$i]}
	tarFILE=`(basename ${packageList[$i]})`
	if [ ! -f "$tarFILE" ]; then
	    wget ${packageList[$i]}
	fi
    done    
}

function downloadOnlyGeant4 {
    wget ${packageList[0]}
}

function copyGeant4from {
    for i in `seq 0 $nPackage`;
    do
	#echo ${packageList[$i]}
	tarFILE=`(basename ${packageList[$i]})`
	if [ ! -f "$tarFILE" ]; then
	    cp $local_archive_dir$tarFILE .
	fi
    done    
}

function copyOnlyGeant4from {
    cp $local_archive_dir`(basename ${packageList[0]})` .
}

function installGeant4 {
    #unpack
    tar -zxvf geant4.10.01.p02.tar.gz
    #makebuild and install directories
    mkdir -p $duildDir
    mkdir -p $installDir
    cd $duildDir
    cmake -DCMAKE_INSTALL_PREFIX=$installDir $g4homeDir/$sourceHomeDir
    echo "nthreads = $nthreads"
    make -j$nthreads
    makeInstallGeant4
}

function makeInstallGeant4 {
    #echo "makeInstallGeant4"
    cd $duildDir
    make install
    #unpack data dirs 
    echo " -p $installDataDir"
    cd $installDataDir
    for i in `seq 1 $nPackage`;
    do
	dataTarFileName=`(basename ${packageList[$i]})`
	mv $g4homeDir/$dataTarFileName .
	tar -zxvf $dataTarFileName
    done    
    cd $g4homeDir
}

function makeInstallGeant4_test {
    #echo "makeInstallGeant4"
    #cd $duildDir
    #make install
    #unpack data dirs 
    echo "cd $installDataDir"
    #cd $installDataDir
    for i in `seq 1 $nPackage`;
    do
	dataTarFileName=`(basename ${packageList[$i]})`
	#mv $g4homeDir/$dataTarFileName .
	#tar -zxvf $dataTarFileName
	echo "cp /home/burmist/home2/geant4.10.01.p02/geant4.10.01.p02-build/$dataTarFileName ."
	#echo "mv $g4homeDir/$dataTarFileName ."
	echo "tar -zxvf $dataTarFileName;"
    done    
    cd $g4homeDir
}

function printUsefulInfo {
    echo " ---> Compile and link simulation (exampleXYZ) : "
    echo "$ cmake -DGeant4_DIR=path_to_Geant4_installation/lib[64]/Geant4-10.0.0/ ../exampleXYZ"
}

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d   : Download and install"
    echo " [0] -sd  : Download"
    echo " [0] -sdo : Download only source"
    echo " [0] -si  : Install"
    echo " [0] -c   : Copy from given dirrectory"
    echo " [0] -co  : Copy from given dirrectory only Geant4"
    echo " [0] -mit : Make test install"
    echo " [0] -h   : help"
}

if [ $# -eq 0 ] 
then    
    printHelp
else
    if [ "$1" = "-d" ]; then
	downloadGeant4
	installGeant4
	printUsefulInfo
    elif [ "$1" = "-sd" ]; then
	downloadGeant4
    elif [ "$1" = "-sdo" ]; then
	downloadOnlyGeant4
    elif [ "$1" = "-si" ]; then
	installGeant4
    elif [ "$1" = "-c" ]; then
	copyGeant4from
    elif [ "$1" = "-co" ]; then
	copyOnlyGeant4from
    elif [ "$1" = "-mit" ]; then
	makeInstallGeant4_test
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi

#packageList=(
#    $erlangen_de'geant4.10.01.p02.tar.gz'
#    $erlangen_de'G4NDL.4.5.tar.gz'
#    $erlangen_de'G4EMLOW.6.41.tar.gz'
#    $erlangen_de'G4PhotonEvaporation.3.1.tar.gz'
#    $erlangen_de'G4RadioactiveDecay.4.2.tar.gz'
#    $erlangen_de'G4SAIDDATA.1.1.tar.gz'
#    $erlangen_de'G4NEUTRONXS.1.4.tar.gz'
#    $erlangen_de'G4PII.1.3.tar.gz'
#    $erlangen_de'RealSurface.1.0.tar.gz'
#    $erlangen_de'G4ENSDFSTATE.1.0.tar.gz'
#    $ucllnl_org'LEND_GND1.3_ENDF.BVII.1.tar.gz'
#)

#espeak "I have done"
