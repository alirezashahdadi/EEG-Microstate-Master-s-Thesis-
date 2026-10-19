
% Reads 'transitions.xlsx', computes group‐mean adjusted transition
% probabilities for Normal & MCI, then plots both in one **square**
% figure with a smooth blue→white→red colormap and square axes.
% tarnsition.xlsx must contain one of method calculated transition
% parobabilities output.this code only generate plot.

%% 1) Read the data
T = readtable('transitions.xlsx','PreserveVariableNames',true);

%% 2) Labels & groups
classes = {'A','B','C','D'};
n       = numel(classes);
groups  = {'Normal','MCI'};

%% 3) Build a smooth blue→white→red colormap (odd length)
N   = 255;              
mid = (N+1)/2;
bl2w = [ linspace(0,1,mid)' linspace(0,1,mid)' ones(mid,1)       ];  % blue→white
w2r = [ ones(mid-1,1)      linspace(1,0,mid-1)' linspace(1,0,mid-1)' ];  % white→red
cmap = [bl2w; w2r];

%% 4) Compute mean ΔTM per group
DeltaMean = struct();
for k = 1:2
    grp  = groups{k};
    mask = strcmp(T.Group, grp);
    M    = nan(n);
    for i = 1:n
      for j = 1:n
        if i==j, continue; end
        col = sprintf('DeltaTM_%s->%s', classes{i}, classes{j});
        M(i,j) = mean( T{mask, col} );
      end
    end
    M(eye(n)==1) = 0;           % force diagonal = 0 (white)
    DeltaMean.(grp) = M;
end

%% 5) Determine common color limit
allVals = [DeltaMean.Normal(:); DeltaMean.MCI(:)];
lim     = max(abs(allVals(~isnan(allVals))));

%% 6) Square figure, two panels
figure( ...
  'Name','Adjusted Transition Probabilities', ...
  'NumberTitle','off', ...
  'Units','pixels', ...
  'Position',[200 200 600 600] ...  % width=height → square window
);
tiledlayout(1,2,'Padding','compact','TileSpacing','compact');

for k = 1:2
    grp = groups{k};
    M   = DeltaMean.(grp);
    
    ax = nexttile;
    imagesc(M,[-lim lim]);
    axis square;                % make axes themselves square
    colormap(ax, cmap);
    colorbar;
    
    title(grp, 'FontWeight','bold');
    xlabel('To'); ylabel('From');
    set(ax, ...
        'XTick',1:n,'XTickLabel',classes, ...
        'YTick',1:n,'YTickLabel',classes);
    
    % annotate each cell
    thr = lim * 0.5;
    for i = 1:n
      for j = 1:n
        val = M(i,j);
        if abs(val) > thr
            txtColor = 'white';
        else
            txtColor = 'black';
        end
        text(j, i, sprintf('%.1f', val), ...
             'HorizontalAlignment','center', ...
             'Color', txtColor, ...
             'FontWeight','bold');
      end
    end
end
exportgraphics(gcf, 'Adjusted_Transition_Probabilities.png', 'Resolution',300);
