function data = filtdata(data,vargargin)

% default params
exclude = [];
max_cellframe = 20;

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

% too many frames filter
x = find(cell2mat(cellfun(@(X) numel(X.length) < max_cellframe,data,'UniformOutput',false))==1);

% manual cell filter + all other filters
bad_cells = [exclude x];

% remove filtered cells
allcells =1:numel(data);
filtcells = setdiff(allcells,bad_cells);
data = {data{filtcells}};

end