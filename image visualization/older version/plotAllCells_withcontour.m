% Alex's initial code, Rico's code for .avi: plots contour on top of movie 
% image, then saves as an .AVI file
% - Amanda Miguel 12-19-12
function [] = plotAllCells_withcontour(frame,filepattern)
% checking to make sure that "frame" is an existing variable
if exist('frame') 
    figure; 

    for l = 1:length(frame) 
        % clear current axes
        cla;
        
        if l < 11
        imagefile= strcat(filepattern,'0',int2str(l-1),'__000.tif');
        elseif l > 10 && l < 101
        imagefile= strcat(filepattern,int2str(l-1),'__000.tif');
        else 
           imagefile= strcat(filepattern,int2str(l-1),'__000.tif');
        end
        im = imread(imagefile);
        im = imadjust(im);
        image = imshow(im);
        hold on;
    
        
        % for every object in that frame
        for g = 1:length(frame(l).object) 
            % If the contour isn't just an empty matrix
            if ~isempty(frame(l).object(g).MT_mesh)
                m = frame(l).object(g).MT_mesh;
                plot([m(:,3),m(:,1)],[m(:,4),m(:,2)],'red')
                hold on
                for i = 1:10:length(m(:,4))
                    plot([m(i,3),m(i,1)],[m(i,4),m(i,2)],'red')
                end
                
            end
        end
        % render all the cells in this fram now
        drawnow
        
        % pause .1 seconds
        pause(.1);
        
        newimagefile = strcat(filepattern,'_contour_',int2str(l-1),'.tif');
        export_fig(newimagefile,'-tif','-a1')
        
    end
end