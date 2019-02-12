function stack_alignment(imagestack,outputname,varargin)

fluor_name = 'NaN';
fluor_output = 'gfp_align.tif';

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

% set up params
N = numel(imfinfo(imagestack));
usfac = 10;

% set up first image
image1 = imread(imagestack,1);
imwrite(image1,outputname,'Writemode','append')
fftimg1 = fft2(image1);
% if gfp channel
if ~strcmp(fluor_name,'NaN')
    newgfp = imread(fluor_name,1);
    imwrite(newgfp,fluor_output,'Writemode','append')
end
fprintf('%s\n1',imagestack)
for i = 2:N
    fprintf(' %i',i)
    
    % load and fourier transform
    image2 = imread(imagestack,i);
    fftimg2 = fft2(image2);
    
    % perform registration
    [output,registered] = dftregistration(fftimg1,fftimg2,usfac);
    
    % write new image
    newimage = imtranslate(image2,[output(4) output(3)]);
    imwrite(newimage,outputname,'Writemode','append')
    
    % if aligning fluorescence to phase, translate and write new image
    if ~strcmp(fluor_name,'NaN')
        gfpimage2 = imread(fluor_name,i);
        newgfp = imtranslate(gfpimage2,[output(4) output(3)]);
        imwrite(newgfp,fluor_output,'Writemode','append')
    end
    
    % set registered image to next alignment reference
    fftimg1 = registered;
end
fprintf(' Done!\n')



end