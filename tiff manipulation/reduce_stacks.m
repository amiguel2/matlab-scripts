function reduce_stacks(prefix, Finput)
% function to take stacks and reduce based on either list or by a fixed
% number. If a list, Finput will save a new .tif only with those frames. If
% a single number, function will skip frames using that value. 
% 2018-10-29 Amanda Miguel

% load each of the files starting with prefix
filelist = rdir(['*',prefix,'*.tif']);


if length(Finput) > 1
    fprintf('Save %d files with provided frames...\n',numel(filelist));
else
    fprintf('Reduce %d files, skipping by...\n',numel(filelist),skip);
end

%remove hidden files
idx = cellfun(@(x) x(1) ~= '.',{filelist.name}); 
filelist = filelist(idx);

for i = 1:numel(filelist)
    n = numel(imfinfo(filelist(i).name));
    start = 1;
    % output name
    temp = strsplit(filelist(i).name,'.tif');
    output = ['stacks/' temp{1} '_reduced.tif'];
    
if length(Finput) > 1
    skip = 1;
    frames = Finput;
else
    
    skip = Finput;
    frames = start:skip:n;
end

for j=frames
    % read in image
    fprintf('%s...\n',filelist(i).name)
    img = imread(filelist(i).name,j);
    imwrite(uint16(img),output,'WriteMode','append');
end

end