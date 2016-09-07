function fluor_contours(varargin)
  %can specify directory, otherwise uses current directory
  if numel(varargin) == 1
    %% get file lists
    fileprefix = '*Pos*';
    filelist1 = dir([varargin{1} '/' fileprefix,'*CONTOURS.mat']);
    filelist2 = dir([varargin{1} '/' fileprefix,'*_ETGFP.tif']);
  else
    %% get file lists
    fileprefix = '*Pos*';
    filelist1 = dir([fileprefix,'*CONTOURS.mat']);
    filelist2 = dir([fileprefix,'*_ETGFP*.tif']);
  end
  %% calculate fluorescence profiles
  gfp_prefixes = cellfun(@(x) x{1},cellfun(@(x) strsplit(x,'_ETGFP'),{filelist2.name},'UniformOutput',0),'UniformOutput',0);
  for j=1:numel(filelist1)
    strtemp1 = strsplit(filelist1(j).name,'_Phase');
    strtemp1 = strtemp1{1};
    idx = find(strcmp(gfp_prefixes,strtemp1));
    if idx
        calculate_fluor_profiles(filelist1(j).name,filelist2(idx).name,'',[]);
    end
  end
end