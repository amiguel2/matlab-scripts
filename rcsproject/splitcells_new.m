function [l,t,w,a,varargout]= splitcells_new(f,cid)
%this script takes a cell as defined by morphometrics and sees if there has
%been a reassignment of the id to a mother and daughter cell. If so,
%returns back separate length trajectories in a cell, if not, returns the length/time
%trajectory defined
if ~isstruct(f)
    f = load(f);
end

if isfield(f.frame(1).object(1),'ave_fluor')
    fluor_on = 1;
    flr = {};
else
    fluor_on = 0;
end

l = {};
t = {};
w = {};
a = {};


if fluor_on
    [l_traj,t_traj,w_traj,a_traj,flr_traj] = get_cellparam(f,cid);
else
    [l_traj,t_traj,w_traj,a_traj] = get_cellparam(f,cid); % get length/time
end
if numel(l_traj) > 3
    dl = diff(l_traj);
    locs = find(abs(dl) > 0.2*l_traj(1:end-1));
    pks = l_traj(locs);
    
    if isempty(pks) % if there are no peaks or troughs
        l = l_traj;
        t = t_traj;
        w = w_traj;
        a = a_traj;
        if fluor_on
            flr = flr_traj;
        end
    elseif numel(pks) == 1 %if there is a single jump
        if fluor_on
            if locs-1 > 3
                [l{1},t{1},w{1},a{1},flr{1}] = get_cellparam(f,cid,t_traj(1),t_traj(locs));
            else
                l{1} = [];
                t{1} = [];
                w{1} = [];
                a{1} = [];
                flr{1} = [];
            end
            if locs >1
                [l{2},t{2},w{2},a{2},flr{2}] = get_cellparam(f,cid,t_traj(locs)+1);
            else
                [l{2},t{2},w{2},a{2},flr{2}] = get_cellparam(f,cid);
            end
            
        else
            if  locs-1 > 3
                [l{1},t{1},w{1},a{1}] = get_cellparam(f,cid,t_traj(1),t_traj(locs));
            else
                l{1} = [];
                t{1} = [];
                w{1} = [];
                a{1} = [];
            end
            if locs >1
                [l{2},t{2},w{2},a{2}] = get_cellparam(f,cid,t_traj(locs+1));
            else
                [l{2},t{2},w{2},a{2}] = get_cellparam(f,cid);
            end
        end
    elseif numel(pks) == 2  % 3 cells
        if fluor_on
            [l{1},t{1},w{1},a{1},flr{1}] = get_cellparam(f,cid,t_traj(1),t_traj(locs(1)));
            if locs(1)+1 > 1
                [l{2},t{2},w{2},a{2},flr{2}] = get_cellparam(f,cid,t_traj(locs(1)+1),t_traj(locs(2)));
            else
                [l{2},t{2},w{2},a{2},flr{2}] = get_cellparam(f,cid,t_traj(locs(1)),t_traj(locs(2)));
            end
        else
            [l{1},t{1},w{1},a{1}] = get_cellparam(f,cid,t_traj(1),t_traj(locs(1)));
            if locs(1)+1 > 1
                [l{2},t{2},w{2},a{2}] = get_cellparam(f,cid,t_traj(locs(1)+1),t_traj(locs(2)));
            else
                [l{2},t{2},w{2},a{2}] = get_cellparam(f,cid,t_traj(locs(1)),t_traj(locs(2)));
            end
        end
        
    elseif numel(pks) > 2
        %fprintf('Multiple peaks for cell %d\n',cid)
        l = [];
        t = [];
        w = [];
        a = [];
        if fluor_on
            flr = [];
        end
    end
end

if fluor_on
    varargout{1} = flr;
end

end