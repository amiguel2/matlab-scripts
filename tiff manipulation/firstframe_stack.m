function firstframe_stack(prefix)
fileprefix = '*Phase*';
currentFolder = [pwd '/'];
newFolder = [currentFolder 'stacks'];
if exist(newFolder) ~= 7
    mkdir('stacks')
end
folders = dir([prefix '*']);
N_folders = numel(folders);
output = [currentFolder sprintf('%s_firstframes.tif',prefix)];
for i = 1:N_folders
    fprintf('%s\n',folders(i).name)
    cd(folders(i).name)
    files = dir(fileprefix);
    for j = 1%:N_files
        imwrite(uint16(imread(files(j).name)),output,'WriteMode','append');
    end
    cd ../
end
end
