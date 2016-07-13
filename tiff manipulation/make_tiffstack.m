


function make_tiffstack(prefix,output, varargin)

%delete(output);
% load each of the files starting with prefix
filelist = dir(['*',prefix,'*.tif']);

n = numel(filelist);

if nargin == 3
   n = varargin{1};
   step = 1;
elseif nargin == 4
   n = varargin{1};
   step = varargin{2};

else
    step = 1;
end 

fprintf('Processing %d files with motif *%s*.tif...\n',n,prefix);
for j=1:step:n
    % read in image
    img = imread(filelist(j).name);
    imwrite(img,output,'WriteMode','append');
end
end