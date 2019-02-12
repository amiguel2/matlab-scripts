%% Merge Stacks

path1='/sentinel/data/Amanda/14-01-18/BW25113_rprA_sfGFP_50ms_phase_35ms_GFP_2ugmlA22_1/stacks/';
path2='/sentinel/data/Amanda/14-01-18/BW25113_rprA_sfGFP_50ms_phase_35ms_GFP_2ugmlA22_2/stacks/';
output='/home/amiguel/01-18/2ugmlA22/';

cd ([path1])
filelist = dir(['*.tif']);

for j=1:numel(filelist)
    f1 = [path1,filelist(j).name];
    f2 = [path2,filelist(j).name];
    o = [output,filelist(j).name];
    img1 = imread(f1);
    img2 = imread(f2);
    imwrite(img1,o,'WriteMode','append');
    imwrite(img2,o,'WriteMode','append');
end