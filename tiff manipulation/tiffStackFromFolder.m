function tiffStackFromFolder(inputfolder,outputfolder,prefix,pattern)

% folders = ListDirectories(inputfolder);

if ~exist(outputfolder)
    mkdir(outputfolder)
end

imageNames = FindAllTiffs(inputfolder,pattern);
for k = 1:numel(imageNames)
    tempImage = imread(imageNames{k});
    if k==1
        sat = 0;
        clim = stretchlim(tempImage,[sat 1-sat]);
    end
    tempImage = imadjust(tempImage,clim);
    tempImage = uint8(bitshift(tempImage,-8));
    if k == 1
        imwrite(tempImage, fullfile(outputfolder,[prefix,...
            '.tif']),'tiff','compression','none');
    else
        imwrite(tempImage, fullfile(outputfolder,[prefix,...
            '.tif']),'tiff','compression','none',...
            'writemode','append')
    end
end

function dirNames = FindAllSubDir(dirPath,dirNames)
% find all subdirectories

if nargin < 2
    dirNames = {};
end

dirsThisLevel = ListDirectories(dirPath);

for j = 1:numel(dirsThisLevel)
    dirNames = [dirNames,{fullfile(dirPath,dirsThisLevel{j})}];
    dirNames = FindAllSubDir(fullfile(dirPath,dirsThisLevel{j}),dirNames);
end


function imageNames = FindAllTiffs(dirPath,pattern)

imageNames = {};

% dirNames = FindAllSubDir(dirPath);
dirNames{1} = dirPath;


for j = 1:numel(dirNames)
    TIFFnames = dir(fullfile(dirNames{j},sprintf('*%s*.tif',pattern)));
    for k = 1:numel(TIFFnames)
        imageNames = [imageNames,{fullfile(dirNames{j},TIFFnames(k).name)}];
    end
end

function dirNames = ListDirectories(dirPath)

files = dir(dirPath);

isDirInd = [files.isdir]==1;

fileNames = {files.name};

validDirNameInd = ~ismember(fileNames,{'.','..'});

dirInd = isDirInd & validDirNameInd;

dirNames = fileNames(dirInd);