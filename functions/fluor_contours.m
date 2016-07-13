function fluor_contours(varargin)
  %can specify directory, otherwise uses current directory
  if numel(varargin) == 1
    %% get file lists
    fileprefix = 'Rcs21*';
    filelist1 = dir([varargin{1} '/' fileprefix,'*CONTOURS.mat']);
    filelist2 = dir([varargin{1} '/' fileprefix,'*_GFP.tif']);
  else
    %% get file lists
    fileprefix = '*Rcs21*';
    filelist1 = dir([fileprefix,'*CONTOURS.mat']);
    filelist2 = dir([fileprefix,'*_GFP*.tif']);
  end
  %% calculate fluorescence profiles
  for j=1:numel(filelist1) 
    calculate_fluor_profiles(filelist1(j).name,filelist2(j).name,'',[]);
  end
end