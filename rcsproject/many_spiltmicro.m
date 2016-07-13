files = dir('*GFP.tif');
output = 'microcolonies/';

for i = 37:numel(files)
    fprintf('%s\n',files(i).name)
    split_microcolonies(files(i).name,'fluor_in',output)
end
