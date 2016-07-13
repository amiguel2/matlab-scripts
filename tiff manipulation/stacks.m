
dname = '/Volumes/homes/amiguel/Imaging/AM_IM76_2016-06-01/0.6mecillinamrpra_phase30_egfp_150_1/';
d = dir([dname '*Pos*']);

output = ['~/Desktop/AllPos-EGFP.tif'];
for j=1:numel(d)
    fprintf('%s',d(j).name)
    cd([dname d(j).name]);
    %output = ['../../stacks/',d(j).name,'_int.tif'];
    % third variable changes n, fourth variable changes step, fifth
    % variable changes start
    make_tiffstack('*EGFP*',output);
    cd(dname)
    %pause
end
