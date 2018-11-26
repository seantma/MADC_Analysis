%
% Copyright Robert C. Welsh
% Ann Arbor, Michigan 2005
% 
% This is to be used with the UMBatch System for SPM8.
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
%   ParamImage     =   image for determining the normalization.
%
%   UMBatchSubjs   =   list of subjects within experiment. Space
%                      pad if need be.
%


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Make sure the UM Batch system is installed.

if exist('UMBatchPrep') ~= 2 | exist('UMBatchVBM8') ~= 2
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

% - - - - - - - END OF PART I - - - - - - - - - - - - - - - - -


 
 
% This part placed by 'vbm8HiRes' auto script
% This part placed by 'vbm8HiRes' auto script
 
 
% 
% 
% 
% 
% This script is called :  
% This script is called :  
% 
% 
% /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/vbm8HiRes/2018_11/vbm8HiRes_181121_17_33_56_276_tehsheng_madcbrai.m
% /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/vbm8HiRes/2018_11/vbm8HiRes_181121_17_33_56_276_tehsheng_madcbrai.m
% 
% 
% and create on 181121_17_33_56_276
% and create on 181121_17_33_56_276
% 
% 
 
 
UMBatchMaster = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess';
UMBatchMaster = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess';
 
 


% If the abort file varialbe is set then we
% If the abort file varialbe is set then we
% can write status of the failure there.
% can write status of the failure there.


global UMBatchStatusFile
global UMBatchStatusFile
UMBatchStatusFile = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1228_scan1_validation_umstream_status_file';
UMBatchStatusFile = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1422_scan1_validation_umstream_status_file';


UMTestFlag    = 0;
UMTestFlag    = 0;
VoxelSize      = 0;
VoxelSize      = 0;
VBM8RefImage   = '/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313/templates//r3mm_avg152T1.nii';
VBM8RefImage   = '/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313/templates//r3mm_avg152T1.nii';
OutputName     = 'vbm8_w3mm_';
OutputName     = 'vbm8_w3mm_';
BIASFIELDFLAG  = 1;
BIASFIELDFLAG  = 1;
UMBatchSubjs  = {...
UMBatchSubjs  = {...
      'madc1228_scan1';...
      'madc1422_scan1';...
                 };
                 };
 
 
UMImg2Warp    = {...
UMImg2Warp    = {...
'/nfs/fmri/Analysis/Sean_Working/Subjects_ABCDResting/madc1422_scan1/func/coReg/vbm8/t1mprage.nii';...
'/nfs/fmri/Analysis/Sean_Working/Subjects_ABCDResting/madc1228_scan1/func/coReg/vbm8/t1mprage.nii';...
                };
                };
 
 
UMOtherImages = {...
UMOtherImages = {...
{
{
};...
};...
};
 
};
 

% - - - - - - - START OF PART II - - - - - - - - - - - - - - - 

% Deblank just in case.

UMBatchMaster = deblank(UMBatchMaster);

% If all of the subjects are in the same organization scheme
% then you should not have to modify this piece of code from this point 
% forward.

fprintf('\nWarping images using UMBatchVBM8\n');

fprintf('Looping on the subjects now\n\n');

%
% Loop over the subjects and coregister each one.
%

for iSub = 1:length(UMBatchSubjs)
    %
    fprintf('Working on %s\n',UMBatchSubjs{iSub});
    %
    % Break into two steps, one to calculate the normalization for the
    % SPGR.
    %
    ParamImage = UMImg2Warp{iSub};
    %
    % Make sure the image exists.
    %
    ParamImage=UMImg2Warp{iSub};
    Img2Write=[];
    for iW = 1:length(UMOtherImages{iSub})
      Img2Write = strvcat(Img2Write,[UMOtherImages{iSub}{iW},',1']);
    end
    if exist(ParamImage) == 2
      results = UMBatchVBM8(ParamImage,VBM8RefImage,Img2Write,UMTestFlag,VoxelSize,OutputName,BIASFIELDFLAG);
      if UMCheckFailure(results)
	exit(abs(results))
      end
    else      
      fprintf('FATAL ERROR : Image to warpVBM8 process does not exist: %s\n',ParamImage)
      results = -65;
      UMCheckFailure(results);
      exit(abs(results))
    end
end

fprintf('\nAll done with warpingVBM8 processing of High Resolution image.\n');

%
% All done.
%

% - - - - - - - START OF PART II - - - - - - - - - - - - - - - 

% Deblank just in case.

UMBatchMaster = deblank(UMBatchMaster);

% If all of the subjects are in the same organization scheme
% then you should not have to modify this piece of code from this point 
% forward.

fprintf('\nWarping images using UMBatchVBM8\n');

fprintf('Looping on the subjects now\n\n');

%
% Loop over the subjects and coregister each one.
%

for iSub = 1:length(UMBatchSubjs)
    %
    fprintf('Working on %s\n',UMBatchSubjs{iSub});
    %
    % Break into two steps, one to calculate the normalization for the
    % SPGR.
    %
    ParamImage = UMImg2Warp{iSub};
    %
    % Make sure the image exists.
    %
    ParamImage=UMImg2Warp{iSub};
    Img2Write=[];
    for iW = 1:length(UMOtherImages{iSub})
      Img2Write = strvcat(Img2Write,[UMOtherImages{iSub}{iW},',1']);
    end
    if exist(ParamImage) == 2
      results = UMBatchVBM8(ParamImage,VBM8RefImage,Img2Write,UMTestFlag,VoxelSize,OutputName,BIASFIELDFLAG);
      if UMCheckFailure(results)
	exit(abs(results))
      end
    else      
      fprintf('FATAL ERROR : Image to warpVBM8 process does not exist: %s\n',ParamImage)
      results = -65;
      UMCheckFailure(results);
      exit(abs(results))
    end
end

fprintf('\nAll done with warpingVBM8 processing of High Resolution image.\n');

%
% All done.
%
