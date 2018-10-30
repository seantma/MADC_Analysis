
% Parent directory
% ParentDir = '/mnt/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/SecondLevel';
ParentDir = '/mnt/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/FirstLevel';

% Reporting directory
ReportDir = '/mnt/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/Sean_docs/Hampstead_Spire/MethodsCore_mod';

% Model name
% Modelname = 'Video_02';
% Modelname = 'Rest_Trial4';
Modelname = 'Video_02';

% Working directory
% WorkDir = strcat(ParentDir, '/', Modelname);  %for WorkDir/Modelname/Subject structure
WorkDir = strcat(ParentDir);  %for WorkDir/Subject/Modelname structure

% Contrast directories under Working directory
d = dir(WorkDir);
idir = [d(:).isdir];                        % returns logical vector
ConDir = {d(idir).name}';
ConDir(ismember(ConDir,{'.','..'})) = [];   % removing . & ..
index = find(~cellfun('isempty', regexp(ConDir, 'spi000[0-9]+_scan[1-2]'))); %regex matching 'spi00012_scan1'
ConDir = ConDir(index);

% setting up path
% global mcRoot
% mcRoot = '/mnt/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore'
% addpath(fullfile(mcRoot,'SPM','SPM8','spm8_with_R4667'))

% spm addpath
addpath /mnt/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313/

% loop into different contrast directories
for iConDir = 1:size(ConDir)
    fprintf('\n')
    fprintf('================\n')
    fprintf('  NEW contrast  \n')
    fprintf('================\n')

    % setting up Contrast directory
    % ContrastDir = strcat(WorkDir, '/', ConDir{iConDir});  %for WorkDir/Modelname/Subject structure
    ContrastDir = strcat(WorkDir, '/', ConDir{iConDir}, '/', Modelname);  %for WorkDir/Subject/Modelname structure

    % setting up SPM.mat file
    spmFile = strcat(ContrastDir, '/SPM.mat');
    fprintf('\nWorking on SPM.mat ...\n');
    fprintf('%s\n', spmFile)

    % change to Working directory and rm .ps
    fprintf('\nRemoving old .ps files ...\n\n')
    cd(ContrastDir)
    try
      system('rm *.ps');
    catch
      warning('No .ps file to rm')
    end

    %-----------------------------------------------------------------------
    % Job configuration created by cfg_util (rev $Rev: 4252 $)
    %-----------------------------------------------------------------------
    % inspired by SPM mailist: https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;b72c4540.1601

    fprintf('================================\n')
    fprintf('  Working on Positive contrast  \n')
    fprintf('================================\n')

    matlabbatch{1}.spm.stats.results.spmmat = { spmFile };        %spm.mat location
    matlabbatch{1}.spm.stats.results.conspec.titlestr = strcat(ConDir{iConDir}, ': Mean');  %contrast directory name
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 4;       %positive contrast (for now): 1
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 1;      %p threshold: 0.005
    matlabbatch{1}.spm.stats.results.conspec.extent = 0;
    matlabbatch{1}.spm.stats.results.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.print = true;
    % matlabbatch{1}.spm.stats.results.print = 'pdf';
    % matlabbatch{1}.spm.util.print.fname = 'Sean_test';
    % matlabbatch{1}.spm.stats.results.write.tspm.basename = 'Sean_test_2ndLevel';

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
    % matlabbatch{1}.spm.stats.results.conspec.titlestr = strcat(ConDir{iConDir}, ': Negative');  %contrast directory name
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
    myCommand = ['mv ', whichPS,' ', ReportDir, '/', ConDir{iConDir}, '_p1.ps'];  %_p005.ps
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
