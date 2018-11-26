% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Copyright Robert C. Welsh
% Ann Arbor, Michigan 2005
% 
% This is to be used with the UMBatch System for SPM8.
%
% This is to SMOOTH IMAGES.
%
% You must point to the batch processing code
%
% e.g.
%
%  addpath /net/dysthymia/spm8
%  addpath /net/dysthymia/spm8Batch
%
% 
% You need to fill the following variables:
%
%   UMBatchMaster  =   point to the directory of the experiment.
%
%   UMBatchSubjs   =   list of subjects within experiment. Space
%                      pad if need be.
%
%   UMKernel       =   smoothing kernel, either a scalar or a
%                      3-vector (e.g. 5 or [5 6 6])
%
%   UMImgDIRS      =   directory to which to find images.
%                      (full path name)
%
%   UMVolumeWild   =   wild card name for images
%                      (e.g. "ravol_*.img')
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Make sure the UM Batch system is installed.

if exist('UMBatchPrep') ~= 2 | exist('UMBatchCoReg') ~= 2
    fprintf('You need to have the UM Batch system\n');
    resuts = -69;
    UMCheckFailure(results);
    exit(abs(results))
end

% 
% Prepare the batch processes
%

results = UMBatchPrep;

if UMCheckFailure(results)
  exit(abs(results))
end

% --------------- END OF PART I ----------------------
 
% This part placed by 'smoothfMRI' auto script
 
% 
% 
% This script is called :  
% 
% /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/smoothfMRI/2018_11/smoothfMRI_181121_17_29_56_435_tehsheng_madcbrai.m
% 
% and create on 181121_17_29_56_435
% 
 
UMBatchMaster = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess';
 

% If the abort file varialbe is set then we
% can write status of the failure there.

global UMBatchStatusFile
UMBatchStatusFile = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1227_scan1_validation_umstream_status_file';

UMTestFlag    = 0;
UMKernel       = [5 5 5];
UMVolumeWild   = 'vbm8_w3mm_utprun_';
UMVolumeExt    = '.*.nii';
OutputName     = 's5';
SandBoxDIR     = '/madcbrain/sandbox//';
SandBoxPID     = '/';
UMBatchSubjs  = {...
      'madc1227_scan1';...
                 };
 
UMImgDIRS    = {...
                 {'/nfs/fmri/Analysis/Sean_Working/Subjects_ABCDResting/madc1227_scan1/func/run_01'};...
                };

% --------------- BEGINNING OF PART II ----------------------
%
% If all of the subjects are in the same organization scheme
% then you should not have to modify this piece of code from this point 
% forward.

%
% Loop over the subjects and smooth each one.
%

curDIR = pwd;

warning off

for iSub = 1:length(UMBatchSubjs)
  WorkingSubject = [deblank(UMBatchMaster) '/' UMBatchSubjs{iSub}];
  for iRun = 1:length(UMImgDIRS{iSub})
    cd(UMImgDIRS{iSub}{iRun});
    %
    % Find out if they are using a sandbox for the smoothing.
    %
    [CS SandBoxPID Images2Write] = moveToSandBox(UMImgDIRS{iSub}{iRun},UMVolumeWild,SandBoxPID,UMVolumeExt);
    %P = spm_select('ExtFPList',UMImgDIRS{iSub}{iRun},['^' UMVolumeWild '.*.nii'],inf);
    fprintf('Smoothing %d "%s" images in %s with %2.1f %2.1f %2.1f\n',size(Images2Write,1),UMVolumeWild,UMImgDIRS{iSub}{iRun},UMKernel(1),UMKernel(2),UMKernel(3));
    results = UMBatchSmooth(Images2Write,UMKernel,OutputName,UMTestFlag);
    if UMCheckFailure(results)
      exit(abs(results))
    end
    %
    % Now move back out of sandbox if so specified
    %
    CSBACK = moveOutOfSandBox(UMImgDIRS{iSub}{iRun},UMVolumeWild,SandBoxPID,OutputName,CS);
  end
end

fprintf('\nAll done with smoothing images.\n');

cd(curDIR);

%
% all done.
%
