% Custom batch file for ASL processing
%
% Sean Ma
% Dec 2018
%
% This script can do:
% 1. Batch CBF map calibration
% 2. create skull-stripped mask

% Working directory
WorkDir = '/nfs/fmri/Analysis/Sean_Working/Subjects_ASL';

% Reporting directory
ReportDir = '/nfs/fmri/Analysis/Sean_Working/Git_MADC';

% Work on subject folders under Working directory
d = dir(WorkDir);
idir = [d(:).isdir];                          % returns logical vector for dir folders
SubjDir = {d(idir).name}';
SubjDir(ismember(SubjDir,{'.','..'})) = [];   % removing . & ..

% Use regex to match pattern folder
subj_pattern='^madc*_*'    %madc1513_5315, didn't work: 'madc(\d+)_(\d+)'
index = find(~cellfun('isempty', regexp(SubjDir, subj_pattern))); %regex matching 'spi00012_scan1'
SubjDir = SubjDir(index)

% setting up global path for MethodsCore
global mcRoot
mcRoot = '/opt/apps/MCore2';
addpath(fullfile(mcRoot,'SPM','SPM8','spm8_with_R6313'))

% addpath for spm & ASL scripts (including subfolders)
% addpath /mnt/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8
addpath(genpath('/nfs/fmri/Analysis/Sean_Working/Git_MADC/3d_ASL'));

% Logging diary
diary('Batch_cbf_calc_console_Log.txt')
fprintf('\n\n')
disp(['======== Starting session!! ==========  ', datestr(clock), '  ==================']);

% announce numbers of subject folders to process
fprintf('\n')
fprintf('========================================\n')
fprintf('  # of subject folders to process: %d \n', numel(SubjDir))
fprintf('========================================\n\n')

% loop into different contrast directories
for iSubjDir = 1:size(SubjDir)
    fprintf('\n')
    fprintf('=====================================\n')
    fprintf('  NEW Subject: %s \n', SubjDir{iSubjDir})
    fprintf('=====================================\n')

    % setting up full path subject directory
    SubjDirPath = fullfile(WorkDir, SubjDir{iSubjDir});  %for WorkDir/Subject/Modelname structure

    % ----- Skull-Strip section -----
    % use `bet2` for skull-strip and mask generation
    fprintf('\n')
    fprintf('==========================\n')
    fprintf('  Working on Skull-Strip  \n')
    fprintf('==========================\n')

    % change to VBM8 directory
    cd(fullfile(SubjDirPath, 'func', 'coReg', 'vbm8'))
    betCommand = ['bet2 vbm8_w2mm_ht1spgr.nii bet_vbm8_w2mm_ht1spgr -m'];
    unzipCommand = ['gunzip bet_vbm8_w2mm_ht1spgr_mask.nii.gz'];
    fprintf('Skull-strip for subject: %s \n', SubjDir{iSubjDir})
    system(betCommand);
    system(unzipCommand);

    % ----- CBF calibration section -----
    fprintf('\n')
    fprintf('=======================\n')
    fprintf('  Calibrating CBF map  \n')
    fprintf('=======================\n')

    % running Scott's CBF calibration code
    cbf_calc(fullfile(SubjDirPath, 'func', 'run_01', 's5vbm8_w2mm_vasc_3dasl.nii'),...
              fullfile(SubjDirPath, 'func','coReg','vbm8','bet_vbm8_w2mm_ht1spgr_mask.nii'),...
              SubjDirPath);

    % ----- CBF maps writeout -----
    fprintf('\n')
    fprintf('=====================\n')
    fprintf('  Saving 4 CBF maps  \n')
    fprintf('=====================\n')

    % change back to subject folder
    cd(SubjDirPath)
end

% Ending diary Logging
disp(['======== Session ENDED!! ==========  ', datestr(clock), '  ==================']);
diary off

% saying goodbye!
fprintf('\n')
fprintf('===============\n')
fprintf('  ALL DONE !!  \n')
fprintf('===============\n')
fprintf('\n')
