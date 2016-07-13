function plotAllCells(f,varargin)
% Plots contours with or without tif stack.
% plotAllCells(f,pause_on [optional],make_movie [optional],imagefile [optional],outputfile [optional])
% plotAllCells(f) is the contour file
% plotAllCells(f,1) contour, pausing on each frame
% plotAllCells(f,0,1) makes a movie
% plotAllCells(f,0,0,imgloc) overlays contours on tif file
% plotAllCells(f,0,1,imgloc,fileoutput) makes a contour/img movie and saves at fileoutput

filter_lineage = 0;

if nargin == 0
    fprintf('plotAllCells(f,pause_on [optional],make_movie [optional],imagefile [optional],outputfile [optional]\n')
    fprintf('F can be a structure or a location with contour file\n')
    return
end

%tif or avi?
make_tif = 0;

pause_on = 0;
make_movie = 0;

if numel(varargin) == 1 % pause
    pause_on = varargin{1};
    make_movie = 0;
elseif numel(varargin) == 2 % make movie (default output)
    pause_on = varargin{1};
    make_movie = varargin{2};
    output = 'allcellmovie.tif';
    % load object if necessary
elseif numel(varargin) == 3  % make movie with image file (default output)
    pause_on = varargin{1};
    make_movie = varargin{2};
    output = 'allcellmovie.tif';
    image = varargin{3};
elseif numel(varargin) == 4 % make movie with image file and specified output
    pause_on = varargin{1};
    make_movie = varargin{2};
    image = varargin{3};
    output = varargin{4};
end
if isstruct(f)
    frame = f.frame;
elseif isstr(f)
    load(f)
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
                    plot(xPos,yPos,'black');
                    hold on;
                else
                    plot(xPos,yPos,'Color',[0.7 0.7 0.7])
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