function mesh_contours(varargin)
% mesh_contours 
% mesh_contours(prefix)
% mesh_contours(remesh)
% mesh_contours(directory,prefix)
% mesh_contours(directory,prefix,remesh)

directory = pwd;
prefix = '';
remesh = 0;

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: meshcontours([optional] directory, prefix, remesh)\n')
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

  %% mesh contour files
  count = 0;
  for i = 1:numel(list)
    count_file = 0;
    fprintf('Loading: %s\n', list(i).name)
    f = load([directory list(i).name]);
    if isfield(f.frame(1).object,'mesh') == 0 || remesh
      fprintf('Meshing: %s\n',list(i).name);
      for k = 1:numel(f.frame)
        for j = 1:numel(f.frame(k).object)
          try
          [m,l,w] = calculate_mesh(f.frame(k).object(j));
          f.frame(k).object(j).mesh = m;
          f.frame(k).object(j).cell_length = l;
          f.frame(k).object(j).cell_width = w;
          count_file = count_file + 1;
          catch
          end
        end
      end
      fprintf('%s: %d\n',list(i).name,count_file)
      save([directory list(i).name],'-struct','f');
    end
    count = count + count_file;
  end 
 fprintf('Total # of cells from file set: %d\n',count)
end


