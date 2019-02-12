function roc_contours(varargin)
%can specify directory, otherwise uses current directory
directory = pwd;
prefix = '';
suffix = '31-Dec-2018_CONTOURS';

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: get_data(list,tframe,pxl,[optional] fluor lineage tshift microbej onecolor)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end
if ~strcmp(directory(end),'/')
    directory = [directory '/'];
end
list = dir([directory prefix '*' suffix '.mat']);
list = list(~cellfun(@(x)strcmp(x(1),'.'),{list.name}));


%% roc contour files

for i = 1:numel(list)
    fprintf('Loading: %s\n', list(i).name)
    newname = strsplit(list(i).name,'.mat');
    newname = [newname{1} '_ROC.mat'];
    
    f = load([directory list(i).name],'frame');
    newf = struct();
    newf.frame = struct();
    count = 0;
    totalcount = 0;
    
    for k = 1:numel(f.frame)
        passed_roc = [];
        for j = 1:numel(f.frame(k).object)
            %fprintf('%d %d\n',k,j)
            totalcount = totalcount + 1;
            [roc,~] = test_roc_rod(f.frame(k).object(j));
            if roc
                passed_roc = [passed_roc j];
                count = count + 1;
            end
        end
        if numel(passed_roc) > 0
            newf.frame(k).num_objs = numel(passed_roc);
            newf.frame(k).object = f.frame(k).object(passed_roc);
            if isfield(f.frame(k),'blank')
                newf.frame(k).blank = f.frame(k).blank;
            end
            if isfield(f.frame(k),'medblankY')
                newf.frame(k).medblankY = f.frame(k).medblankY;
            end
        else
            newf.frame(k).num_objs = 0;
            newf.frame(k).object = [];
            if isfield(newf.frame(k),'blank')
                newf.frame(k).blank = [];
            end
            if isfield(newf.frame(k),'blank')
                newf.frame(k).medblankY = [];
            end
        end
    end
    fprintf('%s: ROC: %d %2.f%%\n',list(i).name,count,count/totalcount*100)
    save([directory newname],'-struct','newf');
    
end
end