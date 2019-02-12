function align_stacks(varargin)
% mesh_contours 
% mesh_contours(prefix)
% mesh_contours(remesh)
% mesh_contours(directory,prefix)
% mesh_contours(directory,prefix,remesh)

directory = pwd;
prefix = '*Pos*';
suffix = 'Phase';
aligngfp = 0;
gfpchannel = 'GFP';

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

if ~strcmp(directory(end),'/')
    directory = [directory '/'];
end

% list = dir([directory prefix '.tif']);

if aligngfp
    filelist1 = dir([directory prefix suffix '*.tif']);
    filelist2 = dir([directory prefix gfpchannel '*.tif']);
    
    %% calculate fluorescence profiles
    gfp_prefixes = cellfun(@(x) x{1},cellfun(@(x) strsplit(x,['_' gfpchannel]),{filelist2.name},'UniformOutput',0),'UniformOutput',0);
    for j=1:numel(filelist1)
        strtemp1 = strsplit(filelist1(j).name,['_' suffix]);
        strtemp1 = strtemp1{1};
        idx = find(strcmp(gfp_prefixes,strtemp1));
        if idx
            if ~exist([directory strtemp1 '_aligned.tif'])
                stack_alignment(filelist1(j).name,[directory strtemp1 '_aligned.tif'],'fluor_name',filelist2(idx).name,'fluor_output',[directory strtemp1 '_alignedGFP.tif']);
            end
        end
    end
else
    filelist1 = dir([directory prefix suffix '*.tif']);
    for j=1:numel(filelist1)
        strtemp1 = strsplit(filelist1(j).name,['_' suffix]);
        strtemp1 = strtemp1{1};
        stack_alignment(filelist1(j).name,[directory strtemp1 '_aligned.tif'])
    end
end
end