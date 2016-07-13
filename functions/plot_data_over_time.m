function plot_data_over_time(condition,title_str,varargin)

%load cond into workspace
%default optional values
colors=[0 0 1];

if length(varargin) == 1
    colors = varargin{1};
elseif length(varargin) > 1
    error('myfuns:somefun2:TooManyInputs', ...
        'requires at most 1 optional inputs');
    fprintf('try: plot_growthrate_histogram(condition,title,color)');
end
% plot per cell

% checks if fluorescence is present. if not, only makes four plots. 
if isfield(condition,'ave_fluor')
    sp_r = 2;
    sp_c = 4;
else
    sp_r = 1;
    sp_c = 4;
end

% sets figure size and color background
f = figure('Position', [100, 100, 1500, 800],'Color',[1 1 1]);


% plot length
subplot(sp_r,sp_c,1)
c0 = [0 1 1];
c1 = colors;
nc = numel(condition.lengths);
for j = 1:numel(condition.lengths)
    idx = find_smooth_traj(condition.lengths{j});
    t = condition.time{j}(idx);
    
    % PLOT ONLY ONE OF THE BELOW PLOT FUNCTIONS. 
    %A) t=0 always. B) no time correction
    
    % plots length, subtracting from t=0
    %plot(condition.time{j}(idx)-t(1),condition.lengths{j}(idx),'Color',colors)
    c = c0+(c1-c0)*(j-1)/(nc-1);
    %plots length with correct time
    plot(condition.time{j}(idx),condition.lengths{j}(idx),'Color',c)
    
    hold on;
    %plot(condition.time{j}(idx(end)+1:end)-t(1),condition.lengths{j}(idx(end)+1:end),'Color',[0.5 0.5 0.5],'LineStyle',':')
    plot(condition.time{j}(idx(end)+1:end),condition.lengths{j}(idx(end)+1:end),'Color',[0.5 0.5 0.5],'LineStyle',':')
end
xlabel('Time')
ylabel('Length')
%ylim([ 0 15]) 


% plot width
subplot(sp_r,sp_c,2)
for j = 1:numel(condition.widths)
    idx = find_smooth_traj(condition.widths{j},-0.1);
    c = c0+(c1-c0)*(j-1)/(nc-1);
    plot(condition.time{j}(idx),condition.widths{j}(idx),'Color',c)
    hold on;
    t = condition.time{j}(idx);
    % PLOT ONLY ONE OF THE BELOW PLOT FUNCTIONS. 
    
    % t = 0 option
    if ~isempty(condition.widths{j}(idx(end)+1:end))
    plot(condition.time{j}(idx(end)+1:end)-t(1),smooth(condition.widths{j}(idx(end)+1:end),5),'Color',[0.5 0.5 0.5],'LineStyle',':')
    end
    % no time correction
    %plot(condition.time{j}(idx(end)+1:end),smooth(condition.widths{j}(idx(end)+1:end),5),'Color',[0.5 0.5 0.5],'LineStyle',':')
end
ylim([0 3])
xlabel('Time')
ylabel('Width')


% plot growthrate
subplot(sp_r,sp_c,3)
[counts,centers] = hist([condition.growthrate{:}],round(sqrt(numel(condition.growthrate))));
fill([centers(1) centers centers(end)],[0 counts/sum(counts) 0],colors,'FaceAlpha',0.1,'EdgeColor',colors);
hold on;
Ylim = get(gca,'Ylim');
xlim([ 0 0.15])
plot(median([condition.growthrate{:}])*ones(1,2),[0 Ylim(2)],'LineStyle',':','Color',colors)
hold off;

xlabel('Growthrate')
ylabel('Frequency')

% plot kymogram
subplot(sp_r,sp_c,4)
maxframe = max([condition.time{:}]);
interval=condition.time{1}(2)-condition.time{1}(1);
N = round(sqrt(numel(condition.growthrate)));

% find ideal bin centers
idx = find([condition.time{:}] == maxframe);
l = [condition.lengths{:}];
[k_count,k_center] = hist(l(idx),N);

xbins = linspace(round(min(k_center))-1,round(median(k_center)+3*std(k_center)),N);
kymo = zeros(maxframe,N);
count = 1;

