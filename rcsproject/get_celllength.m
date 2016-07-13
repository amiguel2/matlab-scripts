function [l,t,w,varargout] = get_cellparam(contour,id,varargin)
% [l,t,w,varargout] = get_celllength(contour,id,varargin)
% gets cell length. no optional parameters grabs whole thing.
% varargin{1} = start
% varargin{2} = end


if isfield(contour,'cells')
    l = [];
    t = [];
    w = [];
    
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
            n = numel(frames);
        end
    else
        n = numel(frames);
        start = 1;
    end
    
    for i = start:n
        if objects(i)
            ob = contour.frame(frames(i)).object(objects(i));
            try
                if ~isempty(ob.cell_length)
                    if test_roc(ob)
                        l = [ l ob.cell_length];
                        t = [ t frames(i)];
                        w = [ w ob.cell_width];
                        if fluor_on
                            flr = [flr ob.ave_fluor];
                        end
                    end
                end
            catch
                if length(ob.width) > 1
                    if test_roc(ob)
                        l = [ l ob.length];
                        t = [ t frames(i)];
                        w = [ w nanmean(ob.width)];
                        if fluor_on
                            flr = [flr ob.ave_fluor];
                        end
                    end
                elseif ~isempty(ob.length)
                    if test_roc(ob)
                        l = [ l ob.length];
                        t = [ t frames(i)];
                        w = [ w ob.width];
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
else
    fprintf('No cells structure. Run make_celltable on contour first\n')
    l = [];
    t = [];
    w = [];
end
end