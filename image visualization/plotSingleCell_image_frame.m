function plotSingleCell_image_frame(image,contour_file,cID,fr,varargin)
%varargin color, default = black

if ~isstruct(contour_file)
    c = load(contour_file);
else
    c = contour_file;
end

if numel(varargin) == 1
   Color = varargin{1};
else
    Color = [0 0 0];
end

% a cell array where index references cell id and c{i} is a vector
% of the frames

%extracts all cell ids in frame(i).objects
cids = extractfield(c.frame(fr).object, 'cellID');

%finds the index that matches the same cell ID
idx = find(cids == cID);

%outputs the indexes
cellid = idx;

xPos_max = max(c.frame(fr).object(cellid).Xcont);
xPos_min = min(c.frame(fr).object(cellid).Xcont);
xd = xPos_max - xPos_min;
yPos_max = max(c.frame(fr).object(cellid).Ycont);
yPos_min = min(c.frame(fr).object(cellid).Ycont);
yd = yPos_max - yPos_min;
if isfield(c.frame(fr).object(cellid),'mesh')
    m = c.frame(fr).object(cellid).mesh;
else
    m = c.frame(fr).object(cellid).MT_mesh;
end

%fprintf('Cell %s...\n',num2str(c.frame(fr).object(cellid).cellID));


% for every frame
im = imread(image,fr);
[counts,x] = imhist(im);
imshow(im,[0 x(find(counts>0,1,'last'))]);
xlim([xPos_min-xd xPos_max+xd]);
ylim([yPos_min-yd yPos_max+yd]);
hold on;
if isfield(c.frame(fr).object(cellid),'mesh');
    m = c.frame(fr).object(cellid).mesh;
else
    m = c.frame(fr).object(cellid).MT_mesh;
end

% plot the contour using X.cont/Ycont
%plot(c.frame(fr).object(cellid).Xcont,c.frame(fr).object(cellid).Ycont)

% plot the cell id
%text(m(1,3),m(1,4),num2str(c.frame(fr).object(cellid).cellID),'Color',[0 0 0])

% plot the contour using mesh
plot(m(:,[1,3]),m(:,[2,4]),'Color',Color)
hold on;

end
