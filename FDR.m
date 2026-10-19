clc,clear,close all;
% Specify the file name and sheet name
filename = 'File you want calculate FDR must have column named PValue';  % Replace with your Excel file name
% Specify the column that contains the p-values
pvalue_column = 'PValue';  % Replace with your p-value column name

% Specify the name for the new column with corrected p-values
corrected_column_name = 'CorrectedPValue';

% Load the data from the Excel file (without specifying a sheet)
data = readtable(filename);

% Extract the p-values from the specified column
p_values = data{:, pvalue_column};

% Perform FDR correction using mafdr
corrected_pvalues = mafdr(p_values,'BHFDR','true');

% Add the corrected p-values to the table
data.(corrected_column_name) = corrected_pvalues;

% Save the updated table back to the Excel file
writetable(data, filename);

disp('FDR correction completed and saved to Excel file.');