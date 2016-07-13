function crop_stacks()
% same functionality as stacks.m except it crops the image into four and
% then performs the 

currentFolder = pwd;
filelist = dir('*Pos*');

for i = 1:numel(filelist)
    cd([filelist(i).name])
    imagelist = dir('*.tif*');
    for a = 1:numel(imagelist)
        [name, ext] = fileparts(imagelist(a).name);
        crop_image_quadrants(imagelist(a).name)
        q = ['q1' 'q2' 'q3' 'q4'];
        for b = 1:numel(q)
            output = [name, '_', q(b)];
            phase_output = [currentFolder,'/stacks/',output,'_Phase.tif'];
            make_tiffstack(['*Phase*',q(b),'*.tif'],phase_output);
            fluor_output = [currentFolder,'/stacks/',output,'_GFP.tif'];
            make_tiffstack(['*_GFP_*',q(b),'*.tif'],fluor_output);
        end
    end
    cd ..
end

end
