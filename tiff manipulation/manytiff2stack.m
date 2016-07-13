
allPos = dir;
allPos = allPos(3:end);

if ~exist('stacks','dir')
    mkdir stacks
end


for l = 1:length(allPos)
    if isdir(allPos(l).name) && ~strcmp(allPos(l).name,'stacks')
        disp(['Making stack from directory ',allPos(l).name,'.']);
        %     cd([allPos(l).name,'/image_1/'])
        cd(['',allPos(l).name])
        if l == 1
        tiff2stack('*.tif',['../stacks/stack',allPos(l).name,'_Phase.tif']);
        
        cd ..
    end
end
