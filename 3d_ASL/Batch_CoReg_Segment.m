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

% spm addpath
addpath /opt/apps/MCore2/SPM/SPM12/spm12_R7219/

% loop into different contrast directories
for iSubjDir = 1:size(SubjDir)
    fprintf('\n')
    fprintf('===============\n')
    fprintf('  NEW Subject  \n')
    fprintf('===============\n')

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

    %-----------------------------------------------------------------------
    % Job saved on 30-Oct-2018 12:03:20 by cfg_util (rev $Rev: 6942 $)
    % spm SPM - SPM12 (7219)
    %-----------------------------------------------------------------------
    % inspired by SPM mailist: https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;b72c4540.1601

    fprintf('=============================\n')
    fprintf('  Working on CoRegistration  \n')
    fprintf('=============================\n')

    matlabbatch{1}.spm.spatial.coreg.estimate.ref = {strcat(SubjDirPath,'/vasc_3dasl.nii,2')};
    matlabbatch{1}.spm.spatial.coreg.estimate.source = {strcat(SubjDirPath,'t1mprage_208.nii,1')};
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

    % % ===========================================================================
    % % running the negative contrast
    % fprintf('================================\n')
    % fprintf('  Working on Negative contrast  \n')
    % fprintf('================================\n')
    %
    % matlabbatch{1}.spm.stats.results.spmmat = { spmFile };        %spm.mat location
    % matlabbatch{1}.spm.stats.results.conspec.titlestr = strcat(SubjDir{iSubjDir}, ': Negative');  %contrast directory name
    % matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;         %positive contrast (for now)
    % matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    % matlabbatch{1}.spm.stats.results.conspec.thresh = 0.005;
    % matlabbatch{1}.spm.stats.results.conspec.extent = 0;
    % matlabbatch{1}.spm.stats.results.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
    % matlabbatch{1}.spm.stats.results.units = 1;
    % matlabbatch{1}.spm.stats.results.print = true;
    % % matlabbatch{1}.spm.stats.results.print = 'pdf';
    % % matlabbatch{1}.spm.util.print.fname = 'Sean_test';
    % % matlabbatch{1}.spm.stats.results.write.tspm.basename = 'Sean_test_2ndLevel';
    %
    % % spm initiation
    % spm_jobman('initcfg');
    % spm('defaults','fmri');
    % global defaults;
    %
    % % running spm job
    % spm_jobman('run',matlabbatch);
    %
    % clear matlabbatch

    % finding the printed .ps. rename and move it
    fprintf('==================================\n')
    fprintf('  Move & Rename .ps to ReportDir  \n')
    fprintf('==================================\n\n')

    [status, cmdout] = system('ls -t *.ps | head -n1');
    whichPS = strtrim(cmdout);
    myCommand = ['mv ', whichPS,' ', ReportDir, '/', SubjDir{iSubjDir}, '_p1.ps'];  %_p005.ps
    fprintf('Move %s with command: %s\n', whichPS, myCommand)
    system(myCommand);

end

% get contrast directory list
cd(WorkDir)
system(['ls -d * > ContrastsList_', Modelname, '.txt']);
myCommand = ['mv ContrastsList_', Modelname, '.txt ', ReportDir];
fprintf('Move Contrasts list file with command: %s\n', myCommand)
system(myCommand);

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
