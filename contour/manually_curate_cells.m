function manually_curate_cells(contourname,imageloc)
directory = [pwd '/'];

is_polaris = 1;

if isstruct(contourname)
    if isfield(contourname,'name') & isfield(imageloc,'name')
        for j = 1:numel(contourname)
            manually_curate_cells(contourname(j).name,imageloc(j).name)
        end
        return
    else
        if isfield(contourname,'frame')
            f = contourname;
        end
    end
else
    f = load(contourname);
end

kappasmoothfilt1 = 0.35; % -Inf means no positive curvature filtering. Typical value: 0.35;
kappasmoothfilt2 = -0.25; % +Inf means no negative curvature filtering. Typical value: -0.25;
areafilt = 1000; % 0 means no min area filtering. Typical value: 50-250

temp = strsplit(f.outname,'/');
newname = strsplit(temp{end},'.mat');
newname = [newname{1} '_ManuallyCurated.mat'];
newf = f;
Ncell = 0;
for i = 1:numel(f.frame)
    im = imread(imageloc,i);
    [counts,x] = imhist(im);
    imshow(im,[0 x(find(counts>0,1,'last'))]);
    hold on;
    te = text(0.7,0.05,sprintf('frame: %d',i),'FontSize',15,'Units','normalized');
    for g = 1:length(f.frame(i).object)
        newf.frame(i).object = struct([]);
        if isfield(f.frame(i).object(g),'Xcont') & ~isempty(f.frame(i).object(g).Xcont)
            
            % get the x and y contour positions
            xPos = f.frame(i).object(g).Xcont;
            yPos = f.frame(i).object(g).Ycont;
            xPos = [xPos(:); xPos(1)];
            yPos = yPos([1:end 1]);
            if is_polaris & (f.frame(i).object(g).Xcent > 120 & f.frame(i).object(g).Xcent < 2450)
                
                if f.frame(i).object(g).kappa_smooth < kappasmoothfilt1 & f.frame(i).object(g).area > areafilt & f.frame(i).object(g).kappa_smooth > kappasmoothfilt2
                    plot(xPos,yPos,'Color','blue','UserData',f.frame(i).object(g).cellID)
                    newf.frame(i).object = [newf.frame(i).object f.frame(i).object(g)];
                    Ncell = Ncell + 1;
                else
                    plot(xPos,yPos,'Color','red','UserData',f.frame(i).object(g).cellID)
                    x = 0;%input('Keep Cell?');
                    if x == 1
                        plot(xPos,yPos,'Color','blue','UserData',f.frame(i).object(g).cellID)
                        newf.frame(i).object = [newf.frame(i).object f.frame(i).object(g)];
                        Ncell = Ncell + 1;
                    else
                        plot(xPos,yPos,'Color',[0.5 0.5 0.5],'UserData',f.frame(i).object(g).cellID)
                    end
                end
            else
                plot(xPos,yPos,'Color',[0.5 0.5 0.5],'UserData',f.frame(i).object(g).cellID)
            end
        end
    end
    fprintf('Frame %d final\n',i)
    pause(0.1);
    delete(te)
end
fprintf('%s: Manual Filter Pass: %d %2.f%%\n',newname,Ncell,Ncell/f.Ncell*100)
newf.Ncell = Ncell;
save([directory newname],'-struct','newf');
end