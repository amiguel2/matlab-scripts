%plot_image_over_time
%% load file
%clear
%load('LM15-S32_celldata.mat')

% colors
c0 = [1 1 0];
c1 = [0 0 1];

% conditions
condition = cond{3};

% contour file
file_prefix = cellfun(@(x) x(1:end-13),condition.cfile,'UniformOutput',false);

%%
% for every contour file
for i = 1:1%length(file_prefix)
    output= [file_prefix{i} 'contourmovie.tif'];
    % determine the cells that come from that file
    stacks = cellfun(@(x) strcmp(file_prefix{i},x(1:end-13)),condition.cfile,'UniformOutput',false);
    % get those indices
    cell_id = find([stacks{:}] == 1);
    image = [file_prefix{i} '.tif']; % phase image file
    % get max frame from time point
    mt = round(max(cellfun(@(x) max(x),condition.time(cell_id)))/condition.tperframe);
    % for everytime point
    for l = 1:2:mt
    f = figure();
    im = imread(image,l);
    [counts,x] = imhist(im);
    imshow(im,[0 x(find(counts>0,1,'last'))]);
    c = c0+(c1-c0)*(l-1)/(mt-1);
    te = text(900,50,sprintf('t=%d',l*condition.tperframe-1),'Color',c,'FontSize',20);
    hold on;
    for j = cell_id
        timescale = condition.time{j};
        for k = 1:numel(timescale)
            if timescale(k) <= l*condition.tperframe-1
            try
            m = condition.mesh{j}{k};
            c = c0+(c1-c0)*(round(timescale(k)/condition.tperframe)-1)/(mt-1);
            plot([m(:,3),m(:,1)],[m(:,4),m(:,2)],'Color',c)
            hold on;
            catch
                break
            end
            end
        end
    end
    drawnow
    F = getframe(f);
    imwrite(F.cdata,output,'WriteMode','append');
    delete(te)
    hold off;
    close(f)
    end
    pause
end

axis equal