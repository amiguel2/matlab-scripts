% calculate_fluor_profiles:
%
% inputs:
% - contfile: the Morphometrics CONTOURS file that containts the MT
% mesh info
% - fluorfile: the corresponding fluorescence images
% - suff: suffix to add to the CONTOURS file; use '' if you want to
% write to the same file
% - params: parameters that can be used to modify the script (see
% below)
%
% Paramaters:
% - jumpframe: how many frames to skip (1 is default)
function calculate_fluor_profiles_cl(contfile,fluorfile,suff,params)

%q = 0;
%contfile = ['Pos0',int2str(q),'_CONTOURS.mat'];
%fname = ['GFP0',int2str(q),'.tif'];
info = imfinfo(fluorfile);
num_images = numel(info);
    
s = load(contfile);

fprintf('Loading %s...\n',contfile);

if ~isfield(params,'jumpframe')
    jumpframe = 1; % might need to change this to two if there's an
                   % issue with focusing
else
    jumpframe = params.jumpframe;
end

% loop over all frames
for i=1:jumpframe:numel(s.frame)
    k = (i-1)/jumpframe+1;
    im = imread(fluorfile, k, 'Info', info);
    
    for j=1:numel(s.frame(i).object)
        data = s.frame(i).object(j);
        
        if numel(data.area)>0
            fprintf('Processing frame %d, object %d...\n',i,j);
            
            if size(data.mesh,1)>0
                xs = data.Xcont;
                ys = data.Ycont;
                
                dist_in = 5;
                dist_out = 5;
                N = 10;
                
                %fl = contour_signal(im,xs,ys,dist_in,dist_out,N);
                [fl,av,tot,lengths] = contour_signal_interior(im,data,N);
                prof = contour_signal2(im,xs,ys,dist_in,dist_out,N);
                s.frame(i).object(j).fluor_interior = fl;
                s.frame(i).object(j).ave_fluor = av;
                s.frame(i).object(j).fluor_profile = prof;
                s.frame(i).object(j).cell_lengths = lengths;
            else
                s.frame(i).object(j).fluor_interior = [];
                s.frame(i).object(j).ave_fluor = [];
                s.frame(i).object(j).fluor_profile = [];
                s.frame(i).object(j).cell_lengths = [];
            end
        end
    end
end

[pathstr,name,ext] = fileparts(contfile);
contfile = [name,suff,ext];
save(contfile,'-struct','s');

end % end function
