function data = filtdata(data,varargin)

% default params
exclude = [];
max_cellframe = Inf;
width_threshold = 0.1;
width_maxthreshold = 3;
width_minthreshold = 0;
gr_maxthreshold = 0.06;
gr_minthreshold = 0;
divtime = Inf;
lineage_filt = 0;

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: filtdata(data,[optional] exclude_cid)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

% single width trajectory threshold
x1 = find(cell2mat(cellfun(@(X) any(diff(X.width)./X.width(2:end) > width_threshold),data,'UniformOutput',false))==1);

% too many frames filter
x2 = find(cell2mat(cellfun(@(X) numel(X.length) > max_cellframe,data,'UniformOutput',false))==1);

% max/min width threshold
x3 = [find(cell2mat(cellfun(@(X) any(X.width > width_maxthreshold),data,'UniformOutput',false))==1)];

% lineage filt
x4 = [];
if lineage_filt == 1
    x4 = find(cell2mat(cellfun(@(X) X.lineage ~=1,data,'UniformOutput',false))==1);
end

% max div time 
x5 = find(cell2mat(cellfun(@(X) X.divtime > divtime,data,'UniformOutput',false))==1);

% max width threshold
x6 = [find(cell2mat(cellfun(@(X) any(X.width < width_minthreshold),data,'UniformOutput',false))==1)];


% max width threshold
x7 = [find(cell2mat(cellfun(@(X) any(X.instant_lambda_A > gr_maxthreshold),data,'UniformOutput',false))==1)];

% max width threshold
x8 = [find(cell2mat(cellfun(@(X) any(X.instant_lambda_A < gr_minthreshold),data,'UniformOutput',false))==1)];



% manual cell filter + all other filters
bad_cells = [exclude x1 x2 x3 x4 x5 x6 x7 x8];

% remove filtered cells
allcells =1:numel(data);
filtcells = setdiff(allcells,bad_cells);
data = {data{filtcells}};

end