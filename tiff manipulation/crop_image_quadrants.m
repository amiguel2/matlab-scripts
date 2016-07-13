function crop_image_quadrants(fname)
    
    % break image into quads
    info = imfinfo(fname);
    first_quad = [0 0 info.Width/2 info.Height/2];
    second_quad = [info.Width/2 0 info.Width info.Height/2];
    third_quad = [0 info.Height/2 info.Width/2 info.Height];
    fourth_quad = [info.Width/2 info.Height/2 info.Width info.Height];
    
    % create cropped images
    I = imread(fname);
    I1 = imcrop(I,first_quad);
    I2 = imcrop(I,second_quad);
    I3 = imcrop(I,third_quad);
    I4 = imcrop(I,fourth_quad);
    
    %save cropped images
    [pathstr,name,ext] = fileparts(fname);
    imwrite(I1,[name '_q1.tif'],'tif');
    imwrite(I2,[name '_q2.tif'],'tif');
    imwrite(I3,[name '_q3.tif'],'tif');
    imwrite(I4,[name '_q4.tif'],'tif');
end
