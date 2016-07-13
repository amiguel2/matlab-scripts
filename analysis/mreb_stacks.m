
folders = dir('*Pos*');
output = '
for j=1:numel(folders)
    cd([folders(j).name]);
    output = ['../stacks/',folders(j).name];
    output = [output,'.tif'];
    make_tiffstack('*Phase*',output); % leave third variable blank to make tiff stack of all. 
    cd ..
end
