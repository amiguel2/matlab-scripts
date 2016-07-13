%plotSingleCells_image(image,contour_file) {

    % Amanda's Contour Plotting Program, with Extra Comments

    %fname=image;
    fname='5ugmlA22_after1hour_1_MMStack_1-Pos_000_001_Phase.tif';
    %load(contour_file)
    % Here I am just checking to make sure that "frame" is an existing variable
    if exist('frame') 
        % make a figure
        figure; 
        %xlim([0 2560]);
        %ylim([0 2160]);
        % retain the existing graph when plotting something new (if 'hold' is
        % off then it will make a new figure everytime it plots
        hold on; 
        % for every frame
        for l = 1:1%length(frame) 
            % clear current axes
            cla;
            
            im = imread(fname,l);
            [counts,x] = imhist(im);
            imshow(im,[0 x(find(counts>0,1,'last'))]);
            hold on;
            % for every object in that frame
            for g = 1:length(frame(l).object) 
                % If the contour isn't just an empty matrix
                if frame(l).object(g).on_edge == 0
                    % get the x and y contour positions
                    
                    xPos_max = max(frame(l).object(g).Xcont);
                    xPos_min = min(frame(l).object(g).Xcont);
                    yPos_max = max(frame(l).object(g).Ycont);
                    yPos_min = min(frame(l).object(g).Ycont);
                    xlim([xPos_min xPos_max]);
                    ylim([yPos_min yPos_max]);
                    m = frame(l).object(g).mesh;
                    hold on
                    plot([m(:,3),m(:,1)],[m(:,4),m(:,2)],'red')
                    text(m(1,3),m(1,4),num2str(frame(l).object(g).cellID))
                    fprintf('Cell %s...\n',num2str(frame(l).object(g).cellID));
                    pause;
                end
            end
            % render all the cells in this fram now
            xlim([0 2560])
            ylim([0 2160])
            drawnow
            % pause .1 seconds
            pause;


        end
    end
%}
% done! Let me know if you have any questions about the above code.