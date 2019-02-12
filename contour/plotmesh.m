function plotmesh(mesh,varargin)

%varargin{1} = imageloc;
%varargin{2} = frame;
%varargin{3} = bwlabel;

if numel(varargin) >= 1
   image = varargin{1};
end
if numel(varargin) >= 2
   l = varargin{2};
end
if numel(varargin) >= 3
   g = varargin{3};
end
    
buffer = 50;
% plot(mesh(:,[1 3]),mesh(:,[2 4]),'Color','b'); axis equal

im = imread(image,l);
            [counts,x] = imhist(im);
            imshow(im,[0 x(find(counts>0,1,'last'))]);
            hold on;
            % for every object in that frame
%             for g = 1:length(frame(l).object) 
                % If the contour isn't just an empty matrix
%                 if frame(l).object(g).on_edge == 0
                    % get the x and y contour positions
                    
                    xPos_max = max([mesh(:,3);mesh(:,1)]);
                    xPos_min = min([mesh(:,3);mesh(:,1)]);
                    yPos_max = max([mesh(:,4);mesh(:,2)]);
                    yPos_min = min([mesh(:,4);mesh(:,2)]);
                    xlim([xPos_min-buffer xPos_max+buffer]);
                    ylim([yPos_min-buffer yPos_max+buffer]);
                    hold on
                    plot([mesh(:,3),mesh(:,1)],[mesh(:,4),mesh(:,2)],'red')
%                     text(mesh(1,3),mesh(1,4),num2str(frame(l).object(g).cellID))
%                     fprintf('Cell %s...\n',num2str(frame(l).object(g).cellID));
                    pause;
%                 end
%             end



end