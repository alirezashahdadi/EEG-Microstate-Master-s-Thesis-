% Two-panel histogram with adjusted labels, darker top and red bottom colors, increased spacing

% -------------------------------------------------------------
% 1. Load the data
srcFile = 'subject_RWT_Score';
T       = readtable(srcFile);

x_cate   = T.cate_t_div2;
x_letter = T.letter_t_div2;

% -------------------------------------------------------------
% 2. Common bin edges
allX  = [x_cate; x_letter];
bw    = max(iqr(allX)/(numel(allX)^(1/3)), eps);
edges = floor(min(allX)) : bw : ceil(max(allX));
binCtr = edges(1:end-1) + diff(edges)/2;

% -------------------------------------------------------------
% 3. Two-panel figure with increased vertical spacing
figure('Color','w','Units','pixels','Position',[100 100 700 600]);
tiledlayout(2,1,'TileSpacing','loose','Padding','loose');

% ----- helper for coloured labels ---------------------------------------
labelColour = [0.80 0.05 0.05];   % dark-red for threshold labels

% ---------- 3a. Top panel : Semantic -------------------------------------
nexttile;
h = histogram(x_cate, edges);  % create histogram
% Set color darker blue with slight transparency
h.FaceColor = [0 0.2 0.6];
h.FaceAlpha = 0.8;
h.EdgeColor = 'none';

title('Semantic','FontWeight','bold');
xlabel('Word number');
ylabel('Subjects');
xlim([binCtr(1) binCtr(end)]);
grid off; box on;

yl  = ylim;  hMark = yl(2)*0.06;   % mark height 6% of axis range
yTxt = yl(1) - diff(yl)*0.02;      % 2% below axis for label
hold on;
for xv = [18 23]
    plot([xv xv],[0 hMark],'k-','LineWidth',1.2);
    text(xv, yTxt, num2str(xv), ...
         'HorizontalAlignment','center', ...
         'VerticalAlignment','top', ...
         'Color', labelColour, 'FontWeight','bold', ...
         'Clipping','off');
end
hold off;

% ---------- 3b. Bottom panel : Phonemic ----------------------------------
nexttile;
h2 = histogram(x_letter, edges);  % create histogram
% Set color darker red with slight transparency
h2.FaceColor = [0.8 0.1 0.1];
h2.FaceAlpha = 0.8;
h2.EdgeColor = 'none';

title('Phonemic','FontWeight','bold');
xlabel('Word number');
ylabel('Subjects');
xlim([binCtr(1) binCtr(end)]);
grid off; box on;

yl  = ylim;  hMark = yl(2)*0.06;
yTxt = yl(1) - diff(yl)*0.02;
hold on;
for xv = [16 18]
    plot([xv xv],[0 hMark],'k-','LineWidth',1.2);
    text(xv, yTxt, num2str(xv), ...
         'HorizontalAlignment','center', ...
         'VerticalAlignment','top', ...
         'Color', labelColour, 'FontWeight','bold', ...
         'Clipping','off');
end
hold off;

% -------------------------------------------------------------
% 4. Save figure
saveas(gcf,'file name');