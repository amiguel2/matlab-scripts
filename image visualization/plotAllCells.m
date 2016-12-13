function plotAllCells(f,varargin)
% Written by Amanda Miguel
% Created: 2016-11-28
% Last Modified: 2016-11-30
%
% Plots contours with or without tif stack.
% plotAllCells(f,[optional])
% Optional Parameters: pause_on,make_movie,imageloc,output, make_tif,
% show_cellid, cellid, frame
%
% plotAllCells(f) is the contour file
% plotAllCells(f,'pause_on',1) contour, pausing on each frame
% plotAllCells(f,'make_movie',1) makes a movie
% plotAllCells(f,'imageloc',image_location) overlays contours on tif file
% plotAllCells(f,'output',output_name) makes a contour/img movie and saves at fileoutput
% plotAllCells(f,'show_cellid',1) plots the cellID next to the cell
% plotAllCells(f,'cellid',cellidnum) plots the specific cell with that cell id in red
% plotAllCells(f,'frames',frame_range) plots the specific frames
% plotAllCells(f,'kappasmoothfilt1',value) filters cells below this value
% plotAllCells(f,'kappasmoothfilt2',value) filters cells above this value
% plotAllCells(f,'areafilt',value) filters cells above this value

% segmentation parameters
kappasmoothfilt1 = Inf;%0.25;
kappasmoothfilt2 = -Inf;%-0.25;%-0.1;
areafilt = 250;

% default parameters
make_tif = 1;
pause_on = 1;
make_movie = 0;
output = 'allcellmovie.tif';
show_cellid = 0;
color = [0 0 1];
count = 0;
microscope = 'none';

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: get_data(list,tframe,pxl,[optional] fluor lineage tshift microbej onecolor)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

if nargin == 0
    fprintf('plotAllCells(f, [optional params])\n')
    fprintf('F can be a structure or a location with contour file\n')
    fprintf('See help for parameter details\n')
    return
end

if isstr(f)
    load(f)
end

if ~isfield(f,'cells')
    f = make_celltable(f);
end
% make a figure
figure('Color',[1 1 1]);


hold on;
% for every frame
if exist('imageloc','var')
    info = imfinfo(imageloc);
    if exist('frames','var')
        F(1:numel(frames)) = struct('cdata',[],'colormap',[]);
    else
        F(1:numel(info)) = struct('cdata',[],'colormap',[]);
        frames = 1:numel(f.frame);
    end
else
    if exist('frames','var')
        F(1:numel(frames)) = struct('cdata',[],'colormap',[]);
    else
        F(1:numel(f.frame)) = struct('cdata',[],'colormap',[]);
        frames = 1:numel(f.frame);
    end
end

if exist('cellid','var')
    cob = f.cells(cellid).object;
end

for l = frames
    % clear current axes
    if numel(frames) > 1
        cla;
    end
    if exist('imageloc','var')
        im = imread(imageloc,l);
        [counts,x] = imhist(im);
        imshow(im,[0 x(find(counts>0,1,'last'))]);
        hold on;
    end
    
    % for every object in that frame
    for g = 1:length(f.frame(l).object)
        % If the contour isn't just an empty matrix
        if isfield(f.frame(l).object(g),'Xcont')
            if ~isempty(f.frame(l).object(g).Xcont)
                % get the x and y contour positions
                xPos = f.frame(l).object(g).Xcont;
                yPos = f.frame(l).object(g).Ycont;
                
                % Here I am adding the first position to the end of the
                % vector, so that it wraps around completely.
                
                xPos = [xPos(:); xPos(1)];
                yPos = yPos([1:end 1]);
                
                
                % Now I can plot it
                
                if f.frame(l).object(g).kappa_smooth < kappasmoothfilt1 & f.frame(l).object(g).area > areafilt & f.frame(l).object(g).kappa_smooth > kappasmoothfilt2 % & f.frame(l).object(g).area > 500 & f.frame(l).object(g).area < 200%& 
                    count = count + 1;
                    plot(xPos,yPos,'Color',color,'UserData',f.frame(l).object(g).cellID)
                    hold on;
                else
                    plot(xPos,yPos,'Color',[0.5 0.5 0.5],'UserData',f.frame(l).object(g).cellID)
                end
                
                try
                    if f.frame(l).object(g).cellID == cellid
                        plot(xPos,yPos,'red','UserData',f.frame(l).object(g).cellID)
                        %text(xPos(1),yPos(1),sprintf('%d',f.frame(l).object(g).cellID));
                    end
                end
                
                if show_cellid
                    if exist('imageloc','var')
                        text(xPos(1),yPos(1),sprintf('%d',f.frame(l).object(g).cellID),'Color','white');
                    else
                        text(xPos(1),yPos(1),sprintf('%d',f.frame(l).object(g).cellID));
                    end
                end
            end
        end
    end
    % render all the cells in this frame now
    Xl=get(gca,'Xlim');
    Yl=get(gca,'Ylim');
    te = text(0.7,0.05,sprintf('frame: %d',l),'FontSize',15,'Units','normalized');
    axis equal
    drawnow

    % pause .1 seconds
    if pause_on
        pause;
    else
        pause(0.1);
    end
    if make_movie
        F(l) = getframe(fig);
        if make_tif
            imwrite(F(l).cdata,output,'WriteMode','append')
        end
    end
    delete(te)
end

if make_movie && ~make_tif
    try
        movie2avi(F, sprintf('%s',output{:}), 'compression', 'None');
    catch
        movie2avi(F, sprintf('%s',output), 'compression', 'None');
    end
end
fprintf('%d\n',count)
end