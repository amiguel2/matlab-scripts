%% generate stacks
% output = stacks/$dir_$prefix.tif

prefix = 'GFP_'; % ex.'feature_1','Phase'
dirprefix = '*Pos*'; % ex. '*Pos*'
polaris_crop = 0; % crops edges of image if polaris image

folder = [pwd '/'];
ofolder = '/Volumes/Mac/am_im33/A22-0/';ex
%ofolder = [folder 'stacks/'];
cd(folder)
d = dir([folder dirprefix]);
checkfileminframes = 0;
frameint = 1;

for j=1:numel(d)
    
    %get number of files
    if contains(prefix,'feature')
        checkfiles = dir([folder d(j).name '/Output/' prefix '*']);
    else
        checkfiles = dir([folder d(j).name '/*' prefix '*']);
    end
    
    % check if number of files greater
    if numel(checkfiles) > checkfileminframes
        if ~strcmp(d(j).name(1),'.')
            
            % check if output file exists
            output = [ofolder d(j).name '_' prefix '.tif'];
            if exist(output, 'file') ~= 2
                
                % reorder if feature
                if contains(prefix,'feature')
                    cd([folder d(j).name '/Output/']);
                    
                    filelist = dir([prefix '*']);
                    for i = 1:numel(filelist)
                        tmp = strsplit(filelist(i).name,'_');
                        tmp1 = strsplit(tmp{end},'.');
                        if numel(tmp1{1}) == 1
                            movefile(filelist(i).name,[sprintf('%s_',tmp{1:3}) '00' tmp1{1} '.tif'])
                        elseif numel(tmp1{1}) == 2
                            movefile(filelist(i).name,[sprintf('%s_',tmp{1:3}) '0' tmp1{1} '.tif'])
                        end
                    end
                else
                    cd([folder d(j).name]);
                end
                
                % save stack
                filelist = dir(['*' prefix '*.tif']);
                if numel(filelist) > 0
                    fprintf('%s\n',d(j).name)
                    for i = 1:frameint:numel(filelist)
                        img = imread(filelist(i).name);
                        
                        % average by number of iterations performed in
                        % DeepCell, if using my DeepCell version
                        if contains(prefix,'feature')
%                             fprintf('averaging to max intensity\n')
                            iteration_to_average = max(max(img));
                            img = img./iteration_to_average;
                        end
                        if polaris_crop
                            imwrite(uint16(img(1:2160,100:2460)),output,'WriteMode','append');
                        else
                            imwrite(uint16(img),output,'WriteMode','append');
                        end
                    end
                end
            end
            cd(folder)
        end
    end
end
beep