function result = check_phase_nearby(contourfile,imagefile,varargin)
    
    % receive both string and struc objects
    if ~isstruct(contourfile)
        contourfile = load(contourfile);
    end
    
    if ~isa(im,'uint8')
        img = imread(imagefile);
    end
    
    if numel(varargin) == 0
        for i = 1:numel(contourfile.frame)
            for j = 1:numel(contoufile.frame(i))
                ob = contourfile.frame(i).object(j);
                 
            end
            
        end
    end
end