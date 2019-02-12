
% dname = '/Volumes/homes/amiguel/Imaging/AM_IM76_2016-06-01/0.6mecillinamrpra_phase30_egfp_150_1/';
filelist = dir(['*.tif']);
for j=1:numel(filelist)
    fprintf('%s\n',filelist(j).name)
    h = imfinfo(filelist(j).name);
    for i=1:numel(h)
        % read in image
        str = strsplit(filelist(j).name,'.ome');
        str = str{1};
        output = ['RawImages/' str '-' num2str(i) '.tif'];
        img = imread(filelist(j).name,i);
        imwrite(img,output);
    end
end
