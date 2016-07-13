%% find positions in space using the non-ome data sets
basedir = '/Volumes/Amanda Port/Imaging/FtsZ rcsF /13-10-15_BW25113_FtsZ_3plasmid_1/';
metafiles = FindAllTiffsSubDir(basedir,'*','*metadata.txt');

x = []
y = []

for i =1:length(metafiles)
    M = readtable(metafiles{i});
    s = M{463,1};
    s = s{:};
    s = strsplit(s,' ');
    
    x = [x str2num(s{2})];
    s = M{671,1};
    s = s{:};
    s = strsplit(s,' ');
    y = [y str2num(s{2})];
    scatter(x(i),y(i),100)
    
    label = strsplit(metafiles{i},'/');
    label = label{end-1};
    text(x(i),y(i),label)
    hold on;
end


% Xposition 463
% Yposition 671


