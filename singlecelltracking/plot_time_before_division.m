function plot_time_before_division(data,title_str,varargin)

%load cond into workspace
data = load(data);

%default optional values
leg={'Empty','WT','Peri','IM'};
colors=[0 0 1; 1 0 0; 0 1 0; 0.5 0 0.5];
bins = [15 25 40 35];

if length(varargin) == 3
    leg = varargin{3};
elseif length(varargin) == 4
    leg=varargin{3};
    colors = varargin{4};
elseif length(varargin) == 5
    leg=varargin{3};
    colors = varargin{4};
    bins = varargin{5};
    
elseif length(varargin) > 5
    error('myfuns:somefun2:TooManyInputs', ...
        'requires at most 2 optional inputs');
    fprintf('try: plot_growthrate_histogram(data,title,leg,color, bins)');
end


for i = 1:numel(data.cond)
    division_time = [];
    t = data.cond{i}.time{1};
    tpermin = t(2)-t(1);
    for j = 1:numel(data.cond{i}.lengths)
        division_time = [division_time numel(data.cond{i}.lengths{j})*tpermin];
        hold on;
    end


[counts,centers] = hist(division_time,bins(i));
fill([centers(1) centers centers(end)],[0 counts/numel(counts) 0],colors(i,:),'FaceAlpha',0.1,'EdgeColor',colors(i,:));
hold on;
end
xlabel('Time before devision')
ylabel('frequencies')
title(title_str)
legend(leg)

print('Time before devision', '-dpdf')
end

