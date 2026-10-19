%Permutation test code modified for 4 class and all parameter 

clc, clear, close all
% Load the data
data = readtable('here path of temporal parameter output');

% Filter for EO condition
data_eo = data;

% Separate MCI and Normal groups
data_mci = data_eo(strcmp(data_eo.Group, 'MCI'), :);
data_normal = data_eo(strcmp(data_eo.Group, 'Normal'), :);

% Extract relevant columns for analysis

total_time_mci = data_mci.TotalTime;
total_time_normal = data_normal.TotalTime;

total_exp_var_mci = data_mci.TotalExpVar;
total_exp_var_normal = data_normal.TotalExpVar;

ind_exp_var_mci = data_mci{:, {'IndExpVar_A', 'IndExpVar_B', 'IndExpVar_C', 'IndExpVar_D'}};
ind_exp_var_normal = data_normal{:, {'IndExpVar_A', 'IndExpVar_B', 'IndExpVar_C', 'IndExpVar_D'}};

coverage_mci = data_mci{:, {'Coverage_A', 'Coverage_B', 'Coverage_C', 'Coverage_D'}};
coverage_normal = data_normal{:, {'Coverage_A', 'Coverage_B', 'Coverage_C', 'Coverage_D'}};

durations_mci   = data_mci{:, {'MeanDuration_A','MeanDuration_B','MeanDuration_C','MeanDuration_D','MeanDurationAll'}};
durations_normal= data_normal{:,{'MeanDuration_A','MeanDuration_B','MeanDuration_C','MeanDuration_D','MeanDurationAll'}};

occurrence_mci   = data_mci{:, {'MeanOccurrence_A','MeanOccurrence_B','MeanOccurrence_C','MeanOccurrence_D','MeanOccurrenceAll'}};
occurrence_normal= data_normal{:,{'MeanOccurrence_A','MeanOccurrence_B','MeanOccurrence_C','MeanOccurrence_D','MeanOccurrenceAll'}};

prob_mci = data_mci{:, {'DeltaTM_A__B', 'DeltaTM_A__C', 'DeltaTM_A__D', 'DeltaTM_B__A', 'DeltaTM_B__C', 'DeltaTM_B__D', 'DeltaTM_C__A', 'DeltaTM_C__B', 'DeltaTM_C__D', 'DeltaTM_D__A', 'DeltaTM_D__B', 'DeltaTM_D__C'}};
prob_normal = data_normal{:, {'DeltaTM_A__B', 'DeltaTM_A__C', 'DeltaTM_A__D', 'DeltaTM_B__A', 'DeltaTM_B__C', 'DeltaTM_B__D', 'DeltaTM_C__A', 'DeltaTM_C__B', 'DeltaTM_C__D', 'DeltaTM_D__A', 'DeltaTM_D__B', 'DeltaTM_D__C'}};

org_tm_mci = data_mci{:, {'OrgTM_A__B', 'OrgTM_A__C', 'OrgTM_A__D', 'OrgTM_B__A', 'OrgTM_B__C', 'OrgTM_B__D', 'OrgTM_C__A', 'OrgTM_C__B', 'OrgTM_C__D', 'OrgTM_D__A', 'OrgTM_D__B', 'OrgTM_D__C'}};
org_tm_normal = data_normal{:, {'OrgTM_A__B', 'OrgTM_A__C', 'OrgTM_A__D', 'OrgTM_B__A', 'OrgTM_B__C', 'OrgTM_B__D', 'OrgTM_C__A', 'OrgTM_C__B', 'OrgTM_C__D', 'OrgTM_D__A', 'OrgTM_D__B', 'OrgTM_D__C'}};

mean_gfp_mci = data_mci{:, {'MeanGFP_A', 'MeanGFP_B', 'MeanGFP_C', 'MeanGFP_D'}};
mean_gfp_normal = data_normal{:, {'MeanGFP_A', 'MeanGFP_B', 'MeanGFP_C', 'MeanGFP_D'}};


% Define permutation test function using t-statistic
function [observed_t, perm_t_values, p_value] = permutation_test_t(group1, group2, num_permutations)
    % Compute the observed test statistic (t-statistic)
    [~, ~, ~, stats] = ttest2(group1, group2);
    observed_t = stats.tstat;
    
    % Combine the groups
    combined = [group1; group2];
    
    % Initialize a list to store permutation results
    perm_t_values = zeros(num_permutations, 1);
    
    for i = 1:num_permutations
        % Shuffle the combined data
        perm_combined = combined(randperm(length(combined)));
        
        % Split the data into two new groups
        perm_group1 = perm_combined(1:length(group1));
        perm_group2 = perm_combined(length(group1) + 1:end);
        
        % Compute the test statistic for the permuted groups
        [~, ~, ~, stats] = ttest2(perm_group1, perm_group2);
        perm_t_values(i) = stats.tstat;
    end
    
    % Calculate p-value
    p_value = mean(abs(perm_t_values) >= abs(observed_t));
end

% Define the number of permutations
num_permutations = 10000;

