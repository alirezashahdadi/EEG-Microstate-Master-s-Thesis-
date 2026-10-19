%% plot_beta_microstates_two_figs_v3.m  (updated 2025-06-16)
%  Visualise β-band microstate parameters in two figures
%   • Fig1: 4 metrics (Explained Variance, Mean Duration,
%           Mean Occurrence, Coverage) in a 2×2 grid
%   • Fig2: Mean GFP alone, full figure
%   Added: xlabel 'Class', y-axis units only (in parentheses), titles without units
% ------------------------------------------------------------------------

clear; clc;

%% 1) Load data -----------------------------------------------------------
tbl = readtable('TemporalParameters_4 classes_GrandGrandMeanTemplate.csv', 'VariableNamingRule','preserve');

% Map group labels
rawG   = upper(strtrim(string(tbl.Group)));  % e.g. "NORMAL","MCI"
ug     = unique(rawG); assert(numel(ug)==2, 'Need exactly two groups.');
grpIdx = zeros(height(tbl),1);
grpIdx(rawG==ug(1)) = 1;
grpIdx(rawG==ug(2)) = 2;
groupNames   = cellstr(ug);
groupColours = [0.3010 0.7450 0.9330;   % NORMAL
                0.8500 0.3250 0.0980];  % MCI

%% 2) Metric definitions --------------------------------------------------
classes = ["A","B","C","D"];
metrics = struct( ...
  'title',{ ...
    'Explained Variance (%)', ...      % subplot 1 unit: %
    'Mean Duration (ms)', ...          % subplot 2 unit: ms
    'Mean GFP (\muV)', ...            % used in Fig2
    'Mean Occurrence (appearances/s)', ... % subplot 3 unit: per second
    'Coverage (%)' }, ...              % subplot 4 unit: %
  'prefix',{ ...
    "IndExpVar_", "MeanDuration_", "MeanGFP_", "MeanOccurrence_", "Coverage_" }, ...
  'scale',{100,        1000,           1,           1,               1 } ...
);

markerSize = 24;
jitterHalf = 0.33;
useSwarm   = exist('swarmchart','file')==2;

%% 3) Figure 1: 2×2 grid of metrics 1,2,4,5 --------------------------------
fig1 = figure('Units','pixels','Position',[100 100 800 800]);
t1 = tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
plotIdx = [1, 2, 4, 5];  % skip Mean GFP

for k = 1:4
    idx = plotIdx(k);
    ax = nexttile;
    hold(ax,'on');
    for g = 1:2
        rows = grpIdx==g;
        if ~any(rows), continue; end
        Y = tbl{rows, metrics(idx).prefix + classes} .* metrics(idx).scale;
        nSub = size(Y,1);
        xLong = repmat(1:4, nSub,1); xLong = xLong(:);
        yLong = Y(:);
        if useSwarm
            swarmchart(ax, xLong, yLong, markerSize, ...
                'MarkerFaceColor',groupColours(g,:),...
                'MarkerEdgeColor','k',...
                'MarkerFaceAlpha',.8,...
                'MarkerEdgeAlpha',.25);
        else
            xJ = xLong + (rand(size(xLong))-0.5)*2*jitterHalf;
            scatter(ax, xJ, yLong, markerSize, ...
                'MarkerFaceColor',groupColours(g,:),...
                'MarkerEdgeColor','k',...
                'MarkerFaceAlpha',.8,...
                'MarkerEdgeAlpha',.25);
        end
    end
    xlim(ax,[0.5 4.5]); xticks(ax,1:4); xticklabels(ax,classes);
    xlabel(ax,'Class');
    % Y-axis units only (in parentheses)
    switch idx
        case {1,5}
            ylabel(ax,'(%)');
        case 2
            ylabel(ax,'(ms)');
        case 4
            ylabel(ax,'(appearances/s)');
    end
    box(ax,'on');
    % Title without unit text
    titleText = regexprep(metrics(idx).title,'\s*\(.*\)','');
    title(ax,titleText,'FontWeight','bold');
    if k==1
        legend(ax,groupNames,'Location','northoutside','Orientation','horizontal');
    end
    hold(ax,'off');
end

sgtitle('\beta-band microstate metrics: MCI vs NORMAL','FontWeight','bold');
exportgraphics(fig1,'beta_microstates_4metrics.png','Resolution',300);
fprintf('Saved: beta_microstates_4metrics.png\n');

%% 4) Figure 2: Mean GFP alone --------------------------------------------
fig2 = figure('Units','pixels','Position',[150 150 600 600]);
t2 = tiledlayout(1,1,'Padding','compact','TileSpacing','compact');
ax2 = nexttile;
hold(ax2,'on');
idx = 3;  % Mean GFP
for g = 1:2
    rows = grpIdx==g;
    if ~any(rows), continue; end
    Y = tbl{rows, metrics(idx).prefix + classes} .* metrics(idx).scale;
    nSub = size(Y,1);
    xLong = repmat(1:4, nSub,1); xLong = xLong(:);
    yLong = Y(:);
    if useSwarm
        swarmchart(ax2, xLong, yLong, markerSize, ...
            'MarkerFaceColor',groupColours(g,:),...
            'MarkerEdgeColor','k',...
            'MarkerFaceAlpha',.8,...
            'MarkerEdgeAlpha',.25);
    else
        xJ = xLong + (rand(size(xLong))-0.5)*2*jitterHalf;
        scatter(ax2, xJ, yLong, markerSize, ...
            'MarkerFaceColor',groupColours(g,:),...
            'MarkerEdgeColor','k',...
            'MarkerFaceAlpha',.8,...
            'MarkerEdgeAlpha',.25);
    end
end
xlim(ax2,[0.5 4.5]); xticks(ax2,1:4); xticklabels(ax2,classes);
xlabel(ax2,'Class');
% Y-axis unit only (in parentheses)
ylabel(ax2,'(µV)');
box(ax2,'on');
% Title without unit text
title(ax2, regexprep(metrics(idx).title,'\s*\(.*\)',''),'FontWeight','bold');
legend(ax2,groupNames,'Location','northoutside','Orientation','horizontal');
hold(ax2,'off');

sgtitle('\beta-band Mean GFP: MCI vs NORMAL','FontWeight','bold');
exportgraphics(fig2,'beta_microstates_meanGFP.png','Resolution',300);
fprintf('Saved: beta_microstates_meanGFP.png\n');
