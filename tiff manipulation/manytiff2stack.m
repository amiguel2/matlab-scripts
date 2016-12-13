one_tiff = 1; % one stack (1) or stack by subdirectory (0)
splitchannel = 0; % if splitchannel = 1, assumes two channels in 1 stack. 
channel = 'Phase'; % specify channel (Phase); if splitchannel=1, suggest using 'channel'
prefix = '*Phase'; % prefix for images you are searching for (Phase,GFP,feature_1,...)
numframes = Inf; % Specify Inf if you want all frames. This applies to both directory tiffs and one_tiff. 

%%% NOTE: if using direct deepcell output, check tiff2stack and turn
%%% deepcellformat on. 

allPos = dir;
allPos = allPos(4:end);

if ~exist('stacks','dir') %&& ~one_tiff % only makes if not one tiff stack
    mkdir stacks
end
count = 0;
for l = 1:numel(allPos)
    if isdir(allPos(l).name) && ~strcmp(allPos(l).name,'stacks') %&& strcmp(allPos(l).name,'Pos')
        disp(['Making stack from directory ',allPos(l).name,'.']);
        %     cd([allPos(l).name,'/image_1/'])
        cd(['',allPos(l).name])
        if numel(dir([prefix '*.tif'])) > 0 % checks if there is even any images
            if one_tiff % save in one tiff
                if count < numframes
                    %try
                        tiff2stack([prefix '*.tif'],['../stacks/stack',allPos(l).name,'_',channel,'.tif'],'nframe',numframes,'splitchannel',splitchannel); % puts all images in one stack
                        count = count + 1;
                    %end
                else
                    cd ../../
                    fprintf('Done\n')
                    return
                end
            else % save as directory tiff
                tiff2stack([prefix '*.tif'],['../stacks/stack',allPos(l).name,'_',channel,'.tif'],'nframe',numframes,'splitchannel',splitchannel); % puts all images in a stack named after directory
            end
        end
        cd ..
    end
end
fprintf('Done\n')
