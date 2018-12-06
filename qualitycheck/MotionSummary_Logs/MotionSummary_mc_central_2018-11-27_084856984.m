%This script was run on 11/27/2018 08:48:56
% check RealignType is set correctly
if all(RealignType ~= [1 2])
    error('RealignType %d is not recognized. 1 = SPM, 2 = FSL\n', RealignType);
end

% handle logging
LogDirectory = mc_GenPath(struct('Template',LogTemplate,'mode','makedir'));
result = mc_Logger('setup', LogDirectory);
if (~result)
    mc_Error('There was an error creating your logfiles.\nDo you have permission to write to %s?',LogDirectory);
end
global mcLog

fprintf(1,'-----\n');
OutputPathFile = mc_GenPath( struct('Template',OutputPathTemplate,...
                                    'suffix','.csv',...
                                    'mode','makeparentdir') );
                  
fprintf(1, 'Computing motion summary statistics\n');
fprintf(1, 'Size of level arm: %f\n', LeverArm);
fprintf(1, 'Output file: %s\n', OutputPathFile);
fprintf(1, 'Subjects:\n');
display(SubjDir);
fprintf(1, '-----\n');

clear CombinedOutput
clear MotionPath
for iSubject = 1:size(SubjDir,1)

    Subject = SubjDir{iSubject,1};
    Vols    = [];

    for jRun = 1:numel(SubjDir{iSubject,3})
        RunNum = SubjDir{iSubject,3}(jRun);
        Run    = RunDir{RunNum};

        MotionPathCheck  = struct('Template',MotionPathTemplate,'mode','check');
        MotionPath       = mc_GenPath(MotionPathCheck);
        MotionParameters = load(MotionPath);

        % calculate Euclidean displacement and FD criteria
        % first for SPM
        if RealignType == 1
            Output = euclideanDisplacement(fliplr(MotionParameters),LeverArm);
            [FD, FDjudge] = mc_FD_calculation(fliplr(MotionParameters), FDcriteria, FDLeverArm, FramesBefore, FramesAfter);
        % now for FSL
        elseif RealignType == 2
            Output = euclideanDisplacement(MotionParameters,LeverArm);
            [FD, FDjudge] = mc_FD_calculation(MotionParameters, FDcriteria, FDLeverArm, FramesBefore, FramesAfter);
        % error handling handled at top
        end

        if ~isstruct(Output) && Output == -1; 
            error('Something went terribly wrong.');
        end
            
        % Pre-Scrubbing Summary of FD
        Output.length       = length(FD);
        Output.meanFD       = mean(FD);
        Output.maxFD        = max(FD);
        Output.stdFD        = std(FD);
        Output.censorvector = sum(FDjudge,2);
        Output.nonzeroFD    = nnz(FDjudge);
        
        % Post-Scrubbing Summary of FD
        FD_post = FD;
        FD_post(Output.censorvector==1) = [];
        Output.meanFDpost   = mean(FD_post);
        Output.maxFDpost    = max(FD_post);
        Output.stdFDpost    = std(FD_post);
                
        CombinedOutput{iSubject,jRun} = Output;

        % save censor vectors        
        if exist('OutputCensorVector','var') && (~isempty(OutputCensorVector))
            OutputCensorVectorFile = mc_GenPath(struct('Template',OutputCensorVector,...
                'suffix','.mat',...
                'mode','makeparentdir'));
            if ~isempty(Output.censorvector)
                cv = Output.censorvector;
            else
                cv = zeros(size(FD));       % No scan excluded scenario
            end
            save(OutputCensorVectorFile,'cv');
        end
        
        % Write out censor regressor csv
        [pathstr, file, ext] = fileparts(MotionPath);
        fdCsv = fullfile(pathstr, 'fdOutliers.csv');
        fdFid = fopen(fdCsv, 'w');
        if fdFid == -1
            fprintf(1, 'Cannot write fdOutliers.csv for subject %s\n', Subject);
            fprintf(1, 'Check permissions for path: %s\n', pathstr);
        else
            if ~isempty(FDjudge)
                for i = 1:size(FDjudge, 1)
                    for k = 1:(size(FDjudge, 2) - 1)
                        fprintf(fdFid, '%d,', FDjudge(i, k));
                    end
                    fprintf(fdFid, '%d\n', FDjudge(i, end));
                end
            end
            fclose(fdFid);
        end
    end
