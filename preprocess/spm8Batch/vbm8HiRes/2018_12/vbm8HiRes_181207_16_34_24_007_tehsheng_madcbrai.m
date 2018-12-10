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
% /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/vbm8HiRes/2018_12/vbm8HiRes_181207_16_34_24_007_tehsheng_madcbrai.m
% /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/vbm8HiRes/2018_12/vbm8HiRes_181207_16_34_24_007_tehsheng_madcbrai.m
% 
% 
% and create on 181207_16_34_24_007
% 
% and create on 181207_16_34_24_007
 
% 
UMBatchMaster = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess';
 
 

UMBatchMaster = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess';
% If the abort file varialbe is set then we
 
% can write status of the failure there.


% If the abort file varialbe is set then we
global UMBatchStatusFile
% can write status of the failure there.
UMBatchStatusFile = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1417_5641_validation_umstream_status_file';


global UMBatchStatusFile
UMTestFlag    = 0;
UMBatchStatusFile = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1543_5181_validation_umstream_status_file';
VoxelSize      = 0;

VBM8RefImage   = '/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313/templates//PET.nii';
UMTestFlag    = 0;
OutputName     = 'vbm8_w2mm_';
VoxelSize      = 0;
BIASFIELDFLAG  = 1;
VBM8RefImage   = '/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313/templates//PET.nii';
OutputName     = 'vbm8_w2mm_';
UMBatchSubjs  = {...
BIASFIELDFLAG  = 1;
      'madc1417_5641';...
UMBatchSubjs  = {...
                 };
      'madc1543_5181';...
 
                 };
UMImg2Warp    = {...
 
UMImg2Warp    = {...
'/nfs/fmri/Analysis/Sean_Working/Subjects_ASL/madc1417_5641/func/coReg/vbm8/t1spgr.nii';...
                };
'/nfs/fmri/Analysis/Sean_Working/Subjects_ASL/madc1543_5181/func/coReg/vbm8/t1spgr.nii';...
 
                };
UMOtherImages = {...
 
{
UMOtherImages = {...
};...
{
};
};...
 
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
