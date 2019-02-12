function make_image_subset(prefix,N_folders,N_files)
currentFolder = [pwd '/'];
newFolder = [currentFolder 'subset'];
if exist(newFolder) ~= 7
    mkdir('subset')
end
folders = dir(prefix);

if N_folders == Inf
    N_folders = numel(folders);
end

for i = 1:N_folders
    fprintf('%s: %d\n',folders(i).name,N_files)
    newfolder = [newFolder '/' folders(i).name '/'];
    mkdir(newfolder)
    cd(folders(i).name)
    files = dir('*Phase*');
    for j = 1:N_files
        copyfile(files(j).name,newfolder)
    end
    cd ../
end
end
