function concat_tiffs(filelist,outputname)
fprintf('Processing %d files to %s...\n',numel(filelist),outputname);
for j=1:numel(filelist)
    fname = filelist(j).name;
    % read in image
    n = imfinfo(fname);
    for i = 1:numel(n)
        img = imread(fname, i);
        imwrite(img,outputname,'WriteMode','append');
    end
end
end