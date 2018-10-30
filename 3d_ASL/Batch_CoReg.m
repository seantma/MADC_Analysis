% Custom batch file for ASL processing
%
%% Sean Ma
% Oct 2018
%
% This script can do:
% 1. CoRegistration
% 2. Segmentation of coregistered anatomy
% 3. CBF calibration

% Working directory
WorkDir = '/nfs/fmri/Analysis/Sean_Working/ASL_pilot';

% Reporting directory
ReportDir = '/nfs/fmri/Analysis/Sean_Working/Git_MADC/3d_ASL';

% Contrast directories under Working directory
d = dir(WorkDir);
idir = [d(:).isdir];                          % returns logical vector for dir folders
SubjDir = {d(idir).name}';
SubjDir(ismember(SubjDir,{'.','..'})) = [];   % removing . & ..
% Use regex to match pattern folder
% index = find(~cellfun('isempty', regexp(SubjDir, 'spi000[0-9]+_scan[1-2]'))); %regex matching 'spi00012_scan1'
% SubjDir = SubjDir(index);

% setting up path
% global mcRoot
% mcRoot = '/mnt/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore'
% addpath(fullfile(mcRoot,'SPM','SPM8','spm8_with_R4667'))

% addpath for spm & ASL scripts
addpath /opt/apps/MCore2/SPM/SPM12/spm12_R7219/
addpath /nfs/fmri/Analysis/Sean_Working/Git_MADC/3d_ASL
addpath /nfs/fmri/Analysis/Sean_Working/Git_MADC/3d_ASL/multiband_fm_ru/mfiles

% Logging diary
diary('Batch_CoReg_console_Log.txt')
disp(['======== Starting session!! ==========  ', datestr(clock), '  ==================']);

% loop into different contrast directories
for iSubjDir = 1:size(SubjDir)
    fprintf('\n')
    fprintf('=====================================\n')
    fprintf('  NEW Subject: %s \n', SubjDir{iSubjDir})
    fprintf('=====================================\n\n')

    % setting up full path subject directory
    SubjDirPath = strcat(WorkDir, '/', SubjDir{iSubjDir});  %for WorkDir/Subject/Modelname structure

    % change to Working directory and rm .ps
    fprintf('\nRemoving old .ps files ...\n\n')
    cd(SubjDirPath)
    try
      system('rm *.ps');
    catch
      warning('No .ps file to rm')
    end

    % ----- CoRegistration section -----
    fprintf('\n')
    fprintf('=============================\n')
    fprintf('  Working on CoRegistration  \n')
    fprintf('=============================\n')

    %-----------------------------------------------------------------------
    % Job saved on 30-Oct-2018 12:03:20 by cfg_util (rev $Rev: 6942 $)
    % spm SPM - SPM12 (7219)
    %-----------------------------------------------------------------------
    % inspired by SPM mailist: https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;b72c4540.1601
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = {strcat(SubjDirPath,'/vasc_3dasl.nii,2')};
    matlabbatch{1}.spm.spatial.coreg.estimate.source = {strcat(SubjDirPath,'/t1mprage_208.nii,1')};
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'ecc';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

    % spm initiation
    spm_jobman('initcfg');
    spm('defaults','fmri');
    global defaults;

    % running spm job
    spm_jobman('run',matlabbatch);

    clear matlabbatch

    % ----- Skull-Strip section -----
    % use `bet2` for skull-strip and mask generation
    fprintf('\n')
    fprintf('==========================\n')
    fprintf('  Working on Skull-Strip  \n')
    fprintf('==========================\n')

    cd(SubjDirPath)
    betCommand = ['bet2 t1mprage_208.nii bet_t1mprage_208 -m'];
    unzipCommand = ['gunzip bet_t1mprage_208_mask.nii.gz'];
    fprintf('Skull-strip for subject: %s \n', SubjDir{iSubjDir})
    system(betCommand);
    system(unzipCommand);

    % ----- Reslice bet2 mask to vasc_3dasl section -----
    fprintf('\n')
    fprintf('========================\n')
    fprintf('  Reslicing brain mask  \n')
    fprintf('========================\n')
    %-----------------------------------------------------------------------
    % Job saved on 30-Oct-2018 13:29:09 by cfg_util (rev $Rev: 6942 $)
    % spm SPM - SPM12 (7219)
    %-----------------------------------------------------------------------
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {strcat(SubjDirPath,'/vasc_3dasl.nii,2')};
    matlabbatch{1}.spm.spatial.coreg.estwrite.source = {strcat(SubjDirPath,'/bet_t1mprage_208_mask.nii,1')};
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'ecc';
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'reSlice_3dasl2_';

    % spm initiation
    spm_jobman('initcfg');
    spm('defaults','fmri');
    global defaults;

    % running spm job
    spm_jobman('run',matlabbatch);

    clear matlabbatch

    % ----- CBF calibration section -----
    fprintf('\n')
    fprintf('=======================\n')
    fprintf('  Calibrating CBF map  \n')
    fprintf('=======================\n')

    % running Scott's CBF calibration code
    cd(SubjDirPath)
    cbf_calc('vasc_3dasl.nii', 'reSlice_3dasl2_bet_t1mprage_208_mask.nii')

    % ----- Backup files section -----
    % copy cbfmap_anat_mean100_vasc_3dasl.nii
    fprintf('\n')
    fprintf('===============================\n')
    fprintf('  Copy CBF files to ReportDir  \n')
    fprintf('===============================\n')

    cd(ReportDir)
    mkdirCommand = ['mkdir ', SubjDir{iSubjDir}];
    cp1Command = ['cp ', SubjDirPath, '/cbfmap_*.* .'];
    cp2Command = ['cp ', SubjDirPath, '/bet_t1mprage_208_mask.nii .'];

    system(mkdirCommand);
    system(cp1Command);
    system(cp2Command);
    fprintf('Finished copying CBF files')

    % finding the printed .ps. rename and move it
    fprintf('\n')
    fprintf('==================================\n')
    fprintf('  Move & Rename .ps to ReportDir  \n')
    fprintf('==================================\n')

    cd(SubjDirPath)
    [status, cmdout] = system('ls -t *.ps | head -n1');
    whichPS = strtrim(cmdout);
    myCommand = ['mv ', whichPS, ' ', ReportDir, '/', SubjDir{iSubjDir}, '.ps'];

    fprintf('Move %s with command: %s\n', whichPS, myCommand)
    system(myCommand);

end

% Ending diary Logging
disp(['======== Session ENDED!! ==========  ', datestr(clock), '  ==================']);
diary off

% copy console log to ReportDir
cd(ReportDir)
logCommand = ['cp ', SubjDirPath, '/Batch_CoReg_console_Log.txt .'];

system(logCommand)
fprintf('Finished copying Log diary!!')

% converting ps to pdf
% cd(ReportDir)
% system(['for f in *.ps; do ps2pdf ${f}; echo ''Converted ${f} to pdf, deleting original .ps file''; done;'])

% saying goodbye!
fprintf('\n')
fprintf('===============\n')
fprintf('  ALL DONE !!  \n')
fprintf('===============\n')
fprintf('\n')




%% converting ps to pdf on Mac or Linux
% #!/bin/bash
% filelist=`(find . -name \*.ps)`
%
% for i in $filelist; do
%         ps2pdf $i
%         rm $i
%         echo 'Converted $i into pdf, deleted original file.'
% done

% for f in *.ps
% do
% 	pstopdf "$f"
% done
