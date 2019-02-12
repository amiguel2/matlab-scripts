function convert_stack_to_image(varargin)
prefix = '-Pos';
folder = '';
outfolder = '';
postfix = 'tif';
is_ome = 0;

if ~isempty(varargin)
    % print default variable information
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

% if is_ome == 1
%    prefix = 'ome'; 
% end

% load each of the files starting with prefix
filelist = dir([folder,'*',prefix,'*.',postfix]);
fprintf('Processing %d files with motif *%s*.tif...\n',numel(filelist),prefix);
for j=1:numel(filelist)
    % read in image
    fname = filelist(j).name;
    fprintf('%s (%d / %d)\n',fname,j,numel(filelist))
    if is_ome
        out = strsplit(fname,['.ome.' postfix]);
        out1 = strsplit(out{1},'MMStack_');
        oname = out1{2};
    else
        oname = strsplit(fname,['.' postfix]);
        oname = oname{1};
    end
    if exist([outfolder oname]) == 0
        
        % make a position folder
        mkdir([outfolder oname])
        
        % get number of images and channels of images; 
        n = imfinfo(fname);
        [channels,outputs] = detect_channels(n);
        
        count = 0;
        for i = 1:numel(n)
            img = imread([folder fname], i);
            channel = get_channel(n(i));
            idx = strcmp(channel,channels);
            outname = ['img_',sprintf('_%04d',i),'_',outputs(idx),'.tif'];
            fulloutname = [outfolder oname '/' [outname{:}]];
            imwrite(img,[fulloutname{:}],'WriteMode','append');
            count = count + 1;
        end
    end
end
end

function channel = get_channel(N)
try
    channel = strsplit(N.UnknownTags(end).Value,'"Channel":');
    channel = strsplit(channel{2},'"');
    channel = channel{2};
catch
    channel = 'channel';
end
end

function [channels,outputs] = detect_channels(n)
    channels= {};
    for i = 1:numel(n)
        channels = [channels get_channel(n(i))];
    end
    channels = unique(channels);
    outputs = cellfun(@(x) x(1),cellfun(@strsplit,channels,'UniformOutput',false),'UniformOutput',false);
end
            


