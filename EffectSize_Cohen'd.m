clc,clear,close all;
% Load the data
data = readtable('here path of temporal parameter output');

% Separate the groups 'MCI' and 'Normal'
group_mci_data = data(strcmp(data.Group, 'MCI'), :); 
group_normal_data = data(strcmp(data.Group, 'Normal'), :); 

% Extract the Spesific Parameter data for each group
p_mci = group_mci_data.MeanOccurrenceAll; 
p_normal = group_normal_data.MeanOccurrenceAll;

% Calculate means
mean_mci = mean(p_mci);
mean_normal = mean(p_normal);

% Calculate standard deviations
std_mci = std(p_mci);
std_normal = std(p_normal);

% Calculate pooled standard deviation
n_mci = length(p_mci);
n_normal = length(p_normal);

pooled_std = sqrt(((n_mci-1)*std_mci^2 + (n_normal-1)*std_normal^2) / (n_mci + n_normal - 2));

% Calculate Cohen's d
cohens_d = (mean_mci - mean_normal) / pooled_std;

% Display the result
fprintf('Cohen''s d is: %.4f\n', cohens_d);
