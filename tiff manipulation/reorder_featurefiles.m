%Reordering feature files

topdir = pwd;
folders = dir;
for f = 3:numel(folders)
    if folders(f).isdir
        fprintf('%s\n',folders(f).name);
        cd ([folders(f).name '/Output/'])
        filelist = dir('*.tif');
        for i = 1:numel(filelist)
            tmp0 = strsplit(filelist(i).name,'/');
            tmp = strsplit(tmp0{end},'_');
            tmp1 = strsplit(tmp{end},'.');
            if numel(tmp1{1}) == 1
                movefile(filelist(i).name,[sprintf('%s_',tmp{1:3}) '00' tmp1{1} '.tif'])
            elseif numel(tmp1{1}) == 2
                movefile(filelist(i).name,[sprintf('%s_',tmp{1:3}) '0' tmp1{1} '.tif'])
            end
        end
        cd(topdir)
    end
end