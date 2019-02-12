function fluor_contours(varargin)

%addpath('/home/amiguel2/matlab/matlab-scripts/functions/')
directory = [pwd '/'];
prefix = '*-Pos';
% gfpchannel = '_EGFP_000';
gfpchannel = '_gfp';
contoursuffix = '_Phase_07-Jun-2018_CONTOURS_FILT';
% contoursuffix = 'Phase_CONTOURS';
profile_calc = 0;
internal_fluor_calc = 0;
frame_blank = 1;
mesh_on =0;
roc_on = 0;
filt_on = 0;

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

if mesh_on
   fprintf('Meshing...\n');
   mesh_contours('prefix',prefix)
end

if roc_on
    fprintf('Roc filter...\n');
    roc_contours('prefix',prefix)
    contoursuffix = [contoursuffix '_ROC'];
end

if filt_on
    fprintf('FILT filter...\n');
    filt_contours('prefix',prefix)
    contoursuffix = [contoursuffix '_FILT'];
end

if ~exist('filelist1','var')
    filelist1 = dir([directory prefix '*' contoursuffix '.mat']);
    filelist1 = filelist1(~cellfun(@(x) strcmp(x(1),'.'),{filelist1.name})); % remove hidden files
end
if ~exist('filelist2','var')
    filelist2 = dir([directory prefix '*' gfpchannel '.tif']);
    filelist2 = filelist2(~cellfun(@(x) strcmp(x(1),'.'),{filelist2.name})); % remove hidden files
end
  %% calculate fluorescence profiles
  gfp_prefixes = cellfun(@(x) x{1},cellfun(@(x) strsplit(x,[gfpchannel]),{filelist2.name},'UniformOutput',0),'UniformOutput',0);
  for j=1:numel(filelist1)
    strtemp1 = strsplit(filelist1(j).name,[contoursuffix]);
    strtemp1 = strtemp1{1};
    idx = find(strcmp(gfp_prefixes,strtemp1));
    if idx
        fprintf('\n%s, %s\n',filelist1(j).name,filelist2(idx).name)
        if profile_calc
          fprintf('\nCalculating profile\n')
          calculate_fluor_profiles(filelist1(j).name,filelist2(idx).name,'',[]);
        end

        if internal_fluor_calc
            fprintf('\nCalculating internal fluorescence\n')
            Fluo_internal_generate(filelist1(j).name,filelist2(idx).name)
        end

        if frame_blank
            fprintf('\nCalculating frame blank\n')
            calc_image_blank(filelist1(j).name,filelist2(idx).name)
        end
    end
  end

load handel
sound(y,Fs)
end
