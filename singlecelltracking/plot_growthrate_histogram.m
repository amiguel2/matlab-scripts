function plot_growthrate_histogram(cond,varargin)

%load cond into workspace
%data = load(data);

% default optional values
leg={'Empty','WT','Peri','IM'};
colors=[0 0 1; 1 0 0; 0 1 0; 0.5 0 0.5];
bin = [15 25 40 35];

numel(varargin)
if length(varargin) == 1
    leg = varargin{1};
elseif length(varargin) == 2
    leg=varargin{1};
    colors = varargin{2};
elseif length(varargin) == 3
    leg=varargin{1};
    colors = varargin{2};
    bin = varargin{3};
    
elseif length(varargin) > 3
    error('myfuns:somefun2:TooManyInputs', ...
        'requires at most 2 optional inputs');
    fprintf('try: plot_growthrate_histogram(data,title,leg,color,bins)');
end

%% growthrate histogram
% 
% gr is cell structure with all growthrates
h = cell(1,length(cond));
gr = cell(1,length(cond));
for i=1:length(gr)
    gr{i} = [cond{i}.growthrate];
end

for k = 1:numel(gr)
    [counts,centers] = hist(cellfun(@(x) x,gr{k}),bin(k)); %binround(sqrt(numel(gr{k})))
    h{k} = fill([centers(1) centers centers(end)],[0 counts/sum(counts) 0],colors(k,:),'FaceAlpha',0.1,'EdgeColor',colors(k,:));
    hold on;
    Ylim = get(gca,'Ylim');
    plot(median([gr{k}{:}])*ones(1,2),[0 Ylim(2)],'LineStyle',':','Color',colors(k,:))
end
%xlim([0 0.04])
legend([h{1},h{2},h{3},h{4}],leg)
%title(title_str)
%print('growthrate_histogram-roc', '-dpdf')
%close
