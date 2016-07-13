%f = load([file_prefix{1} '_CONTOURS.mat']);
%image = [file_prefix{1} '.tif'];
f = f_new_lineage;%load('stack5-Pos_000_000_Phase_CONTOURS.mat');
image = 'stack5-Pos_000_000_Phase.tif';
output = 'stack5-Pos_000_000_contourmovie-lineage.tif';

c0 = [1 0 0]; % red
c1 = [0 0 1]; % blue
%output= [file_prefix{i} 'contourvscelldatamovie.tif'];

% relabel cellid from f.cell, change cellid to bw_label
for i = 1:numel(f.cell)
    for j = 1:numel(f.cell(i).frames)
        fr=f.cell(i).frames(j);
        cid = f.cell(i).bw_label(j);
        f.frame(fr).object(cid).bw_label = f.frame(fr).object(cid).cellID;
        f.frame(fr).object(cid).cellID = i;
    end
end


for i =1:numel(f.frame)
    fig = figure();
    im = imread(image,i);
    [counts,x] = imhist(im);
    imshow(im,[0 x(find(counts>0,1,'last'))]);
    te = text(900,50,sprintf('t=%d',i*2-1),'Color',[1 1 1],'FontSize',20);
    hold on;
    for j = 1:numel(f.frame(i).object)
        ob = f.frame(i).object(j);
        if ob.roc == 1 && f.cell(ob.cellID).lineage == 1
            plot([ob.mesh(:,3),ob.mesh(:,1)],[ob.mesh(:,4),ob.mesh(:,2)],'Color',c0)
            patch(ob.Xcont,ob.Ycont,c0)
        elseif ~isempty(ob.mesh)
            plot([ob.mesh(:,3),ob.mesh(:,1)],[ob.mesh(:,4),ob.mesh(:,2)],'Color',c1)
        end
        
    end
    drawnow;
    hold off;
    F = getframe(fig);
    imwrite(F.cdata,output,'WriteMode','append');
    pause(.1)
    delete(te)
    close(fig)
end