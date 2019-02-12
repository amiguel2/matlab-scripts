function tiff2stack_alex(filenamepattern,filenameout,varargin)
%TIFF2STACK    generates a single multiframe tiff stack from a list of tiff
%              files matching 'filenamepattern'. The multiframe tiff is
%              written out to 'filenameout'. 
%TIFF2STACK assumes that the tiff files are numerically and unambiguously 
% sortable. Typical outputs from micromanager achieve this.
%TIFF2STACK(...,...,N) will only combine the first N sorted images.

if (nargin == 3)
    maxi = varargin{1};
else
    maxi = Inf;
end
filenames = dir(filenamepattern);

% First write out the file.
imwrite((imread(filenames(1).name,'tif')),filenameout);
% then append to it:
for l = 2:min([length(filenames),maxi]);
    imwrite((imread(filenames(l).name)), filenameout,'writemode','append');
end

end