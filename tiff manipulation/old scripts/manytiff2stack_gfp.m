
allPos = dir;
allPos = allPos(3:end);

if ~exist('stacks','dir')
    mkdir stacks
end


makelast = 0;
lastFile = 80;
for l = 1:length(allPos)
    if isdir(allPos(l).name) && ~strcmp(allPos(l).name,'stacks')
        disp(['Making stack from directory ',allPos(l).name,'.']);
        %     cd([allPos(l).name,'/image_1/'])
        cd(['',allPos(l).name])
        if ~makelast
            tiff2stack('*GFP_*.tif',['../stacks/stack',allPos(l).name,'_GFP.tif']);
        else
            tiff2stack('*GFP_*.tif',['../stacks/stack',allPos(l).name,'.tif'],lastFile);
        end
        cd ..
    end
end
