function dirNames = ListDirectories(dirPath)
files=dir(dirPath);
isDirInd=[files.isdir]==1;
fileNames={files.name};
validDirNameInd=~ismember(fileNames,{'.','..'});
dirInd=isDirInd & validDirNameInd;
dirNames=fileNames(dirInd);