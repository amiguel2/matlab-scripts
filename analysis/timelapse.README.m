%% step 0 Make the phase/gfp stacks

stac

%% step 1 Analyze with Morphometrics

contour_script

%% variables (mesh_stacks.m)
clear
fileprefix = '*Pos*';
filelist = dir([fileprefix,'*CONTOURS.mat']);
filelist2 = dir([fileprefix,'*_GFP.tif']);

params.pxl_size = 0.064; % pixel scaling
%params.pxl_size = 0.043;
params.color0 = [1 0 0]; % colors for plotting lines
params.color1 = [0 1 1];
params.roc_filter = 1;
params.shifttime = 0;

group{1} =[];
%% step 2 mesh cells
for j=2:10%length(filelist)
    %MT_mesh_CT('.',filelist(j).name);
    calculate_fluor_profiles(filelist(j).name,filelist2(j).name,'',[]);
end

%% step 3 define groups (i.e. fields of view)
% if you don't define the group variable, it will just not do any groupings

group{1} = [1:5];
group{2} = [6:9];
group{3} = [10:14];
group{4} = [15:19];


%% step 4 histogram lengths and widths
data_morph = histogram_morphology_cl(filelist,group,params);

%% step 5 growth rates
data_growth = histogram_growthrates_all(filelist,group,params);
%%
clear
fileprefix = 'A22*';
filelist = dir([fileprefix,'*CONTOURS.mat']);
%filelist2 = dir([fileprefix,'*_GFP_*.tif']);

params.pxl_size = 0.064; % pixel scaling
%params.pxl_size = 0.043;
params.color0 = [1 0 0]; % colors for plotting lines
params.color1 = [0 1 1];
params.roc_filter = 1;
params.shifttime = 0;
%group{1} = [];

group{1} = [1:15];
group{2} = [16:30];
group{3} = [31:45];
group{4} = [46:60];
group{5} = [61:75];
group{6} = [76:90];


data_growth = histogram_growthrates_AM(filelist,group,params);
%data_morph = histogram_morphology_cl(filelist,group,params);