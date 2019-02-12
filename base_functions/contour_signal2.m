function [fluor,aveFl,lengths]=contour_signal2(im,xs,ys,dist_in, dist_out,N)
% contour_signal: takes a fluorescent signal, represented in an image
% im, and a contour, (xs,ys), and does a line scan normal to the contour at
% each contour point. dist is the length of the line to scan, N is the
% number of points on the line scan

centers=.5*[xs+circshift(xs,1), ys+circshift(ys,1)];


%unormalized normals vectors
normals=[circshift(ys,1)-ys,-(circshift(xs,1)-xs)];
%normalize


normals=normals./repmat(sqrt(sum(normals.^2, 2)),[1,2]);

xstart=centers(:,1)-dist_out*normals(:,1);
xend=centers(:,1)+dist_in*normals(:,1);
ystart=centers(:,2)-dist_out*normals(:,2);
yend=centers(:,2)+dist_in*normals(:,2);

% create mesh of points
frac = 0:1./(N-1):1;
XX = repmat(xstart,1,N)+repmat(frac,size(xstart,1),1).*repmat(xend-xstart,1,N);
YY = repmat(ystart,1,N)+repmat(frac,size(ystart,1),1).*repmat(yend-ystart,1,N);

[X,Y] = meshgrid(1:size(im,2),1:size(im,1));

% interpolate
interp_fluo = interp2(X,Y,double(im),XX,YY,'bilinear');
%   plot(xs,ys);
%   hold on
% % % 
%   plot([xstart,xend]',[ystart,yend]','r');
% % % 
%   pause

% prof=@(startx,endx,starty,endy) sum(improfile(im,[startx,endx],[starty,endy],N, 'bilinear'));


%fluor=(1/N)*(dist_in+dist_out)*arrayfun(prof, xstart,xend,ystart,yend);
fluor=(1/N)*(dist_in+dist_out)*sum(interp_fluo,2);

%unshift so that fluor is defined at vertices, not contour centers
fluor=0.5*(fluor+circshift(fluor,-1));

lengths = sqrt((xstart-xend).^2+(ystart-yend).^2);
aveFl = sum(fluor.*lengths)/sum(lengths);
end

