function makeStacks(dname,prefix,suffix)
%dname = '/Volumes/homes/amiguel/Imaging/AM_IM76_2016-06-01/0.6mecillinamrpra_phase30_egfp_150_1/';
if ~exist('dname','var')
    dname = '/Users/amiguel/Desktop/2017-06-13/RcsF_EWPIM_7p5uMIPTG_10ceph_phase300_ETGFP_200_2/';
    
    suffix = 'Phase';
end

if ~strcmp(dname(end),'/')
    dname = [dname '/'];
end

d = dir([dname '*' prefix '*']);

for j=1:numel(d)
    if d(j).isdir
    fprintf('%s ',d(j).name)
    cd([dname d(j).name]);
    output = [dname ,d(j).name,'_', suffix, '.tif'];
%     third variable changes n, fourth variable changes step, fifth
%     variable changes start
    make_tiffstack(suffix,output);
    cd(dname)
    %pause
    end
end
end
