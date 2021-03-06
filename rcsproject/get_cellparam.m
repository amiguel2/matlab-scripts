function [l,t,w,a,v,sa,varargout] = get_cellparam(contour,id,varargin)
% [l,t,w,varargout] = get_celllength(contour,id,varargin)
% gets cell length. no optional parameters grabs whole thing.
% varargin{1} = start
% varargin{2} = end

kupper  = Inf;%0.25;
klower =  -Inf;%-0.25;
arealower = 250;

if isfield(contour,'cells')
    l = [];
    t = [];
    w = [];
    a = [];
    v = [];
    sa = [];
    
    if isfield(contour.frame(1).object(1),'ave_fluor')
        fluor_on = 1;
        flr = [];
    else
        fluor_on = 0;
    end
    
    frames = contour.cells(id).frame;
    objects = contour.cells(id).object;
    
    if numel(varargin) > 0 %&& varargin{1} < numel(frames)
        start = varargin{1};
        
        if numel(varargin) > 1 %&& varargin{2} < numel(frames)
            n = varargin{2};
        else
            n = frames(end);
        end
    else
        n = frames(end);
        start = frames(1);
    end
    
    for i = start:n
        idx = find(frames == i);
        if numel(idx) == 1 && objects(idx)
            ob = contour.frame(frames(idx)).object(objects(idx));
            try
                if ~isempty(ob.cell_length)
                    if ob.kappa_smooth < kupper & ob.area > arealower & ob.kappa_smooth > klower
                        l = [ l ob.cell_length];
                        t = [ t frames(idx)];
                        w = [ w ob.cell_width];
                        a = [ a ob.area];
                        mesh = ob.mesh;
                        v = [ v volume_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)])];
                        sa = [ sa sarea_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)])];
                        if fluor_on
                            flr = [flr ob.ave_fluor];
                        end
                    end
                end
            catch
                if length(ob.width) > 1
                    if ob.kappa_raw > curvature 
                        l = [ l ob.length];
                        t = [ t frames(idx)];
                        w = [ w nanmean(ob.width)];
                        a = [ a ob.area];
                        mesh = ob.mesh;
                        v = [ v volume_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)])];
                        sa = [ sa sarea_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)])];
                        if fluor_on
                            flr = [flr ob.ave_fluor];
                        end
                    end
                elseif ~isempty(ob.length)
                    if  ob.kappa_raw > curvature
                        l = [ l ob.length];
                        t = [ t frames(idx)];
                        w = [ w ob.width];
                        a = [ a ob.area];
                        mesh = ob.mesh;
                        v = [ v volume_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)])];
                        sa = [ sa sarea_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)])];
                        if fluor_on
                            flr = [flr ob.ave_fluor];
                        end
                    end
                end
            end
        end
    end
    if fluor_on
        flr = flr(~isnan(l));
        varargout{1} = flr;
    end
    
    %remove nan entries
    t = t(~isnan(l));
    w = w(~isnan(l));
    l = l(~isnan(l));
    a = a(~isnan(l));
    v = v(~isnan(l));
    sa = sa(~isnan(l));
else
    fprintf('No cells structure. Run make_celltable on contour first\n')
    l = [];
    t = [];
    w = [];
    a = [];
    v = [];
    sa = [];
end
end


