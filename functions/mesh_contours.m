function mesh_contours(varargin)
% mesh_contours 
% mesh_contours(prefix)
% mesh_contours(remesh)
% mesh_contours(directory,prefix)
% mesh_contours(directory,prefix,remesh)

  %can specify directory, otherwise uses current directory
  if numel(varargin) == 1
      if isa(varargin{1},'char')
        list = dir(['*' varargin{1} '*.mat']);
        remesh = 0;
      elseif isa(varargin{1},'double')
        remesh = varargin{1};
        list = dir('*.mat');
      end
  elseif numel(varargin) == 2
      if isa(varargin{2},'str')
        list = dir([varargin{2} '/*' varargin{1} '*.mat']);
        remesh = 0;
      elseif isa(varargin{1},'double')
        remesh = varargin{1};
        list = dir('*.mat');
      end
      
  elseif numel(varargin) == 3
        list = dir([varargin{2} '/*' varargin{1} '*.mat']);
        remesh = varargin{3};
  else
    list = dir('*.mat');
    remesh = 0;
  end

  %% mesh contour files
  count = 0;
  for i = 1:numel(list)
    count_file = 0;
    fprintf('Loading: %s\n', list(i).name)
    f = load(list(i).name);
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
      if numel(varargin) == 1 && isa(varargin{1},'str')
        save([varargin{1} '/' list(i).name],'-struct','f');
      else
        save([list(i).name],'-struct','f');
      end
    end
    count = count + count_file;
  end 
 fprintf('Total # of cells from file set: %d\n',count)
end


