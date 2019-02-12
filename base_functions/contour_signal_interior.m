function [fluor,aveFl,totalFl,lengths]=contour_signal_interior(im,data,N) %im,xs,ys,dist_in, dist_out,N)

% data is a morphometrics cell data object

% contour_signal: takes a fluorescent signal, represented in an image
% im, and a contour, (xs,ys), and does a line scan normal to the contour at
% each contour point. dist is the length of the line to scan, N is the
% number of points on the line scan

% loop over each MT_mesh line

if isfield(data,'mesh')
    xstart = data.mesh(2:end-1,1);
    xend = data.mesh(2:end-1,3);
    ystart = data.mesh(2:end-1,2);
    yend = data.mesh(2:end-1,4);
elseif isfield(data,'MT_mesh')
    xstart = data.MT_mesh(2:end-1,1);
    xend = data.MT_mesh(2:end-1,3);
    ystart = data.MT_mesh(2:end-1,2);
    yend = data.MT_mesh(2:end-1,4);
else
    display('No mesh data')
end
xs = data.Xcont;
ys = data.Ycont;

% $$$ plot(xs,ys);
% $$$ hold on
% $$$ plot([xstart,xend]',[ystart,yend]','r');
% $$$ pause

% define profile
prof=@(startx,endx,starty,endy) sum(improfile(im,[startx,endx],[starty,endy],N, 'bilinear'));

%areas=@(startx,endx,starty,endy) 
%midx = mean(data.mesh(2:end,[1 3]),2);
%midy = mean(data.mesh(2:end,[2 4]),2);

lengths = sqrt((xstart-xend).^2+(ystart-yend).^2);
% calculate the average fluorescence using the 1/N
% then average

% create mesh of points
frac = 0:1./(N-1):1;
XX = repmat(xstart,1,N)+repmat(frac,size(xstart,1),1).*repmat(xend-xstart,1,N);
YY = repmat(ystart,1,N)+repmat(frac,size(ystart,1),1).*repmat(yend-ystart,1,N);

[X,Y] = meshgrid(1:size(im,2),1:size(im,1));

% interpolate
interp_fluo = interp2(X,Y,double(im),XX,YY,'bilinear');

%tic
fluor=(1/N)*sum(interp_fluo,2);
%toc

%tic
%fluor=(1/N)*lengths.*arrayfun(prof, xstart,xend,ystart,yend);
%toc

% calculate the total fluorescence
%totalFl = sum(fluor.*lengths)/sum(lengths) * data.area;
totalFl = sum(fluor.*lengths)/sum(lengths) * data.area;
aveFl = sum(fluor.*lengths)/sum(lengths);