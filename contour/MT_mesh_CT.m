%Tristan Ursell
%March 2012
%
%This function takes a set points defined by X and Y, that are presumed to
%form a closed contour and returns a uniquely-determined mesh and branching
%neutral axis diagram, appended to the input data structure:
%
% frame.object
%
%In particular, this script will add to this structure two sub-fields:
% 
% frame.object.mesh
% frame.object.branch
%
%The 'mesh' sub-field has the sub-fields:
%
% X_pts = the x points of the current mesh polygon
% Y_pts = the y points of the current mesh polygon
% area = the area of the current mesh polygon
% perim = the perimeter length of the current mesh polygon
% centX = the x coordinate of the current mesh polygon centroid
% centY = the y coordinate of the current mesh polygon centroid
% neighbors = indices of the neighboring mesh polygons
%
%The 'branch' sub-field has the sub-fields:
%
% Xpos = the x coordinates of the current neutral axis
% Ypos = the y coordinates of the current neutral axis
% degree = the degree of connection of each points in the current neutral
% axis. A degree = 1 indicates a branch end-point that does not connect to
% another branch. A degree = 3 or higher indicates a branch end-point that
% meets that number of other branch end-points. A degree = 2 indicates the
% points is located within a branch.
% neighbors_left = the indices of all other branches that connect at one of
% the current branch.
% neighbors_right = the indices of all other branches that connect at the
% other end of the current branch.
%


function MT_mesh_CT(path1,file1)

%[file1,path1]=uigetfile({'*.mat','mat-data file'},'Select Contour Data File');
if file1==0
    return
end


% set(handles.text_process,'String','loading file ...')
% drawnow()
load(fullfile(path1,file1));
% set(handles.text_process,'String','processing ...')
% drawnow()

if ~exist('frame','var')
    disp('This mat file does not contain the "frame" structure required for meshing.')
    return
end

try
    exist(frame(1).object(1).width);
    %isempty(frame(1).object(1).MT_width)
    disp('Already Meshed')
    return
catch err
    fprintf('Not yet Meshed: commencing meshing\n')
end


%get current contour
for k=1:length(frame)
    for c=1:length(frame(k).object)
        %if ~frame(k).object(c).on_edge
            clearvars -except frame fname v_* f_* cell path1 file1 k c h0 handles
            
            %only calculate mesh if the cell is not on_edge
            %if ~frame(k).object(c).on_edge
                %get contour points
                X=frame(k).object(c).Xcont;
                Y=frame(k).object(c).Ycont;
                coord = [X,Y];
                %find meshes and branches
%                 [frame(k).object(c).mesh,frame(k).object(c).branch]=contour2mesh(X,Y);
                frame(k).object(c).MT_mesh = model2mesh(coord,.5,0.1,20);
                if frame(k).object(c).MT_mesh
                    [steplength,frame(k).object(c).MT_length] = findlength(frame(k).object(c).MT_mesh);
                    [frame(k).object(c).MT_width frame(k).object(c).MT_sides]= ...
                        findwidthnopoles(frame(k).object(c).MT_mesh,...
                        steplength,0.3);
                else
                    frame(k).object(c).MT_mesh=NaN;
                    frame(k).object(c).MT_width=NaN;
                    frame(k).object(c).MT_length=NaN;
                    frame(k).object(c).MT_sides=NaN;
                end
                

            %end
%             set(handles.text_process,'String',['meshing: frame ' num2str(k) ', cell ' num2str(frame(k).object(c).cellID)])
%             drawnow()
%             disp(['meshing: frame ' num2str(k) ', cell ' num2str(frame(k).object(c).cellID)])
        %end
    end
end


disp(['Mesh and branch data added to:  ' file1])
clearvars -except frame cell path1 file1 v_* f_* cells Ncell outname
save(fullfile(path1,file1))


function [meanwidth incl_pts] = findwidthnopoles(mesh,steplength,thresh)

% mesh = cellList.mesh;
    
w = sqrt((mesh(:,4)-mesh(:,2)).^2+(mesh(:,3)-mesh(:,1)).^2);

nnAngle = findangletanmidline(steplength,w);

ind = find(abs(nnAngle)<thresh);

% fill in the middle, ignore septation for now
incl_pts=min(ind):max(ind);
w_rod = w(incl_pts);
% w_rod = w(abs(nnAngle)<thresh);

meanwidth = mean(w_rod);


function nnAngle = findangletanmidline(steplength,w)

% x direction corresponds to the coordinate system defined by the midline
% y direction is the width associated with a midline point

y = w./2;

d_y = diff(y); d_x = steplength;

x = cumsum([0; d_x]);

theta = atan2(d_y,d_x);

nnAngle = [pi; theta(1:end-1)+theta(2:end); -pi];

function [steplength,celllength] = findlength(mesh)

steplength = edist(mesh(2:end,1)+mesh(2:end,3),mesh(2:end,2)+mesh(2:end,4),...
    mesh(1:end-1,1)+mesh(1:end-1,3),mesh(1:end-1,2)+mesh(1:end-1,4))/2;
celllength = sum(steplength);

function d=edist(x1,y1,x2,y2)
    % complementary for "getextradata", computes the length between 2 points
    d=sqrt((x2-x1).^2+(y2-y1).^2);
