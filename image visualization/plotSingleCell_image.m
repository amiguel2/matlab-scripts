function plotSingleCell_image(image,contour_file,cID) 

    c = load(contour_file);
        f = c.cells(cID).frame;
        %f = f(1);
        cellid = [];
        for i = 1:length(f)
        cids = extractfield(c.frame(f(i)).object, 'cellID');
        idx = find(cids == cID);
        cellid = [ cellid idx];
        end
    %end
    
    % determine dimensions    
    xPos_max = max(c.frame(f(end)).object(cellid(end)).Xcont);
    xPos_min = min(c.frame(f(end)).object(cellid(end)).Xcont);
    xd = xPos_max - xPos_min;
    yPos_max = max(c.frame(f(end)).object(cellid(end)).Ycont);
    yPos_min = min(c.frame(f(end)).object(cellid(end)).Ycont);
    yd = yPos_max - yPos_min;
    if isfield(c.frame(f(end)).object(cellid(end)),'mesh')
        m = c.frame(f(end)).object(cellid(end)).mesh;
    else
        m = c.frame(f(end)).object(cellid(end)).MT_mesh;
    end
        text(m(1,3),m(1,4),num2str(c.frame(f(end)).object(cellid(end)).cellID),'Color',[0 0 0])
        fprintf('Cell %s...\n',num2str(c.frame(f(end)).object(cellid(end)).cellID));


    % for every frame
    for l = 1:numel(f)
        im = imread(image,f(l));
        [counts,x] = imhist(im);
        imshow(im,[0 x(find(counts>0,1,'last'))]);
        xlim([xPos_min-xd xPos_max+xd]);
        ylim([yPos_min-yd yPos_max+yd]);
        hold on;
        if isfield(c.frame(f(l)).object(cellid(l)),'mesh');
            m = c.frame(f(l)).object(cellid(l)).mesh;
        else
            m = c.frame(f(l)).object(cellid(l)).MT_mesh;
        end
        hold on
        plot([m(:,3),m(:,1)],[m(:,4),m(:,2)],'red')
        %pause(.00000001);
        pause

    end

end
