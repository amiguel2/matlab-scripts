function fluor_contours(varargin)

directory = pwd;
prefix = '';
gfpchannel = 'GFP';
phasechannel = 'Phase';

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: meshcontours([optional] directory, prefix, remesh)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

if ~strcmp(directory(end),'/')
    directory = [directory '/'];
end

filelist1 = dir([directory '*' prefix '*CONTOURS.mat']);
filelist2 = dir([directory '*' prefix '*_' gfpchannel '.tif']);

  %% calculate fluorescence profiles
  gfp_prefixes = cellfun(@(x) x{1},cellfun(@(x) strsplit(x,['_' gfpchannel]),{filelist2.name},'UniformOutput',0),'UniformOutput',0);
  for j=1:numel(filelist1)
    strtemp1 = strsplit(filelist1(j).name,['_' phasechannel]);
    strtemp1 = strtemp1{1};
    idx = find(strcmp(gfp_prefixes,strtemp1));
    if idx
        calculate_fluor_profiles(filelist1(j).name,filelist2(idx).name,'',[]);
    end
  end
end