%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% If you have any questions read the pdf documentation or contact
%%% MethodsCore at methodscore@umich.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

%TODO:: add script to move generated motion.pdf to Git folders!!
% shell script way:
% for f in $(ls -d DrD_scan*); do cd ${f}/func; cp MotionSummary_Plot.pdf ~/gpcn/qualitycheck/${f}_MotionSummary_Plot.pdf; cd ../..; done

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Experiment Directory. This can be used later as a template value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Exp = '/nfs/fmri/Analysis/Sean_Working';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The list of subjects
%%% col 1 = subject id as string, col 2 = subject id as number, col 3 = run vector
%%%
%%% If using realignment parameters from SPM, the first run listed in the
%%% run vector (column 3 argument) is assumed to be the first run selected
%%% for realignment during preprocessing. This is important for
%%% calculating between run motion. If the runs do not match, the
%%% motion summary plots for a subject will not make sense.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SEAN:: specify model for output filename
Model = 'ABCDResting_1stbatch';
% Model = 'Scott_CPM_scrub';

SubjDir = {
  % === ABCD Resting 1st batch Nov21 as of 11/21/2018, 12:00:34 PM
  'madc0732_scan1',1,[1];
  'madc0768_scan1',1,[1];
  % 'madc0773_scan1',1,[1];  # !!fs ERROR see fs script
  'madc0775_scan1',1,[1];
  'madc0833_scan1',1,[1];
  'madc0960_scan1',1,[1];
  'madc1053_scan1',1,[1];
  'madc1066_scan1',1,[1];
  'madc1143_scan1',1,[1];
  % 'madc1151_scan1',1,[1];  % !!fs ERROR see fs script
  'madc1174_scan1',1,[1];
  'madc1179_scan1',1,[1];
  'madc1220_scan1',1,[1];
  'madc1227_scan1',1,[1];
  'madc1228_scan1',1,[1];
  'madc1241_scan1',1,[1];
  'madc1243_scan1',1,[1];
  % 'madc1246_scan1',1,[1];  % !!fs ERROR see fs script
  'madc1250_scan1',1,[1];
  % 'madc1252_scan1',1,[1];  % !!fs ERROR see fs script
  'madc1254_scan1',1,[1];
  'madc1259_scan1',1,[1];
  'madc1260_scan1',1,[1];
  'madc1263_scan1',1,[1];
  'madc1268_scan1',1,[1];
  'madc1271_scan1',1,[1];
  'madc1276_scan1',1,[1];
  'madc1294_scan1',1,[1];
  'madc1299_scan1',1,[1];
  'madc1307_scan1',1,[1];
  'madc1314_scan1',1,[1];
  'madc1315_scan1',1,[1];
  'madc1340_scan1',1,[1];
  % 'madc1346_scan1',1,[1];  % !!fs ERROR see fs script
  'madc1348_scan1',1,[1];
  'madc1353_scan1',1,[1];
  'madc1356_scan1',1,[1];
  'madc1357_scan1',1,[1];
  'madc1358_scan1',1,[1];
  'madc1360_scan1',1,[1];
  'madc1362_scan1',1,[1];
  'madc1364_scan1',1,[1];
  'madc1368_scan1',1,[1];
  % 'madc1371_scan1',1,[1];  % !!fs ERROR see fs script
  'madc1372_scan1',1,[1];
  'madc1374_scan1',1,[1];
  'madc1377_scan1',1,[1];
  'madc1378_scan1',1,[1];
  'madc1379_scan1',1,[1];
  'madc1380_scan1',1,[1];
  'madc1382_scan1',1,[1];
  'madc1384_scan1',1,[1];
  'madc1387_scan1',1,[1];
  'madc1388_scan1',1,[1];
  'madc1389_scan1',1,[1];
  'madc1393_scan1',1,[1];
  'madc1394_scan1',1,[1];
  'madc1395_scan1',1,[1];
  'madc1396_scan1',1,[1];
  'madc1398_scan1',1,[1];
  'madc1399_scan1',1,[1];
  'madc1401_scan1',1,[1];
  'madc1402_scan1',1,[1];
  'madc1403_scan1',1,[1];
  'madc1404_scan1',1,[1];
  % 'madc1405_scan1',1,[1];  % !!fs ERROR see fs script
  'madc1407_scan1',1,[1];
  'madc1408_scan1',1,[1];
  'madc1409_scan1',1,[1];
  'madc1410_scan1',1,[1];
  'madc1411_scan1',1,[1];
  'madc1412_scan1',1,[1];
  'madc1413_scan1',1,[1];
  'madc1415_scan1',1,[1];
  'madc1418_scan1',1,[1];
  'madc1419_scan1',1,[1];
  'madc1420_scan1',1,[1];
  'madc1421_scan1',1,[1];
  'madc1422_scan1',1,[1];
  'madc1423_scan1',1,[1];
  'madc1424_scan1',1,[1];
  'madc1425_scan1',1,[1];
  'madc1426_scan1',1,[1];
  'madc1430_scan1',1,[1];
  'madc1432_scan1',1,[1];
  'madc1434_scan1',1,[1];
  'madc1437_scan1',1,[1];
  'madc1438_scan1',1,[1];
  'madc1439_scan1',1,[1];
  'madc1440_scan1',1,[1];
  'madc1442_scan1',1,[1];
  'madc1444_scan1',1,[1];
  'madc1445_scan1',1,[1];
  'madc1446_scan1',1,[1];
  'madc1447_scan1',1,[1];
  'madc1448_scan1',1,[1];
  'madc1449_scan1',1,[1];
  'madc1453_scan1',1,[1];
  'madc1454_scan1',1,[1];
  'madc1457_scan1',1,[1];
  'madc1458_scan1',1,[1];
  'madc1459_scan1',1,[1];
  'madc1461_scan1',1,[1];
  'madc1462_scan1',1,[1];
  'madc1463_scan1',1,[1];
  'madc1473_scan1',1,[1];
  'madc1479_scan1',1,[1];
  'madc1480_scan1',1,[1];
  'madc1482_scan1',1,[1];
  % 'madc1483_scan1',1,[1];  % !!fs ERROR see fs script
  'madc1484_scan1',1,[1];
  'madc1487_scan1',1,[1];
  'madc1489_scan1',1,[1];
  % 'madc1492_scan1',1,[1];  % !!fs ERROR see fs script
  'madc1493_scan1',1,[1];
  'madc1494_scan1',1,[1];
  % 'madc1500_scan1',1,[1];  % !!fs ERROR see fs script
  'madc1501_scan1',1,[1];
  'madc1507_scan1',1,[1];
  % 'madc1508_scan1',1,[1];  % !!fs ERROR see fs script
  % 'madc1532_scan1',1,[1];  % !!fs ERROR see fs script
  % 'madc1539_scan1',1,[1];  % !!fs ERROR see fs script
  % 'madc1543_scan1',1,[1];  % !!fs ERROR see fs script
  % 'madc1549_scan1',1,[1];  % !!fs ERROR see fs script
  };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% List all your run directories. Column 3 from the SubjDir variable
