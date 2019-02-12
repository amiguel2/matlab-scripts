

tp = '018';

folders = dir('8-Pos*');
ofolder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM156_ftsz_quant/stacks/';
output = [ofolder 'Peri_tp' tp 'fluor.tif'];
for j=1:numel(folders)
    cd([folders(j).name]);
    make_tiffstack('fluor',output); % leave third variable blank to make tiff stack of all. 
    cd ../
end



%%
tp = '018';

folders = dir('5-Pos*');
ofolder = '/scratch/users/amiguel2/Working_Folder/Rcs_system/AM_IM156_ftsz_quant/stacks/';
output = [ofolder 'EM_tp' tp 'feature_0.tif'];
for j=1:numel(folders)
    cd([folders(j).name '/Output']);
    make_tiffstack('feature_0',output); % leave third variable blank to make tiff stack of all. 
    cd ../..
end

folders = dir('6-Pos*');
output = [ofolder 'WT_tp' tp 'feature_0.tif'];
for j=1:numel(folders)
    cd([folders(j).name '/Output']);
    make_tiffstack('feature_0',output); % leave third variable blank to make tiff stack of all. 
    cd ../..
end
folders = dir('7-Pos*');
output = [ofolder 'IM_tp' tp 'feature_0.tif'];
for j=1:numel(folders)
    cd([folders(j).name '/Output']);
    make_tiffstack('feature_0',output); % leave third variable blank to make tiff stack of all. 
    cd ../..
end
folders = dir('8-Pos*');
output = [ofolder 'Peri_tp' tp 'feature_0.tif'];
for j=1:numel(folders)
    cd([folders(j).name '/Output']);
    make_tiffstack('feature_0',output); % leave third variable blank to make tiff stack of all. 
    cd ../..
end