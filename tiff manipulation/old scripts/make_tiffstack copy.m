
function make_tiffstack(prefix,output, varargin)

%delete if already exists
delete(output);
% load each of the files starting with prefix
filelist = dir(['*',prefix,'*.tif']);

n = numel(filelist);
step = 1;
start = 1;

if nargin == 3
    n = varargin{1};
    step = 1;
    start = 1;
elseif nargin == 4
    n = varargin{1};
    step = varargin{2};
    start = 1;
elseif nargin == 5
    n = varargin{1};
    step = varargin{2};
    start = varargin{3};
else
    step = 1;
end
o = Tiff(output,'a');
o.setTag('ImageLength',n);
fprintf('Processing %d files with motif *%s*.tif...\n',(n-start+1)/step,prefix);
for j=start:step:n
    % read in image
    data = read(filelist(j).name);
    t = Tiff(filelist(j).name,'r');
    imageData = read(t);
    
    if j == 1
        saveastiff(imageData,output);
    else
        options.append = true;
        saveastiff(imageData, output, options);
    end

    % t = Tiff(output,'a');
    % t.setTag('Photometric',Tiff.Photometric.MinIsBlack); % assume grayscale
    % t.setTag('BitsPerSample',32);
    % t.setTag('SamplesPerPixel',1);
    % t.setTag('SampleFormat',Tiff.SampleFormat.IEEEFP);
    % t.setTag('ImageLength',size(data,1));
    % t.setTag('ImageWidth',size(data,2));
    % t.setTag('PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
    % t.write(data);
    % t.close();
end

end