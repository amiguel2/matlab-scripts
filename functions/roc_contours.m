function roc_contours(varargin)
%can specify directory, otherwise uses current directory
directory = pwd;
prefix = '';
remesh = 0;

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
list = dir([directory '*' prefix '*CONTOURS.mat']);

%% roc contour files

for i = 1:numel(list)
    fprintf('Loading: %s\n', list(i).name)
    f = load([directory list(i).name]);
    count = 0;
    total_count = 0;
    if isfield(f.frame(1).object,'roc') == 0 | remesh
        for k = 1:numel(f.frame)
            for j = 1:numel(f.frame(k).object)
                %fprintf('%d %d\n',k,j)
                total_count = total_count + 1;
                f.frame(k).object(j).roc = test_roc(f.frame(k).object(j));
                if f.frame(k).object(j).roc == 1
                    count = count + 1;
                end
            end
        end
        fprintf('%s: %d %2.f%%\n',list(i).name,count,count/total_count*100)
        save([directory list(i).name],'-struct','f');
    else
        %fprintf('%s: already roc',list(i).name)
    end
end
end