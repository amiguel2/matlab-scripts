function split_microcolonies(image,image_type,varargin)
% splits images into microcolonies, using the last image to determine microcolony size. 
%Cells on edges are ignored.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('image','var') && ~exist('image_type','var') 
    fprintf('Usage: split_microcolonies(''image'',''image_type'',''outputfolder'' (optional), where\n image = image.tif\n image_type = ''fluor_in'' or ''phase''\n');
    return
end

if numel(varargin) == 0
    outputfolder = '';
elseif numel(varargin) == 1
    outputfolder=varargin{1};
else
    fprintf('Too many optional parameters.\n')
    fprintf('Usage: split_microcolonies(''image'',''image_type'',''outputfolder'' (optional), where\n image = image.tif\n image_type = ''fluor_in'' or ''phase''\n');
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get image infor
info = imfinfo(image);
num_images = numel(info);

% get last frame
im = imread(image,num_images);
med = median(median(im));
st = std2(im);

%%%%%%%%%%%%%%%%
%FILTER METHOD - MODIFY PARAMETERS TO FIT DATA IF NECESSARY
% currently doing course grained segmenting based on simple threshold, 
% default: med+0.5*std
%%%%%%%%%%%%%%%
if strcmp(image_type,'fluor_in') % interior_fluorescence
    filt_im = im > med + .5*st;
    fillim = imfill(filt_im, 'holes');
elseif strcmp(image_type,'phase') % phase 
    filt_im = im < med + .5*st;
    fillim = imfill(filt_im, 'holes');
else
    fprintf('Please specify image_type as ''phase'' or ''fluor_in''\n')
    return
end

%remove objects on border of image
nobord = imclearborder(fillim, 4);

%smoothen the objects
seD = strel('diamond',1);
finalim = imerode(nobord,seD);
finalim = imerode(finalim,seD);

%label the objects
labelim = bwlabel(finalim);

% retrieve properties of objects
cellMeasurements = regionprops(labelim, im, 'all'); % ref image
numberOfcells = size(cellMeasurements, 1);

% for each object
count = 1;
for i = 1:numberOfcells
    
    % filter objects based on area to remove noise
    if cellMeasurements(i).Area > 1000
        % output string
        output = strsplit(image,'.');
        output = strcat(output(1),sprintf('_mc%d.tif',count));
        count = count + 1;
        % get bounding box dimensions
        box = cellMeasurements(i).BoundingBox;
        
        % extend dimensions edges by number of pixels. This
        % will depend on camera pixel/micron ratio. MODIFY IF NECESSARY
        extension = 5;
        
        % get bounds
        yrange = round(box(1))-extension:round((box(1)+box(3)))+extension;
        xrange = round(box(2))-extension:round((box(2)+box(4)))+extension;
        
        % for each image
        for j = 1:num_images
            
            % get corresponding subset of matrix
            im = imread(image,j);
            new_im = im(xrange,yrange);
            
            % save to output file
            imwrite(new_im,[outputfolder,output{:}],'WriteMode','append');
        end
    end
end
end


