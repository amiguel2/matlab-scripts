function convert_folders_to_stacks(varargin)
tic
% converts a multichannel .ome. stack and if split into multiple tiffs,
% concats stacks with the same position name
folder = [pwd '/'];
o_folder = [folder 'stacks/'];
make_one_stack = 0;
phasechannel = 'ETGFP_000';
stack_gfp = 0;
gfpchannel = 'EGFP';
dirprefix = '*-Pos';
checkfileminframes = 0;
N_files = 60; 
N_folders = Inf;
skipframe = 1;

if ~isempty(varargin)
    % print default variable information using functionname -h
    if strcmp(varargin{1},'-h')
        fprintf('To change variables, use: %s(''variablename'',variablevalue,...)\n',mfilename)
        fprintf('Default variables for %s:\n',mfilename)
        myvals = who;
        for n = 1:length(myvals)
            if ~strcmp(myvals{n},'varargin')
                if isstring(eval(myvals{n})) || ischar(eval(myvals{n}))
                    fprintf('%s = ''%s''\n',myvals{n},eval(myvals{n}))
                elseif isinteger(eval(myvals{n})) || isfloat(eval(myvals{n}))
                    fprintf('%s = %s\n',myvals{n},num2str(eval(myvals{n})))
                else
                    fprintf('%s = ''''\n',myvals{n})
                end
            end
        end
       return
    end

    % check if even numbered variables
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Improper arguments. Use ''-h'' flag to see options')
        return
    end

    % change variables
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

if ~strcmp(o_folder(end),'/')
    o_folder = [o_folder '/'];
end

phasestackname = [erase(dirprefix,'*') '_' phasechannel '.tif'];
if stack_gfp
    gfpstackname = [erase(dirprefix,'*') '_' gfpchannel '.tif'];
end

% if taking all folders and making one stack
if make_one_stack
    if contains(phasechannel,'feature')
        d = dir([folder dirprefix '*']);
        for j=1:numel(d)
            if d(j).isdir
                reorderfiles([folder d(j).name '/Output/'],phasechannel)
            end
        end
         filelist1 = rdir([folder dirprefix '*/Output/' phasechannel '*.tif']);
         %% NEED TO ADD removal of hidden files for rdir lists
         if isinf(N_files)
         concat_tiffs(filelist1,[o_folder phasestackname])
         else
             concat_tiffs(filelist1(1:skipframe:N_files),[o_folder phasestackname])
         end
    else
        filelist1 = rdir([folder dirprefix '*/*' phasechannel '*.tif']);
        filelist1 = filelist1(~cellfun( @(x) contains(x,'._'),{filelist1.name})); %% 2018-11-05 added removal of hidden files for rdir lists
         if isinf(N_files)
             concat_tiffs(filelist1,[o_folder phasestackname])
         else
             concat_tiffs(filelist1(1:skipframe:N_files),[o_folder phasestackname])
         end
    end
   if stack_gfp
       if contains(gfpchannel,'feature')
           d = dir([folder dirprefix '*']);
           for j=1:numel(d)
               if d(j).isdir
                   reorderfiles([folder d(j).name '/Output/'],gfpchannel)
               end
           end
           filelist2 = rdir([folder dirprefix '*/Output/' gfpchannel '*.tif']);
           if isinf(N_files)
               concat_tiffs(filelist2,[o_folder gfpstackname])
           else
               concat_tiffs(filelist2(1:skipframe:N_files),[o_folder gfpstackname])
           end
       else
           filelist2 = rdir([folder dirprefix '*/img_*' gfpchannel '*.tif']);
           if isinf(N_files)
               concat_tiffs(filelist2,[o_folder gfpstackname])
           else
               concat_tiffs(filelist2(1:skipframe:N_files),[o_folder gfpstackname])
           end
       end
   end

% if making timelapse stacks
else
    cd(folder)
    d = dir([folder dirprefix '*']);
    if isinf(N_folders)
        N_folders = numel(d);
    end
    for j=1:N_folders
        %get number of files
        if contains(phasechannel,'feature')
            N = checknumfiles([folder d(j).name '/Output/'], phasechannel);
        else
            N = checknumfiles([folder d(j).name], phasechannel);
        end

        % check if number of files greater
        if numel(N) > checkfileminframes

            % ignore . files
            if ~strcmp(d(j).name(1),'.')

                % check if output file exists
                output1 = [o_folder d(j).name '_' phasechannel '.tif'];
                output2 = [o_folder d(j).name '_' gfpchannel '.tif'];

                % save phase stacks
                if exist(output1, 'file') ~= 2
                    % reorder if feature
                    if contains(phasechannel,'feature')
                        cd([folder d(j).name '/Output/'])
                        fprintf('Reordering...\n')
                        reorderfiles([folder d(j).name '/Output/'],phasechannel)
                        filelist = dir([folder d(j).name '/Output/*' phasechannel '*.tif']);
                        filelist = filelist(~cellfun(@(x) strcmp(x(1),'.'),{filelist.name})); % remove hidden files
                    else
                        cd([folder d(j).name])
                        filelist = dir([folder d(j).name '/*' phasechannel '*.tif']);
                        filelist = filelist(~cellfun(@(x) strcmp(x(1),'.'),{filelist.name})); % remove hidden files
                    end
                    % save stack
                    if isinf(N_files)
                        concat_tiffs(filelist,output1)
                    else
                        concat_tiffs(filelist(1:skipframe:N_files),output1)
                    end
                        
                end

                % save gfp stacks
                if stack_gfp
                    if exist(output2, 'file') ~= 2
                        % reorder if feature
                        if contains(gfpchannel,'feature')
                            cd([folder d(j).name '/Output/'])
                            fprintf('Reordering...\n')
                            reorderfiles([folder d(j).name '/Output/'],gfpchannel)
                            filelist = dir([folder d(j).name '/Output/*' gfpchannel '*.tif']);
                             filelist = filelist(~cellfun(@(x) strcmp(x(1),'.'),{filelist.name})); % remove hidden files
                        else
                            cd([folder d(j).name])
                            filelist = dir([folder d(j).name '/*' gfpchannel '*.tif']);
                             filelist = filelist(~cellfun(@(x) strcmp(x(1),'.'),{filelist.name})); % remove hidden files
                        end
                        % save stack
                        if isinf(N_files)
                        concat_tiffs(filelist,output2)
                        else
                            concat_tiffs(filelist(1:skipframe:N_files),output2)
                        end
                    end
                end
                cd(folder)
            end
        end
    end
end
toc
end

function concat_tiffs(filelist,outputname)
fprintf('Processing %d files to %s...\n',numel(filelist),outputname);
for j=1:numel(filelist)
    fname = filelist(j).name;
    % read in image
    n = imfinfo(fname);
    for i = 1:numel(n)
        img = imread(fname, i);

        if contains(fname,'feature')
            iteration_to_average = max(max(img));
            img = double(img./iteration_to_average);
        end

        imwrite(img,outputname(find(~isspace(outputname))),'WriteMode','append');
    end
end
end

function N = checknumfiles(path,prefix)
if contains(prefix,'feature')
    checkfiles = rdir([path '/Output/' prefix '*.tif']);
else
    checkfiles = rdir([path '/*' prefix '*.tif']);
end
N = numel(checkfiles);
end

function reorderfiles(path,prefix)

% reorder if feature file
if contains(prefix,'feature')
    filelist = rdir([path '*' prefix '*']);
    for i = 1:numel(filelist)
        tmp0 = strsplit(filelist(i).name,'/');
        tmp = strsplit(tmp0{end},'_');
        tmp1 = strsplit(tmp{end},'.');
        if numel(tmp1{1}) == 1
            movefile(filelist(i).name,[path sprintf('%s_',tmp{1:3}) '00' tmp1{1} '.tif'])
        elseif numel(tmp1{1}) == 2
            movefile(filelist(i).name,[path '/' sprintf('%s_',tmp{1:3}) '0' tmp1{1} '.tif'])
        end
    end
end

end
