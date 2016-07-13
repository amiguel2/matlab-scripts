function fig = single_cell_traj(contour_file,cid,varargin)
% f is loaded structure
% cid is cell to make movie of
% varargin{1} = image
% varargin{2} = movie output
% varargin{3} = roc_on = consider roc when plotting (default off)
if ~isstruct(contour_file)
    f = load(contour_file);
else
    f = contour_file;
end
fr = f.cell(cid).frames;
bw = f.cell(cid).bw_label;
l = [];
t = [];
c0 = [0 0 1];
c1 = [1 0 0];
pxl = 0.08;
roc_on = 0;
nc = numel(fr);
if numel(varargin) == 1
    image = varargin{1};
    output = 'movie.tif';
    movie_on = 0;
    plots = 2;
elseif numel(varargin) ==  2
    image = varargin{1};
    output = varargin{2};
    plots = 2;
elseif numel(varargin) ==  3
image = varargin{1};
output = varargin{2};
roc_on = varargin{3};
plots = 2;
else
    plots = 2;
    movie_on = 0;
end

fig = figure;
for i = 1:numel(fr)
    subplot(1,plots,1)
    title(sprintf('frame = %d',fr(i)))
    if ~isempty(f.frame(fr(i)).object(bw(i)).cell_length)
        if nc > 1
            c = c0+(c1-c0)*(i-1)/(nc-1);
        else
            c = [0 0 0];
        end
        if roc_on && f.frame(fr(i)).object(bw(i)).roc == 1
            plot(f.frame(fr(i)).object(bw(i)).Xcont,f.frame(fr(i)).object(bw(i)).Ycont,'Color',c)
        elseif roc_on && f.frame(fr(i)).object(bw(i)).roc == 0
            plot(f.frame(fr(i)).object(bw(i)).Xcont,f.frame(fr(i)).object(bw(i)).Ycont,'Color',[0 0 0])
        else
            plot(f.frame(fr(i)).object(bw(i)).Xcont,f.frame(fr(i)).object(bw(i)).Ycont,'Color',c)
        end
        axis equal
        hold on;
        if ~isempty(f.frame(fr(i)).object(bw(i)).cell_length*pxl)
            if roc_on == 1
                if f.frame(fr(i)).object(bw(i)).roc == 1
                    l = [l f.frame(fr(i)).object(bw(i)).cell_length*pxl];
                    t = [t fr(i)];
                end
            else
                l = [l f.frame(fr(i)).object(bw(i)).cell_length*pxl];
                t = [t fr(i)];
            end
        end
        if exist('image','var')
            subplot(1,plots,2)
            if roc_on == 1
                if f.frame(fr(i)).object(bw(i)).roc == 1
                    plotSingleCell_image_frame(image,contour_file,bw(i),fr(i),c);
                else
                    plotSingleCell_image_frame(image,contour_file,bw(i),fr(i),[0 0 0]);
                end
            else
                plotSingleCell_image_frame(image,contour_file,bw(i),fr(i),c);
            end
            drawnow
            if exist('output','var')
                F = getframe(fig);
                imwrite(F.cdata,output,'WriteMode','append');
            end
%             delete(te);
        end
    end
end
hold off;


subplot(1,plots,2)
hold off;
plot(t,l)
xlabel('Frame')
ylabel('Pixels')

hold off;
if exist('image','var')
    if exist('output','var')
        F = getframe(fig);
        imwrite(F.cdata,output,'WriteMode','append');
    end
end
fprintf('cid: %d, start_frame: %d, num_frames: %d\n',cid,fr(1),nc)
end