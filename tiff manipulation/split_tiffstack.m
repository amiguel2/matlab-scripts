function split_tiffstack(prefix)

% load each of the files starting with prefix
filelist_prefix = dir(['*',prefix,'*.tif']);
filelist = dir(['*',prefix,'*.tif']);
fprintf('Processing %d files with motif *%s*.tif...\n',numel(filelist),prefix);
for j=1:numel(filelist)
    % read in image
    fname = filelist(j).name;
    out = strsplit(fname,'.ome.tif');
    p_out = [out{1},'_phase.tif'];
    g_out = [out{1},'_GFP.tif'];
    Phase = imread(fname, 1);
    GFP = imread(fname,2);
    imwrite(Phase,p_out,'WriteMode','append');
    imwrite(GFP,g_out,'WriteMode','append');
    
end

