%
% Copyright Robert C. Welsh
% Ann Arbor, Michigan 2005
% 
% This is to be used with the UMBatch System for SPM2.
%
% To CoRegister Image together using batch use the following code.
%

% You must point to the batch processing code
%
%  addpath /net/dysthymia/spm8
%  addpath /net/dysthymia/spm8Batch
%

% You need to fill the following variables:
%
%   UMBatchMaster  =   point to the directory of the experiment.
%
%   UMImgPairs     =   {}{} array subject x image pairs.
%                       first images is Object, second is target.
%
%   UMBatchSubjs   =   list of subjects within experiment. Space
%                      pad if need be.
%
%   UMReSlice      =   0 -> don't reslice the image.
%                      1 -> reslice the image.
%                      2 -> reslice w/o coreg NOT IMPLEMENTED YET!

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Make sure the UM Batch system is installed.

if exist('UMBatchPrep') ~= 2 | exist('UMBatchCoReg') ~= 2
    fprintf('You need to have the UM Batch system\n');
    results = -69;
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

% - - - - - - - - - - END OF PART I - - - - - - - - - - - - -
 
% This part placed by 'coregOverlay' auto script
 
% 
% 
% This script is called :  
% 
% /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/coregOverlay/2018_11/coregOverlay_181121_19_34_03_003_tehsheng_madcbrai.m
% 
% and create on 181121_19_34_03_003
% 
 
UMBatchMaster = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess';
 

% If the abort file varialbe is set then we
% can write status of the failure there.

global UMBatchStatusFile
UMBatchStatusFile = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1387_scan1_validation_umstream_status_file';

UMTestFlag    = 0;
 
UMReSlice     = 0
 
UMImgWildCard = 'utprun_*.nii';
 
UMBatchSubjs  = {...
      'madc1387_scan1';...
                 };
 
UMImgPairs    = {...
{ '/nfs/fmri/Analysis/Sean_Working/Subjects_ABCDResting/madc1387_scan1/func/coReg/t1mprage.nii','/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/../../Subjects_ABCDResting/madc1387_scan1/func//run_01/utprun_01.nii' };...
                };
 
UMOtherImages = {...
{
};...
};
 
 
% All done 
 
% - - - - - - - - BEGINNING OF PART II - - - - - - - - - - - - -
%
% If all of the subjects are in the same organization scheme
% then you should not have to modify this piece of code from this point 
% forward.

%
% Loop over the subjects and coregister each one.
%

for iSub = 1:size(UMBatchSubjs,1)
    TargetImageFull = UMImgPairs{iSub}{2};
    ObjectImageFull = UMImgPairs{iSub}{1};
    fprintf('\n\nCalling UMBatchCoReg with:\n')
    fprintf('%s\n',TargetImageFull);
    fprintf('%s\n',ObjectImageFull);
    fprintf('UMReSlice:%d\n',UMReSlice);
    results = UMBatchCoReg(TargetImageFull,ObjectImageFull,UMOtherImages{iSub},UMReSlice,UMTestFlag);
    if UMCheckFailure(results)
      exit(abs(results))
    end
end

fprintf('\nAll done with coregistration.\n');

%
% all done.
%
