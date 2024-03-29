%
% Copyright Robert C. Welsh
% Ann Arbor, Michigan 2005
% 
% This is to be used with the UMBatch System for SPM2.
%
% To Warp image  using batch use the following code.
%

% You must point to the batch processing code
%
%  addpath /net/dysthymia/spm8Batch
%

% You need to fill the following variables:
%
%   UMBatchMaster  =   point to the directory of the experiment.
%
%   TemplateImage  =   image that represents the normalized space.
%                      if [], then no determination made.
%
%   UMImg2Warp     =   A {} array of image names to warp to the 
%                      standard template.
%
%   ParamImage     =   image for determining the normalization.
%
%   ObjectMask     =   image mask for warping - default is [];
%
%   Images2Write   =   image to warp.
%                      if [], then no images to write normalize.
%
% 
%        If you are needing to write alot of images out I suggest you use 
%        a command like this:
%  
%              Images2Write = spm_get('files',ImagesDir,'ravol*.img');
%
%        where "ImagesDir" is the directory where the images live. You can of 
%        course put a loop around to write normalize each run seperately etc.
%
%   UMBatchSubjs   =   list of subjects within experiment. Space
%                      pad if need be.
%


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Make sure the UM Batch system is installed.

if exist('UMBatchPrep') ~= 2 | exist('UMBatchWarp') ~= 2
    fprintf('You need to have the UM Batch system\n');
    return
end

% 
% Prepare the batch processes
%

results = UMBatchPrep;

if UMCheckFailure(results)
  exit(abs(results));
end


% - - - - - - - END OF PART I - - - - - - - - - - - - - - - - -


 
% This part placed by 'warpfMRI' auto script
 
% 
% 
% This script is called :  
% 
% /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/warpfMRI/2018_06/warpfMRI_180604_21_56_26_381_tehsheng_madcbrai.m
% 
% and create on 180604_21_56_26_381
% 
 
UMBatchMaster = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess';
 

% If the abort file varialbe is set then we
% can write status of the failure there.

global UMBatchStatusFile
UMBatchStatusFile = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1396_scan1_validation_umstream_status_file';

UMTestFlag    = 0;
TemplateImage  = '/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313/templates//T1.nii';
VoxelSize      = 0;
WARPMETHOD     = 1;
VBM8RefImage   = '/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313/templates//r3mm_avg152T1.nii';
OutputName     = 'vbm8_w3mm_';
SandBoxDIR     = '/madcbrain/sandbox//';
SandBoxPID     = '/';
UMBatchSubjs  = {...
      'madc1396_scan1';...
                 };
 
UMVolumeWild  = 'utprun_';
UMImgDIRS    = {...
                 {'/nfs/fmri/Analysis/Subjects_oldResting/madc1396_scan1/func/run_01'};...
                };
 UMHighRes    = {...
'/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/../../../Subjects_oldResting/madc1396_scan1/func//coReg/vbm8/t1mprage.nii';...
                };
% - - - - - - - -BEGINNING OF PART II - - - - - - - - - - - - -

% Deblank just in case.

UMBatchMaster = strtrim(UMBatchMaster);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

fprintf('Looping on the subjects now\n\n');

%
% Loop over the subjects and coregister each one.
%

for iSub = 1:length(UMBatchSubjs)
  %
  fprintf('Working on %s\n',UMBatchSubjs{iSub})
  % 
  % Use the subjects SPGR that was previously normalized
  % to write normalize the fMRI volumes.
  %
  ParamImage = UMHighRes{iSub};
  % Loop on the runs and get the names of the files to normalize.
  % We use the "spm_get('files',[directory],[file wildcard])" command
  % to get the list of files.
  %
  for iRun = 1:length(UMImgDIRS{iSub})
    %
    % Find out if they are using a sandbox for the warping.
    %
    [CS SandBoxPID Images2Write] = moveToSandBox(UMImgDIRS{iSub}{iRun},UMVolumeWild,SandBoxPID);
    nFiles = size(Images2Write,1);
    fprintf('Normalizing a total of %d %s''s\n',nFiles,UMVolumeWild);
    % 
    % The other step to apply the normalization to the SPGR.
    %
    if WARPMETHOD
      results = UMBatchWarp([],ParamImage,VBM8RefImage,Images2Write,UMTestFlag,VoxelSize,OutputName,WARPMETHOD);      
    else
      results = UMBatchWarp([],ParamImage,[],Images2Write,UMTestFlag,VoxelSize,OutputName,WARPMETHOD);      
    end
    if UMCheckFailure(results)
      exit(abs(results));
    end
    %
    % Now move back out of sandbox if so specified
    %
    CSBACK = moveOutOfSandBox(UMImgDIRS{iSub}{iRun},UMVolumeWild,SandBoxPID,OutputName,CS);
  end
end

fprintf('\nAll done with warping of fMRIs to template using HiResolution data.\n');

%
% All done.
%
