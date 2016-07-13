function imageNames = FindAllTiffsSubDir(dirPath,varargin)

if nargin < 2
    prefix = '*';
    suffix = '*.tif';
elseif nargin < 3
    prefix = varargin{1};
    suffix = '*.tif';
else
    prefix = varargin{1};
    suffix = varargin{2};
end


imageNames={};

dirNames=FindAllSubDir(dirPath);
dirNames=[dirNames dirPath];

for j = 1:numel(dirNames)
    TIFFnames = dir(fullfile(dirNames{j},['*' prefix suffix]));
    for k = 1:numel(TIFFnames)
        imageNames = [imageNames,{fullfile(dirNames{j},TIFFnames(k).name)}];
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