end

% create motion PDF plots
if exist('OutputPlotPath', 'var') && ~isempty(OutputPlotPath)
    for iSubject = 1:size(SubjDir, 1)
        Subject = SubjDir{iSubject, 1};
        fprintf(1, 'Create motion PDF plot for subject %s', Subject);
        MotionPathCheck  = struct('Template',MotionPathTemplate,'mode','check');
        MotionPath       = mc_GenPath(MotionPathCheck);
        MotionParameters = load(MotionPath);

        Vols = [];
        for jRun = 1:size(SubjDir{iSubject, 3}, 2)
            RunNum = SubjDir{iSubject, 3}(jRun);
            Run    = RunDir{RunNum};

            % save spm_vols if dealing with spm realigned functionals
            if RealignType == 1
                PreRealignCheck.Template = PreRealignTemplate;
                PreRealignCheck.mode     = 'check';
                PreRealign               = mc_GenPath(PreRealignCheck);
                Vols                     = cat(1, Vols, spm_vol(PreRealign));
            elseif RealignType == 2
                Vols = cat(1, Vols, MotionParameters);
            end
        end

        % save parameters for realigned functionals
        if RealignType == 1
            Params = zeros(size(Vols, 1), 12);
            for iVol = 1:size(Vols, 1)
                Params(iVol, :) = spm_imatrix(Vols(iVol).mat/Vols(1).mat);
            end
        elseif RealignType == 2
            Params = fliplr(Vols);
        end

        % now create the plots
        MotionPlot = figure('units', 'inches', ...
                            'position', [4 12 8.5 11], ...
                            'PaperPositionMode', 'auto', ...
                            'visible', 'off', ...
                            'MenuBar', 'none', ...
                            'numbertitle', 'off');

        %%% plot translation
        subplot(2, 1, 1);
        plot(Params(:, 1:3));
        legend('x translation', 'y translation', 'z translation', 'location', 'northwest');
        title('translation','FontSize',20,'FontWeight','Bold');
        xlabel('image', 'FontSize', 18);
        ylabel('mm', 'FontSize', 18);

        %%% plot rotation
        subplot(2, 1, 2);
        plot(Params(:, 4:6)*180/pi);
        legend('pitch', 'roll', 'yaw', 'location', 'northwest')
        title('rotation','FontSize',20,'FontWeight','Bold');
        xlabel('image', 'FontSize', 10);
        ylabel('degrees', 'FontSize', 18);

        %%% now save the plot
        OutputPlotPathCheck.Template = OutputPlotPath;
        OutputPlotPathCheck.mode = 'check';
        OutputPlot = fullfile(mc_GenPath(OutputPlotPathCheck), OutputPlotFile);
        print(MotionPlot, OutputPlot, '-dpdf');
        fprintf(1, ':%s.pdf\n', OutputPlot);
    end
end

%%%%%%% Save results to CSV file
theFID = fopen(OutputPathFile,'w');
if theFID < 0
    fprintf(1,'Error opening the csv file!\n');
    return;
end

% let us log usage here because errors are very unlikely to occur past this point
for iSubject = 1:size(SubjDir, 1)
    % now log usages
    RunsChecked = size(SubjDir{iSubject,3},2);
    str = sprintf('Subject:%s Runs:%d CheckMotion complete\n', Subject, RunsChecked);
    UsageResult = mc_Usage(str, 'CheckMotion');
    if ~UsageResult
        mc_Logger('log', 'Unable to log usage information.', 2);
    end
end

if ~(exist('OutputMode','var'))
    OutputMode = 2;
end

