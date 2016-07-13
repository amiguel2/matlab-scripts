function plotAllCells_image(image,contour_file) 

    % Amanda's Contour Plotting Program, with Extra Comments

    load(contour_file)

    % Here I am just checking to make sure that "frame" is an existing variable
    if exist('frame') 
        % make a figure
        figure; 
        xlim([0 2560]);
        ylim([0 2160]);
        % retain the existing graph when plotting something new (if 'hold' is
        % off then it will make a new figure everytime it plots
        hold on; 
        % for every frame
        for l = 1:1%length(frame) 
            % clear current axes
            cla;

            im = imread(image,l);
            [counts,x] = imhist(im);
            imshow(im,[0 x(find(counts>0,1,'last'))]);
            hold on;
            % for every object in that frame
            for g = 1:length(frame(l).object) 
                % If the contour isn't just an empty matrix

                    m = frame(l).object(g).MT_mesh;
                    if length(m) > 0
                        plot([m(:,3),m(:,1)],[m(:,4),m(:,2)],'red')
                        hold on
                        text(m(1,3),m(1,4),num2str(frame(l).object(g).cellID),'Color','black')
                    end


            end
            % render all the cells in this fram now
            drawnow

            % pause .1 seconds
            pause(.1);


        end
    end
% done! Let me know if you have any questions about the above code.