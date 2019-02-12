
function [fluor, bkg] = Internal_fluor(xs, ys, im)
% given a contour and corresponding fluorescence image, get the fluor
% value for each pixel inside the contour

fluor = [];
% load('output_25-Nov-2014_25-Nov-2014_cell_interior_R-0.5_rho-500_25-Nov-2014_CONTOURS.mat');
% xs = frame(1).object.Xcont;
% ys = frame(1).object.Ycont;
% im = imread('output_25-Nov-2014_25-Nov-2014_cell_interior_R-0.5_rho-500.tif');

x_min = ceil(min(xs));
x_max = floor(max(xs));
y_min = ceil(min(ys));
y_max = floor(max(ys));
% [y_max, x_max] = size(im);

xv = x_min : x_max;
yv = y_min : y_max;
[XV, YV] = meshgrid(xv, yv);
in_contour = inpolygon(XV, YV, xs, ys);

bkg_fluor = [];

for i = y_min : y_max
    for j = x_min : x_max
        if in_contour(i - y_min + 1, j - x_min + 1)
            fluor = [fluor, im(i, j)];
        else
            bkg_fluor = [bkg_fluor, im(i, j)];
        end
    end
end

bkg = median(bkg_fluor);