switch OutputMode
    case 1
        %%%%%%%%% Output Values for each Run of each Subject%%%%%%%%%%%%%%%%
        fprintf(theFID,'Subject,Run,maxSpace,meanSpace,sumSpace,maxAngle,meanAngle,sumAngle,maxFDpre,meanFDpre,stdFDpre,maxFDpost,meanFDpost,stdFDpost,SupraThresholdFD,TotalVolume,ScrubRatio\n'); %header
        for iSubject = 1:size(SubjDir,1)
            Subject = SubjDir{iSubject,1};
            for jRun = 1:size(SubjDir{iSubject,3},2)
                RunNum = SubjDir{iSubject,3}(jRun);
                
                % Select appropriate output based on h user has set
                index = strfind(MotionPathTemplate,'Run');
                if size(index) > 0
                    RunString=RunDir{RunNum};
                else
                    RunString=num2str(jRun);
                end

                % now start writing to file                
                fprintf(theFID,'%s,%s,',Subject,RunString);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject,jRun}.maxSpace);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject,jRun}.meanSpace);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject, jRun}.sumSpace);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject,jRun}.maxAngle);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject,jRun}.meanAngle);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject, jRun}.sumAngle);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject, jRun}.maxFD);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject,jRun}.meanFD);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject, jRun}.stdFD);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject, jRun}.maxFDpost);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject, jRun}.meanFDpost);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject, jRun}.stdFDpost);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject,jRun}.nonzeroFD);
                fprintf(theFID,'%.4f,',CombinedOutput{iSubject,jRun}.length);
                fprintf(theFID,'%.4f\n',CombinedOutput{iSubject,jRun}.nonzeroFD/CombinedOutput{iSubject,jRun}.length);
            end
        end
    case 2        
        %%%%%%%%%%%%%%%% Output averaged values along runs for each Subject %%%%%
        fprintf(theFID,'Subject,maxSpace,meanSpace,sumSpace,maxAngle,meanAngle,sumAngle,maxFDpre,meanFDpre,stdFDpre,maxFDpost,meanFDpost,stdFDpost,SupraThresholdFD,TotalVolume,ScrubRatio\n'); %header
        for iSubject = 1:size(SubjDir,1)
            Subject = SubjDir{iSubject,1};
            
            temp = [CombinedOutput{iSubject,:}];
            
            % Average over runs
            FinalOutput.maxSpace   = mean([temp(:).maxSpace]);
            FinalOutput.meanSpace  = mean([temp(:).meanSpace]);
            FinalOutput.sumSpace   = mean([temp(:).sumSpace]);
            FinalOutput.maxAngle   = mean([temp(:).maxAngle]);
            FinalOutput.meanAngle  = mean([temp(:).meanAngle]);
            FinalOutput.sumAngle   = mean([temp(:).sumAngle]);
            FinalOutput.maxFD      = mean([temp(:).maxFD]);
            FinalOutput.meanFD     = mean([temp(:).meanFD]);
            FinalOutput.stdFD      = mean([temp(:).stdFD]);
            FinalOutput.maxFDpost  = mean([temp(:).maxFDpost]);
            FinalOutput.meanFDpost = mean([temp(:).meanFDpost]);
            FinalOutput.stdFDpost  = mean([temp(:).stdFDpost]);
            
            % the total excluded points over runs
            FinalOutput.nonzeroFD = sum([temp(:).nonzeroFD]);
            FinalOutput.length = sum([temp(:).length]);
            
            fprintf(theFID,'%s,',Subject);
            fprintf(theFID,'%.4f,',FinalOutput.maxSpace);
            fprintf(theFID,'%.4f,',FinalOutput.meanSpace);
            fprintf(theFID,'%.4f,',FinalOutput.sumSpace);
            fprintf(theFID,'%.4f,',FinalOutput.maxAngle);
            fprintf(theFID,'%.4f,',FinalOutput.meanAngle);
            fprintf(theFID,'%.4f,',FinalOutput.sumAngle);
            fprintf(theFID,'%.4f,',FinalOutput.maxFD);
            fprintf(theFID,'%.4f,',FinalOutput.meanFD);
            fprintf(theFID,'%.4f,',FinalOutput.stdFD);
            fprintf(theFID,'%.4f,',FinalOutput.maxFDpost);
            fprintf(theFID,'%.4f,',FinalOutput.meanFDpost);
            fprintf(theFID,'%.4f,',FinalOutput.stdFDpost);
            fprintf(theFID,'%.4f,',FinalOutput.nonzeroFD);
            fprintf(theFID,'%.4f,',FinalOutput.length);
            fprintf(theFID,'%.4f\n',FinalOutput.nonzeroFD/FinalOutput.length);
        end
    otherwise
        disp('Do not know how to output the results, please set OutputMode to 1 or 2');
end

fclose(theFID);
display('All Done!')