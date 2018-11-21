#!/bin/bash
#
#
# Robert C. Welsh
#
# Copyright 2013
#
# This stream is for testing the spm8Batch system
# To run this you should be in a directory with the subject master
# folder just below you. Then issue the command
#
# --------------------------------------------------
#
# Sean Ma, modified, Dec 2016
#
# 12/15/2016, Modified for automation purpose (single subject)
# 12/22/2016, added loop for multi subjects
#
# How to run:
# sh ./preprocessing_ABCDResting.sh
# How to check error:
#
# --------------------------------------------------

# Subject list based off of `file_struct.sh` output: `file_struct_out_1222_2016.txt`
# Does not contain filtered out subjects from QC check

subjIDs=(
# === ABCD Resting 1st batch Nov21 as of 11/21/2018, 12:00:34 PM
# Batch 1
madc0732_scan1
madc0768_scan1
# madc0773_scan1  # !!fs ERROR see fs script
madc0775_scan1
madc0833_scan1
madc0960_scan1
madc1053_scan1
madc1066_scan1
madc1143_scan1
# madc1151_scan1  # !!fs ERROR see fs script
madc1174_scan1
madc1179_scan1
madc1220_scan1
madc1227_scan1
madc1228_scan1
madc1241_scan1
madc1243_scan1
# madc1246_scan1  # !!fs ERROR see fs script
madc1250_scan1
# madc1252_scan1  # !!fs ERROR see fs script
madc1254_scan1
madc1259_scan1
madc1260_scan1
madc1263_scan1
madc1268_scan1
madc1271_scan1
madc1276_scan1
madc1294_scan1
madc1299_scan1
madc1307_scan1
madc1314_scan1
madc1315_scan1
madc1340_scan1
# # madc1346_scan1  # !!fs ERROR see fs script
# madc1348_scan1
# madc1353_scan1
# madc1356_scan1
# madc1357_scan1
# madc1358_scan1
# madc1360_scan1
# madc1362_scan1
# madc1364_scan1
# madc1368_scan1
# # madc1371_scan1  # !!fs ERROR see fs script
# madc1372_scan1
# madc1374_scan1
# madc1377_scan1
# madc1378_scan1
# madc1379_scan1
# madc1380_scan1
# madc1382_scan1
# madc1384_scan1
# madc1387_scan1
# madc1388_scan1
# madc1389_scan1
# madc1393_scan1
# madc1394_scan1
# madc1395_scan1
# madc1396_scan1
# madc1398_scan1
# madc1399_scan1
# madc1401_scan1
# madc1402_scan1
# madc1403_scan1
# madc1404_scan1
# # madc1405_scan1  # !!fs ERROR see fs script
# madc1407_scan1
# madc1408_scan1
# madc1409_scan1
# madc1410_scan1
# madc1411_scan1
# madc1412_scan1
# madc1413_scan1
# madc1415_scan1
# madc1418_scan1
# madc1419_scan1
# madc1420_scan1
# madc1421_scan1
# madc1422_scan1
# madc1423_scan1
# madc1424_scan1
# madc1425_scan1
# madc1426_scan1
# madc1430_scan1
# madc1432_scan1
# madc1434_scan1
# madc1437_scan1
# madc1438_scan1
# madc1439_scan1
# madc1440_scan1
# madc1442_scan1
# madc1444_scan1
# madc1445_scan1
# madc1446_scan1
# madc1447_scan1
# madc1448_scan1
# madc1449_scan1
# madc1453_scan1
# madc1454_scan1
# madc1457_scan1
# madc1458_scan1
# madc1459_scan1
# madc1461_scan1
# madc1462_scan1
# madc1463_scan1
# madc1473_scan1
# madc1479_scan1
# madc1480_scan1
# madc1482_scan1
# # madc1483_scan1  # !!fs ERROR see fs script
# madc1484_scan1
# madc1487_scan1
# madc1489_scan1
# # madc1492_scan1  # !!fs ERROR see fs script
# madc1493_scan1
# madc1494_scan1
# # madc1500_scan1  # !!fs ERROR see fs script
# madc1501_scan1
# madc1507_scan1
# # madc1508_scan1  # !!fs ERROR see fs script
# # madc1532_scan1  # !!fs ERROR see fs script
# # madc1539_scan1  # !!fs ERROR see fs script
# # madc1543_scan1  # !!fs ERROR see fs script
# # madc1549_scan1  # !!fs ERROR see fs script
)

