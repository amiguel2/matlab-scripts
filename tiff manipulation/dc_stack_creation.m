
mfolde

%% feature 0
folder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM130/ceph10_iptg4uM_EWPIM_phase300_ETGFP100_2/';
ofolder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM130/ceph10_iptg4uM_EWPIM_phase300_ETGFP100_2/stacks/';
cd(folder)
d = dir([folder '*Pos*']);
for j=1:numel(d)
    cd([folder d(j).name '/Output/']);
    
    % reorder
    filelist = dir('feature_0*');
    for i = 1:numel(filelist)
        tmp = strsplit(filelist(i).name,'_');
        tmp1 = strsplit(tmp{end},'.');
        if numel(tmp1{1}) == 1
            movefile(filelist(i).name,[sprintf('%s_',tmp{1:3}) '00' tmp1{1} '.tif'])
        elseif numel(tmp1{1}) == 2
            movefile(filelist(i).name,[sprintf('%s_',tmp{1:3}) '0' tmp1{1} '.tif'])
        end
    end
    
    output = [ofolder d(j).name '_feature0.tif'];
    if ~exist(output) 
    filelist = dir('feature_0*.tif');
    if numel(filelist) > 0
        fprintf('%s',d(j).name)
        for i = 1:numel(filelist)
            img = imread(filelist(i).name);
            imwrite(uint16(img),output,'WriteMode','append');
        end
    end
    end
    cd(folder)
end

%% feature 1
folder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM130/ceph10_iptg4uM_EWPIM_phase300_ETGFP100_2/';
ofolder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM130/ceph10_iptg4uM_EWPIM_phase300_ETGFP100_2/stacks/';
cd(folder)
d = dir([folder '*Pos*']);
for j=1:numel(d)
    cd([folder d(j).name '/Output/']);
    
    % reorder
    filelist = dir('feature_1*');
    for i = 1:numel(filelist)
        tmp = strsplit(filelist(i).name,'_');
        tmp1 = strsplit(tmp{end},'.');
        if numel(tmp1{1}) == 1
            movefile(filelist(i).name,[sprintf('%s_',tmp{1:3}) '0' tmp1{1} '.tif'])
        end
    end
    
    output = [ofolder d(j).name '_feature1.tif'];
    filelist = dir('feature_1*.tif');
    if numel(filelist) > 0
        fprintf('%s',d(j).name)
        for i = 1:numel(filelist)
            img = imread(filelist(i).name);
            imwrite(uint16(img),output,'WriteMode','append');
        end
    end
    cd(folder)
end

%% feature 2
folder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM130/ceph10_iptg4uM_EWPIM_phase300_ETGFP100_2/';
ofolder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM130/ceph10_iptg4uM_EWPIM_phase300_ETGFP100_2/stacks/';
cd(folder)
d = dir([folder '*Pos*']);
for j=1:numel(d)
    cd([folder d(j).name '/Output/']);
    
    % reorder
    filelist = dir('feature_2*');
    for i = 1:numel(filelist)
        tmp = strsplit(filelist(i).name,'_');
        tmp1 = strsplit(tmp{end},'.');
        if numel(tmp1{1}) == 1
            movefile(filelist(i).name,[sprintf('%s_',tmp{1:3}) '0' tmp1{1} '.tif'])
        end
    end
    
    output = [ofolder d(j).name '_feature2.tif'];
    filelist = dir('feature_2*.tif');
    if numel(filelist) > 0
        fprintf('%s',d(j).name)
        for i = 1:numel(filelist)
            img = imread(filelist(i).name);
            imwrite(uint16(img),output,'WriteMode','append');
        end
    end
    cd(folder)
end

%% GFP
folder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM130/ceph10_iptg4uM_EWPIM_phase300_ETGFP100_2/';
ofolder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM130/ceph10_iptg4uM_EWPIM_phase300_ETGFP100_2/stacks/';
cd(folder)
d = dir([folder '*Pos*']);
for j=1:numel(d)
    cd([folder d(j).name]);
    
    output = [ofolder d(j).name '_GFP.tif'];
    filelist = dir('*ETGFP_*.tif');
    if numel(filelist) > 0
        if ~exist(output) 
            fprintf('%s',d(j).name)
            for i = 1:numel(filelist)
                img = imread(filelist(i).name);
                imwrite(uint16(img),output,'WriteMode','append');
            end
        end
    end
    cd(folder)
end

%% Phase
folder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM130/ceph10_iptg4uM_EWPIM_phase300_ETGFP100_2/';
ofolder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM130/ceph10_iptg4uM_EWPIM_phase300_ETGFP100_2/stacks/';
cd(folder)
d = dir([folder '*Pos*']);
for j=1:numel(d)
    cd([folder d(j).name]);
    output = [ofolder d(j).name '_Phase.tif'];
    filelist = dir('*Phase*.tif');
    if numel(filelist) > 0
        if ~exist(output) 
        fprintf('%s',d(j).name)
        for i = 1:numel(filelist)
            img = imread(filelist(i).name);
            imwrite(uint16(img),output,'WriteMode','append');
        end
        end
    end
    cd(folder)
end