for b = 1:interval:maxframe
    idx = find([condition.time{:}] == b);
    [k_count,k_center] = hist(l(idx),xbins);
    kymo(b,:)= smooth(k_count/numel(k_count),10);
end

% remove empty elements
kymo = kymo(find(sum(kymo,2)>0),:);

imagesc(kymo);
colormap(hot);
colorbar;

title(title_str);
ybins = get(gca,'YTick');
ybins = round(linspace(1,maxframe,numel(ybins)+1));
x = get(gca,'XTick');
xbins = round(linspace(round(min(k_center))-1,round(max(k_center)),numel(x)+1));
set(gca,'Ydir','normal','YTickLabel',arrayfun(@num2str, ybins(2:end), 'UniformOutput', false));
set(gca,'Xdir','normal','XTickLabel',arrayfun(@num2str, xbins(2:end), 'UniformOutput', false));


ylabel('Time')
xlabel('Length')

if isfield(condition,'ave_fluor')
% plot fluorescence
subplot(sp_r,sp_c,5)
for k = 1:numel(condition.ave_fluor)
    idx = find_smooth_traj(condition.ave_fluor{k},-500);
    if ~isempty(condition.ave_fluor{k}(idx))
    f = smooth(condition.ave_fluor{k}(idx),10);
    c = c0+(c1-c0)*(j-1)/(nc-1);
    plot(condition.time{k}(idx),smooth(condition.ave_fluor{k}(idx),10)-f(1),'Color',c)
    end
    hold on;
    %plot(condition.time{k},condition.ave_fluor{k},'Color',[0.5 0.5 0.5],'LineStyle',':')
end
xlabel('Time')
ylabel('Increase in Fluorescence')

 
% plot instantaneous fluorescence rate
subplot(sp_r,sp_c,6)
for m = 1:numel(condition.ave_fluor)
% change in instantaneous fluorescence
        cf=diff(smooth(condition.ave_fluor{m},10))/(condition.time{1}(2)-condition.time{1}(1));
        cf_t = condition.time{m}(1:end-1);
        c = c0+(c1-c0)*(j-1)/(nc-1);
        plot(cf_t,cf,'Color',c);
        hold on;
end
xlabel('Time')
ylabel('Instantaneous rate of Fluorescence')

% plot fluorescence v length
subplot(sp_r,sp_c,7)
for n = 1:numel(condition.ave_fluor)
    idx = find_smooth_traj(condition.lengths{n},-500);
    if ~isempty(condition.ave_fluor{n}(idx))
    plot(condition.lengths{n}(idx),smooth(condition.ave_fluor{n}(idx),10),'Color',colors)
    end
    hold on;

end
xlabel('Length')
ylabel('Average Fluorescence')   

% plot kymogram
subplot(sp_r,sp_c,8)
maxframe = max([condition.time{:}]);
interval=condition.time{1}(2)-condition.time{1}(1);
N = round(sqrt(numel(condition.growthrate)));

% find ideal bin centers
idx = find([condition.time{:}] == maxframe);
fl = [condition.ave_fluor{:}];
[k_count,k_center] = hist(fl(idx),N);

xbins = linspace(round(min(k_center))-1,round(max(k_center))+3*std(k_center),N);
kymo = zeros(maxframe,N);
count = 1;

for c = 1:interval:maxframe
    idx = find([condition.time{:}] == c);
    [k_count,k_center] = hist(fl(idx),xbins);
    kymo(c,:)= smooth(k_count/sum(k_count),5);
end

% remove empty elements
kymo = kymo(find(sum(kymo,2)>0),:);

imagesc(kymo);
colormap(hot);
colorbar;

title(title_str);
ybins = get(gca,'YTick')*interval;
x = get(gca,'XTick');
xbins = round(linspace(round(min(k_center))-1,round(max(k_center)),numel(x)));
set(gca,'Ydir','normal','YTickLabel',arrayfun(@num2str, ybins(:), 'UniformOutput', false));
set(gca,'Xdir','normal','XTickLabel',arrayfun(@num2str, xbins(:), 'UniformOutput', false));

ylabel('Time')
xlabel('Fluorescence')
end

set(gcf,'NextPlot','add');
axes;
h = title([title_str]);
set(gca,'Visible','off');
set(h,'Visible','on');
ax = gca;
ax.TitleFontSizeMultiplier = 2;
export_fig([title_str '-plots.pdf'])
end