% Define column names for each parameter set (only for 4 classes)
duration_columns = {'MeanDuration_A', 'MeanDuration_B', 'MeanDuration_C', 'MeanDuration_D','MeanDurationAll'};
coverage_columns = {'Coverage_A', 'Coverage_B', 'Coverage_C', 'Coverage_D'};
occurrence_columns = {'MeanOccurrence_A', 'MeanOccurrence_B', 'MeanOccurrence_C', 'MeanOccurrence_D','MeanOccurrenceAll'};
prob_columns = {'DeltaTM_A__B', 'DeltaTM_A__C', 'DeltaTM_A__D', 'DeltaTM_B__A', 'DeltaTM_B__C', 'DeltaTM_B__D', 'DeltaTM_C__A', 'DeltaTM_C__B', 'DeltaTM_C__D', 'DeltaTM_D__A', 'DeltaTM_D__B', 'DeltaTM_D__C'};
ind_exp_var_columns = {'IndExpVar_A', 'IndExpVar_B', 'IndExpVar_C', 'IndExpVar_D'};
mean_gfp_columns = {'MeanGFP_A', 'MeanGFP_B', 'MeanGFP_C', 'MeanGFP_D'};
org_tm_columns = {'OrgTM_A__B', 'OrgTM_A__C', 'OrgTM_A__D', 'OrgTM_B__A', 'OrgTM_B__C', 'OrgTM_B__D', 'OrgTM_C__A', 'OrgTM_C__B', 'OrgTM_C__D', 'OrgTM_D__A', 'OrgTM_D__B', 'OrgTM_D__C'};

results_duration = table();
results_coverage = table();
results_occurrence = table();
results_prob = table();
results_total_time = table();
results_total_exp_var = table();
results_ind_exp_var = table();
results_mean_gfp = table();
results_org_tm = table();

%Run permutation test for totaltime
[obs_t, perm_t_values, p_value] = permutation_test_t(total_time_mci, total_time_normal, num_permutations);
results_total_time.ObservedTValue = obs_t;
results_total_time.PValue = p_value;
results_total_time.Properties.RowNames = {'TotalTime'};

% Run permutation test for total explained variance
[obs_t, perm_t_values, p_value] = permutation_test_t(total_exp_var_mci, total_exp_var_normal, num_permutations);
results_total_exp_var.ObservedTValue = obs_t;
results_total_exp_var.PValue = p_value;
results_total_exp_var.Properties.RowNames = {'TotalExpVar'};

% Run permutation test for individual explained variance
for col = 1:length(ind_exp_var_columns)
    [obs_t, perm_t_values, p_value] = permutation_test_t(ind_exp_var_mci(:, col), ind_exp_var_normal(:, col), num_permutations);
    results_ind_exp_var.ObservedTValue(col) = obs_t;
    results_ind_exp_var.PValue(col) = p_value;
end
results_ind_exp_var.Properties.RowNames = ind_exp_var_columns;

% Run permutation test for durations
for col = 1:length(duration_columns)
    [obs_t, perm_t_values, p_value] = permutation_test_t(durations_mci(:, col), durations_normal(:, col), num_permutations);
    results_duration.ObservedTValue(col) = obs_t;
    results_duration.PValue(col) = p_value;
end
results_duration.Properties.RowNames = duration_columns;

% Run permutation test for coverage
for col = 1:length(coverage_columns)
    [obs_t, perm_t_values, p_value] = permutation_test_t(coverage_mci(:, col), coverage_normal(:, col), num_permutations);
    results_coverage.ObservedTValue(col) = obs_t;
    results_coverage.PValue(col) = p_value;
end
results_coverage.Properties.RowNames = coverage_columns;

% Run permutation test for occurrences
for col = 1:length(occurrence_columns)
    [obs_t, perm_t_values, p_value] = permutation_test_t(occurrence_mci(:, col), occurrence_normal(:, col), num_permutations);
    results_occurrence.ObservedTValue(col) = obs_t;
    results_occurrence.PValue(col) = p_value;
end
results_occurrence.Properties.RowNames = occurrence_columns;

% Run permutation test for probabilities
for col = 1:length(prob_columns)
    [obs_t, perm_t_values, p_value] = permutation_test_t(prob_mci(:, col), prob_normal(:, col), num_permutations);
    results_prob.ObservedTValue(col) = obs_t;
    results_prob.PValue(col) = p_value;
end
results_prob.Properties.RowNames = prob_columns;

% Run permutation test for mean GFP
for col = 1:length(mean_gfp_columns)
    [obs_t, perm_t_values, p_value] = permutation_test_t(mean_gfp_mci(:, col), mean_gfp_normal(:, col), num_permutations);
    results_mean_gfp.ObservedTValue(col) = obs_t;
    results_mean_gfp.PValue(col) = p_value;
end
results_mean_gfp.Properties.RowNames = mean_gfp_columns;

% Run permutation test for original transition matrix
for col = 1:length(org_tm_columns)
    [obs_t, perm_t_values, p_value] = permutation_test_t(org_tm_mci(:, col), org_tm_normal(:, col), num_permutations);
    results_org_tm.ObservedTValue(col) = obs_t;
    results_org_tm.PValue(col) = p_value;
end
results_org_tm.Properties.RowNames = org_tm_columns;

% Save all results to a single Excel file with different sheets
filename = 'file name for output';  
% Write each table to a separate sheet with row names
writetable(results_duration, filename, 'Sheet', 'Duration', 'WriteRowNames', true);
writetable(results_coverage, filename, 'Sheet', 'Coverage', 'WriteRowNames', true);
writetable(results_occurrence, filename, 'Sheet', 'Occurrence', 'WriteRowNames', true);
writetable(results_prob, filename, 'Sheet', 'Probability', 'WriteRowNames', true);
writetable(results_total_time, filename, 'Sheet', 'TotalTime', 'WriteRowNames', true);
writetable(results_total_exp_var, filename, 'Sheet', 'TotalExpVar', 'WriteRowNames', true);
writetable(results_ind_exp_var, filename, 'Sheet', 'IndExpVar', 'WriteRowNames', true);
writetable(results_mean_gfp, filename, 'Sheet', 'MeanGFP', 'WriteRowNames', true);
writetable(results_org_tm, filename, 'Sheet', 'OrgTM', 'WriteRowNames', true);