% MATLAB script to compute directional frequency‐band log‐ratios for EEG microstate parameters
% Assumes four CSV files in a single folder:
%   Alpha.csv, Beta.csv, Delta.csv, Theta.csv
% Each file has rows = subjects, columns = microstate parameters (e.g. meanDuration_A, occurrence_B, etc.)
% Reads combined workbook, computes log-transformed ratios, and writes an Excel sheet per ratio.

%% === User settings ===
baseDir    = 'C:\Users\alire\OneDrive\Desktop\New folder';    % your data folder
inputFile  = fullfile(baseDir, 'combined_microstate_data.xlsx');
outFile    = fullfile(baseDir, 'microstate_logratio_sheets.xlsx');
bandNames  = {'Delta','Theta','Alpha','Beta'};
ratioPairs = { 'Beta','Alpha';
               'Beta','Theta';
               'Beta','Delta';
               'Alpha','Theta';
               'Alpha','Delta';
               'Theta','Delta' };

%% === Read all frequency sheets into tables ===
for i = 1:numel(bandNames)
    T.(bandNames{i}) = readtable(inputFile, 'Sheet', bandNames{i});
end

% Determine identifier vs. numeric columns from first sheet
allVars   = T.(bandNames{1}).Properties.VariableNames;
isNumeric = varfun(@isnumeric, T.(bandNames{1}), 'OutputFormat', 'uniform');
idCols    = allVars(~isNumeric);
paramCols = allVars(isNumeric);

%% === Prepare output workbook ===
if exist(outFile,'file')
    delete(outFile);
end

%% === Compute and write each log‐ratio sheet ===
for rp = 1:size(ratioPairs,1)
    b1       = ratioPairs{rp,1};
    b2       = ratioPairs{rp,2};
    sheetName = sprintf('%s_over_%s_log', b1, b2);
    % Initialize output table with identifier columns
    TR = T.(bandNames{1})(:, idCols);
    % Compute log-transformed ratio for each numeric parameter
    for p = 1:numel(paramCols)
        v1 = T.(b1).(paramCols{p});
        v2 = T.(b2).(paramCols{p});
        % compute ratio then log-transform
        TR.(paramCols{p}) = log(v1 ./ v2);
    end
    % Write to Excel sheet
    writetable(TR, outFile, 'Sheet', sheetName, 'WriteRowNames', false);
end

fprintf('Created log-ratio workbook with %d sheets at:\n%s\n', size(ratioPairs,1), outFile);
