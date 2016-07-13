function fig = plotAllCells_frame(f,fr,varargin)

if numel(varargin) == 1
    fig = varargin{1};
else
fig = figure;
end
if isstruct(f)
    frame = f.frame;
elseif isstr(f)
    load(f)
end

% make a figure

%     xlim([0 2560]);
%     ylim([0 2160]);
% xlim([0 1004]);
% ylim([-1002 0]);
% retain the existing graph when plotting something new (if 'hold' is
% off then it will make a new figure everytime it plots
hold on;
% for every frame
l = fr;
% clear current axes
cla;

% for every object in that frame
for g = 1:length(frame(l).object)
    % If the contour isn't just an empty matrix
    if ~isempty(frame(l).object(g).Xcont)
        % get the x and y contour positions
        xPos = frame(l).object(g).Xcont;
        yPos = -1*frame(l).object(g).Ycont;
        
        % Here I am adding the first position to the end of the
        % vector, so that it wraps around completely.
        
        xPos = [xPos(:); xPos(1)];
        yPos = yPos([1:end 1]);
        
        
        % Now I can plot it
        plot(xPos,yPos,'red');
        text(xPos(1),yPos(1),sprintf('%d',frame(l).object(g).cellID));
        
    end
end
% render all the cells in this fram now
drawnow

end
% done! Let me know if you have any questions about the above code.