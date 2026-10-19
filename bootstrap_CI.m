clc; clear; close all;
% 1) Read data from Excel and split into 'MCI' and 'Normal' groups 
sheetName = 'Test';
data = readtable('Based on your file modify it', 'Sheet', sheetName);

% Select rows for each group
mciData    = data(strcmp(data.Group, 'MCI'), :);
normalData = data(strcmp(data.Group, 'Normal'), :);

% Extract the variable of interest (e.g. MeanDuration_A) for each group
x_mci    = mciData.MeanDuration_A;
x_normal = normalData.MeanDuration_A;

% 2) Set up bootstrap parameters for t-test
numBootstrap = 10000;                   % number of bootstrap samples
tStats        = zeros(numBootstrap, 1); % storage for bootstrap t-statistics

% 3) Bootstrap loop: compute t-statistic on each resampled dataset

n1 = numel(x_mci);
n2 = numel(x_normal);

for i = 1 : numBootstrap
    % (a) resample with replacement within each group
    resample_mci    = x_mci(randi(n1, n1, 1));
    resample_normal = x_normal(randi(n2, n2, 1));
    
    % (b) perform two-sample t-test and record the t-statistic
    [~, ~, ~, stats] = ttest2(resample_mci, resample_normal);
    tStats(i) = stats.tstat;
end

% 4) Compute 95% confidence interval for the bootstrap t-statistics

ciLower = prctile(tStats, 2.5);
ciUpper = prctile(tStats, 97.5);

fprintf('Bootstrap 95%% CI for t-statistic: [%.4f, %.4f]\n', ciLower, ciUpper);

% 5) Plot histogram of the bootstrap t-distribution with CI lines
figure;
histogram(tStats, 30, 'FaceColor', [0.2 0.2 0.8]);
hold on;
yLimits = ylim;
plot([ciLower, ciLower], yLimits, 'r--', 'LineWidth', 2);
plot([ciUpper, ciUpper], yLimits, 'r--', 'LineWidth', 2);
xlabel('t-Statistic');
ylabel('Frequency');
title('Bootstrap Distribution of t-Statistic (95% CI)');
grid on;
