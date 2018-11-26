#!/bin/bash
#
# Shell script for structuring subject folders
# - based off of R generated .csv: eg. ben_newfolder_forshell_QC.csv
# - R source code: folder_structure.R
#
# Sean Ma
# Dec 2016
# Jul 2017 - upgrade to use cp -ipal for "hardlink" to files
#
# TODOs:
# - !! NEED !! Check if multiple t1mprage, t1overlay, exists!
# - integrate with Makefile for fault tolerance and parallelization
#
# - How to run:
# sh file_struct_ABCDResting.sh 2>&1 | tee Log_file_struct_ABCDResting_$(date +"%m%d_%Y").txt
#
# - How to check error:
# grep -i 'no such file' file_struct_oldResting_log_1222_2016.txt
# - How to generate directory listing for FirstLevel_mc_template.m
# ls -d */ > dir_struct_{$date}.txt
#
# TODO(Sean): 1. print out original file directory and file name of t1mprage_208

THISDIR=/nfs/fmri/Analysis/Sean_Working/Subjects_ABCDResting
RAWDIR=/nfs/fmri/RAW_nopreprocess

echo "* * * * * * * * * * * * * * * * * * * * * * * * * * *"
echo "*** Script Resting state file structure purpose!! ***"
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * *"

# number of files index
N=0

# for loop to read from input .csv
while IFS="," read -r oldfolder newfolder
do
  # making fmri analysis folder in /Subjects
  cd ${THISDIR}
  mkdir "${newfolder}"
  cd ${newfolder}

  echo
  echo "Current subject: " $(pwd)
  echo

  # setting up directories
  echo
  echo "Making anatomy and func directories"
  echo

  mkdir anatomy
  mkdir func

  # copying spgr.nii and linking them for preprocessing
  echo
  echo "Copying and linking t1mprage.nii for Resting state"
  echo

  # checking if more than 1 file exists; report error if so
  cd anatomy
  N=$(ls -1 ${RAWDIR}/${oldfolder}/anatomy/t1mprage_208/t1mprage_208* 2>/dev/null | wc -l)
  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple t1mprage in /anatomy !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/anatomy/t1mprage_208/t1mprage_208*
  else
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    cp -ipal ${RAWDIR}/${oldfolder}/anatomy/t1mprage_208/t1mprage_208.nii .
    ln -s t1mprage_208.nii t1mprage.nii
  fi
  N=0


  # start copying the functional files
  echo
  echo "Now copying Resting func files: utprun_01.nii, meanutprun_01.nii, run_01.nii, realign.dat"
  echo

  cd ../func

  echo
  echo "Currently at /func: " $(pwd)
  echo

  # checking if more than 1 file exists; report error if so
  mkdir run_01
  N=$(ls -1 ${RAWDIR}/${oldfolder}/func/resting/run_01/utprun_01* 2>/dev/null | wc -l)
  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple utprun_01 in /func !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/func/resting/run_01/utprun_01*
  else
    cd run_01
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    cp -ipal ${RAWDIR}/${oldfolder}/func/restingabcd/run_01/utprun_01.nii .
    cp -ipal ${RAWDIR}/${oldfolder}/func/restingabcd/run_01/meanutprun_01.nii .
    cp -ipal ${RAWDIR}/${oldfolder}/func/restingabcd/run_01/run_01.nii .
    cp -ipal ${RAWDIR}/${oldfolder}/func/restingabcd/run_01/realign.dat .

    # chmod to read only
    chmod go-w *.nii *.dat

    # list copied files
    cd ..
    ls -laR

    echo
    echo " ========================================================="
    echo "              Copy complete, next subject"
    echo " ========================================================="
    echo
  fi

done < MADC_ABCDResting_1stbatch_Nov21_2018_REDO.csv
# done < MADC_ABCDResting_1stbatch_Nov21_2018.csv

## ==== addressing specific subject issues ====
#
# grep -i 'cannot' Log_file_struct_ABCDResting_1121_2018.txt
# hlp17umm01494_05012 - 1. FIXED by relinking!! has t1sag_208/ instead of t1mprage_208/;
# hlp17umm01387_03659 - 1. FIXED by linking utrun_01.nii, meanutrun_01.nii !! no utprun_01.nii, no meanutprun_01.nii
#
# hlp17umm01549_05224 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm01543_05181 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm01539_05154 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm01532_05160 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm01508_05049 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has utprun_01.nii but no realign.data in /restingabcd
# hlp17umm01500_05193 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm01492_05182 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm01483_05200 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm01405_03782 - 1. NO anatomy!! yet completed scans!!
# hlp17umm01371_05133 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm01346_03445 - 1. has t1sag_208/ instead of t1mprage_208/; 2. NO run_01.nii in restingabcd/
# hlp17umm01252_05187 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm01246_05153 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm01151_04164 - 1. has t1sag_208/ instead of t1mprage_208/; 2. has only run_01.nii in /restingabcd
# hlp17umm00773_03440 - 1. NO run_01.nii and realign.dat in /restingabcd!!
