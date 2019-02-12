


function N = make_tiffstack1(prefix,output, frames)

%delete(output);
% load each of the files starting with prefix
filelist = rdir(['*',prefix,'*.tif']);

%remove hidden files
idx = cellfun(@(x) x(1) ~= '.',{filelist.name}); 
filelist = filelist(idx);

n = numel(filelist);
start = 1;

fprintf('Processing %d files...\n',numel(frames));

for a=frames
    % read in image
    img = imread(filelist(a).name);
%     img = img(16:end-15,16:end-15);
    imwrite(uint16(img),output,'WriteMode','append');
end
end