for SUBJECT in ${subjIDs[@]}
do

  LOCAL_LOG=full_stream_${SUBJECT}_validation.log

  THEDATE=`date`

  echo
  echo Start $THEDATE
  echo

  THISDIR=`pwd`
  export UMSTREAM_STATUS_FILE=${THISDIR}/${SUBJECT}_validation_umstream_status_file

  let STAGE=0

  #let STAGE++
  #PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  #echo
  #echo "* * * * * * *sliceTime8 * * * * * * *"
  #echo
  #sliceTime8 -M ../../Subjects_ABCDResting ${SUBJECT} -v run_ -n t -B &> ${PSTAGE}_${LOCAL_LOG}
  #cat ${UMSTREAM_STATUS_FILE}

  #let STAGE++
  #PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  #echo
  #echo "* * * * * * *realignfMRI * * * * * * *"
  #echo
  #realignfMRI -M ../../Subjects_ABCDResting ${SUBJECT} -v trun_ -n r -A -B &> ${PSTAGE}_${LOCAL_LOG}
  #cat ${UMSTREAM_STATUS_FILE}

  # !! Note no t1overlay.nii ==> using `coregOverlay` to coregister directly rtprun.nii to t1spgr.nii !!
  let STAGE++
  PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  echo
  echo "* * * * * * *coregOverlay* * * * * * "
  echo
  coregOverlay -M ../../Subjects_ABCDResting ${SUBJECT} -v utprun_ -o t1mprage -B &> ${PSTAGE}_${LOCAL_LOG}
  cat ${UMSTREAM_STATUS_FILE}

  # !! Note no t1overlay.nii ==> using `coregOverlay` to coregister directly rtprun.nii to t1spgr.nii !!
  # let STAGE++
  # PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  # echo
  # echo "* * * * * * *coregHiRes* * * * * * "
  # echo
  # coregHiRes -M ../../Subjects_ABCDResting ${SUBJECT} -o ht1overlay -h t1mprage -B &> ${PSTAGE}_${LOCAL_LOG}
  # cat ${UMSTREAM_STATUS_FILE}

  # let STAGE++
  # PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  # echo
  # echo "* * * * * * *newSeg* * * * * * "
  # echo
  # newSeg -a func/coReg -w func/coReg/newSeg -M ./ ${SUBJECT} -h t1mprage -I r3mm_avg152T1 -n wns3mm_ -B &> ${PSTAGE}_${LOCAL_LOG}
  # cat ${UMSTREAM_STATUS_FILE}
  #
  # let STAGE++
  # PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  # echo
  # echo "* * * * * * *warpfMRI* * * * * * "
  # echo
  # warpfMRI -W -w coReg/newSeg -M ./ ${SUBJECT} -h t1mprage -v rtrun_ -n wns3mm_ -I r3mm_avg152T1 -B &> ${PSTAGE}_${LOCAL_LOG}
  # cat ${UMSTREAM_STATUS_FILE}

  let STAGE++
  PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  echo
  echo "* * * * * * *vbm8HiRes* * * * * * "
  echo
  vbm8HiRes -a func/coReg -w func/coReg/vbm8 -M ../../Subjects_ABCDResting ${SUBJECT} -h t1mprage -n vbm8_w3mm_ -I r3mm_avg152T1 -B &> ${PSTAGE}_${LOCAL_LOG}
  cat ${UMSTREAM_STATUS_FILE}

  let STAGE++
  PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  echo
  echo "* * * * * * *warpfMRI* * * * * * "
  echo
  warpfMRI -W -w coReg/vbm8 -M ../../Subjects_ABCDResting ${SUBJECT} -h t1mprage -v utprun_ -n vbm8_w3mm_ -I r3mm_avg152T1 -B &> ${PSTAGE}_${LOCAL_LOG}
  cat ${UMSTREAM_STATUS_FILE}

  let STAGE++
  PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  echo
  echo "* * * * * * *Smoothing* * * * * * "
  echo
  smoothfMRI 5 5 5 -M ../../Subjects_ABCDResting ${SUBJECT} -v vbm8_w3mm_utprun_ -n s5 -B &> ${PSTAGE}_${LOCAL_LOG}
  cat ${UMSTREAM_STATUS_FILE}

  echo
  echo Finished
  echo

  echo Concatenating logs
  echo
  cat [0,1][0-9]_${LOCAL_LOG} > ${LOCAL_LOG}

  echo
  echo "Completed, full log can be found in ${LOCAL_LOG}"
  echo

  THEDATE=`date`

  echo
  echo Done $THEDATE
  echo

done
