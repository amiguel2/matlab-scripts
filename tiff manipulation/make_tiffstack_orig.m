function make_tiffstack(prefix,output)

delete(output);
% load each of the files starting with prefix
filelist = dir(['*',prefix,'*.tif']);

fprintf('Processing %d files with motif *%s*.tif...\n',numel(filelist),prefix);
for j=1:numel(filelist)
    % read in image
    img = imread(filelist(j).name);

    imwrite(img,output,'WriteMode','append');
end