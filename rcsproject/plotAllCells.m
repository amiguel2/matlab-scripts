function plotAllCells(f,varargin)
% Plots contours with or without tif stack.
% plotAllCells(f,[optional])
% Optional Parameters: pause_on,make_movie,image,output, make_tif,
% show_cellid, cellid, frame, color
%
% plotAllCells(f) is the contour file
% plotAllCells(f,'pause_on',1) contour, pausing on each frame
% plotAllCells(f,'make_movie',1) makes a movie
% plotAllCells(f,'image',image_location) overlays contours on tif file
% plotAllCells(f,'output',output_name) makes a contour/img movie and saves at fileoutput
% plotAllCells(f,'show_cellid',1) plots the cellID next to the cell
% plotAllCells(f,'cellid',cellidnum) plots the specific cell with that cell id in red
% plotAllCells(f,'cellid',cellidnum) plots the specific cell with that cell



% default parameters
make_tif = 1;
pause_on = 0;
make_movie = 0;
output = 'allcellmovie.tif';
imagecolor = [0 0 0];

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

% 
% if numel(varargin) == 1 % pause
%     pause_on = varargin{1};
%     make_movie = 0;
% elseif numel(varargin) == 2 % make movie (default output)
%     pause_on = varargin{1};
%     make_movie = varargin{2};
%     
%     % load object if necessary
% elseif numel(varargin) == 3  % make movie with image file (default output)
%     pause_on = varargin{1};
%     make_movie = varargin{2};
%     output = 'allcellmovie.tif';
%     image = varargin{3};
% elseif numel(varargin) == 4 % make movie with image file and specified output
%     pause_on = varargin{1};
%     make_movie = varargin{2};
%     image = varargin{3};
%     output = varargin{4};
% end


if isstruct(f)
    frame = f.frame;
elseif isstr(f)
    load(f)
end

if ~isfield(f,'cells')
    f = make_celltable(f);
end
% make a figure
fig = figure;
%     xlim([0 2560]);
%     ylim([0 2160]);
% xlim([0 windowsize(1)]);
% ylim([0 windowsize(2)]);
% retain the existing graph when plotting something new (if 'hold' is
% off then it will make a new figure everytime it plots
hold on;
% for every frame
if exist('image','var')
    info = imfinfo(image);
    N = numel(info);
    F(1:numel(info)) = struct('cdata',[],'colormap',[]);
else
    N = numel(f.frame);
    F(1:numel(f.frame)) = struct('cdata',[],'colormap',[]);
end
for l = 1:N
    % clear current axes
    cla;
    if exist('image','var')
        im = imread(image,l);
        %im = fliplr(im);
        [counts,x] = imhist(im);
        imshow(im,[0 x(find(counts>0,1,'last'))]);
        hold on;
    end
    
    
    % for every object in that frame
    for g = 1:length(frame(l).object)
        % If the contour isn't just an empty matrix
        if isfield(frame(l).object(g),'Xcont')
            if ~isempty(frame(l).object(g).Xcont)
                % get the x and y contour positions
                xPos = frame(l).object(g).Xcont;
                yPos = frame(l).object(g).Ycont;
                
                % Here I am adding the first position to the end of the
                % vector, so that it wraps around completely.
                
                xPos = [xPos(:); xPos(1)];
                yPos = yPos([1:end 1]);
                
                
                % Now I can plot it
                
                if frame(l).object(g).kappa_raw > -0.2
                    plot(xPos,yPos,imagecolor);
                    hold on;
                else
                    plot(xPos,yPos,'Color',[0.7 0.7 0.7])
                end
                
                if exist('cellid','var')
                    if frame(l).object(g).cellID == cellid
                        plot(xPos,yPos,'red')
                    end
                end
                
                
                if exist('image','var')
                    text(xPos(1),yPos(1),sprintf('%d',frame(l).object(g).cellID),'Color','white');
                else
                    text(xPos(1),yPos(1),sprintf('%d',frame(l).object(g).cellID));
                end
            end
        end
    end
    % render all the cells in this fram now
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
end
% done! Let me know if you have any questions about the above code.