function lineage_contours(varargin)
% lineage_contours 
% lineage_contours(prefix)
% lineage_contours(recalc)
% lineage_contours(directory,prefix)
% lineage_contours(directory,prefix,recalc)

directory = pwd;
prefix = '';
recalc = 1;

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: meshcontours([optional] directory, prefix, recalc)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

if ~strcmp(directory(end),'/')
    directory = [directory '/'];
end

list = dir([directory prefix '*CONTOURS*.mat']);

  %% mesh contour files
  count = 0;
  for i = 1:numel(list)
    count_file = 0;
    fprintf('Loading: %s\n', list(i).name)
    newname = strsplit(list(i).name,'.');
    f = load([directory list(i).name]);
    if isfield(f.cells(1),'mother') == 0 || recalc
      fprintf('Calculating lineage: %s\n',list(i).name);
      f = fix_celllabel(f);
      f = calc_lineage(f);
      
      save([directory newname{1} '_lineage.' newname{2}],'-struct','f');
    end
    count = count + count_file;
  end 
  disp('Done!')
  fprintf('Total # of files from file set: %d\n',count)
end