%%% uses those numbers for each subject to select runs names from the
%%% RunDir variable. These are then substituted into the [Run] template.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RunDir = {
  'run_01';
};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Path where the motion correction parameter files are located
%
% Variables you can use in your template are:
%       Exp = path to your experiment directory
%       Subject = name of subject from SubjDir (using iSubject as index of row)
%       Run = name of run from RunDir (using iRun as index of row)
%        * = wildcard (can only be placed in final part of template)
% Examples:
% MotionPathTemplate = '[Exp]/Subjects/[Subject]/func/run_0[iRun]/realign.dat';
% MotionPathTemplate = '[Exp]/Subjects/[Subject]/TASK/func/[Run]/rp_arun_*.txt'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MotionPathTemplate = '[Exp]/Subjects_ABCDResting/[Subject]/func/[Run]/realign.dat';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Name and path for the output CSV files (leave off the .csv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OutputPathTemplate = '[Exp]/Git_MADC/qualitycheck/[Model]_MotionSummary_FD_[num2str(FDcriteria)]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Name and path for the output censor vectors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OutputCensorVector = '[Exp]/Subjects_ABCDResting/[Subject]/func/[Run]/CensorVector';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OutputPlotPath - Path to save motion plots. Each subject is printed
%%%                    its own motion summary plot.
%%% OutputPlotFile - File name for motion summary plot. The plot will
%%%                    be saved as a pdf. No file extension is needed in the
%%%                    variable value.
%%%
%%% Leave OuptutPlotPath as empty string ('') if no plots are desired.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OutputPlotPath = '[Exp]/Subjects_ABCDResting/[Subject]/func/';
OutputPlotFile = 'MotionSummary_Plot';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Lever arm (typically between 50-100mm)
%%% The lever arm is used to calculate a Eudclidean displacement metric for
%%% both the rotational and translational motion parameters.  It defines
%%% the distance from fulcrum of head to furthest edge.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LeverArm = 50;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% FD Lever arm (typically between 50-100mm) for FD calculation
%%% The FD lever arm is used to calculate the framewise displacement
%%% metric.  It is approximately the mean distance from the cerebral cortex
%%% to the center of the head.  See Power et al 2011.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FDLeverArm = 50;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% FDcritera is a threshold value.  A censor vector is created for each
%%% frame that exceeds the FDcriteria. It has units of mm.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FDcriteria = 0.5; %Sean changed from 0.3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% How do you want to report the results
%%% OutputMode
%%%                  1   ----  report results for each run
%%%                  2   ----  report average results over runs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OutputMode = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Path where your logfiles will be stored
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LogTemplate = '[Exp]/Git_MADC/qualitycheck/MotionSummary_Logs';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Other frames to exclude.
%%% FramesBefore is the number of frames before a censored frame to create
%%% sensor vectors as well.  FramesAfter is the number of frames after a
%%% censored frame to create sensor vectors as well.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FramesBefore = 0;
FramesAfter = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% RealignType states what program (FSL or SPM) was used to realign the
%%% functional images. This is important, because SPM and FSL write the
%%% motion parameters in different orders. Also functional images realigned
%%% in SPM require the motion between runs to be recalculated. Typically,
%%% SPM motion parameter files match the regular expression rp_*.txt.
%%% realignfMRI from spm8Batch uses mcflirt from FSL to realign functional
%%% images. They typically match the regular expression mcflirt*.dat.
%%%
%%% 1 = SPM motion parameters
%%% 2 = FSL motion parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RealignType = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PreRealignTemplate is the template to the functional file input into
%%% the realignment step. Typically, realignment occurs after slice time
%%% correction, so the prefix is most likely the slice-timed corrected
%%% functional images. This variable is only used if RealignType = 1 for
%%% SPM realigned functional files and OutputPlotPath is not set to the empty
%%% string. These files are need to calculate the motion between runs.
%%% The associated *.mat files must exist to calculate motion between runs.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PreRealignTemplate = '[Exp]/Subjects_ABCDResting/[Subject]/func/[Run]/trun*.nii';

global mcRoot;

mcRoot = '/opt/apps/MCore2'
addpath(fullfile(mcRoot,'matlabScripts'))
addpath(fullfile(mcRoot,'QualityChecks','CheckMotion'))
addpath(fullfile(mcRoot,'SPM','SPM8','spm8_with_R4667'))

% Sean:: creating Diary
diary('MotionCheck_Matlab_Console_ABCDResting_output.txt')

% spacing
fprintf(2, '\n');
disp(['======== NEW session!! ==========  ', datestr(clock), '  ==================']);

% actual MC command to run
MotionSummary_mc_central

% adding spacing dividers
fprintf(2, '\n');

% Copying output pdfs to git folder
for iSubject = 1:size(SubjDir,1)

    % setting up subject and subject file path
    Subject = SubjDir{iSubject, 1};
    out_path = mc_GenPath(OutputPlotPath);
    dest_path = mc_GenPath('[Exp]/Git_MADC/qualitycheck');

    % setting up destination file path
    out_filepath = fullfile(out_path, strcat(OutputPlotFile, '.pdf'));
    dest_filepath = fullfile(dest_path, strcat(Subject, '_', OutputPlotFile, '.pdf'));

    % copy output pdf to git folder
    try
      [status, msg] = copyfile(out_filepath, dest_filepath);
      if (status == 1)
        fprintf('Success!! Copied to -\n');
        fprintf('%s\n', dest_filepath);
      end
    catch
      warning('Error finding MotionSummary_Plot.pdf !!')
    end

end

% adding spacing dividers
fprintf(2, '\n');
disp(['======== Session ENDED!! ==========  ', datestr(clock), '  ==================']);

% shut off diary
diary off
