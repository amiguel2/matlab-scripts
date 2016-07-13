function [l,t,w,a,varargout]= splitcells(f,cid)
%this script takes a cell as defined by morphometrics and sees if there has
%been a reassignment of the id to a mother and daughter cell. If so,
%returns back separate length trajectories in a cell, if not, returns the length/time
%trajectory defined

l = {};
t = {};
w = {};
a = {};

if ~isstruct(f)
    f = load(f);
end

if isfield(f.frame(1).object(1),'ave_fluor')
    fluor_on = 1;
    flr = {};
else
    fluor_on = 0;
end

if fluor_on
    [l_traj,t_traj,w_traj,a_traj,flr_traj] = get_cellparam(f,cid);
else
    [l_traj,t_traj,w_traj,a_traj] = get_cellparam(f,cid); % get length/time
end
if numel(l_traj) > 3
    [pks,locs] = findpeaks(l_traj,'MinPeakProminence',1); % find peak in length
    [pks1,locs1] = findpeaks(l_traj*-1,'MinPeakProminence',1); % find trough in length
    
    if isempty(pks) && ~isempty(pks1) && numel(locs1) == 1 %if there is a single trough
        if fluor_on
            l{1} = [];
            t{1} = [];
            w{1} = [];
            a{1} = [];
            flr{1} = [];
            [l{2},t{2},w{2},a{2},flr{2}] = get_cellparam(f,cid,locs1);
        else
            l{1} = [];
            t{1} = [];
            w{1} = [];
            [l{2},t{2},w{2},a{2}] = get_cellparam(f,cid,locs1);
        end
        
    elseif isempty(pks) % if there are no peaks or troughs
        l = l_traj;
        t = t_traj;
        w = w_traj;
        a = a_traj;
        
        if fluor_on
            flr = flr_traj;
        end
        
    elseif numel(pks) == 2 && numel(pks1) < numel(pks) % 3 cells
        if fluor_on
            [l{1},t{1},w{1},a{1},flr{1}] = get_cellparam(f,cid,1,locs(1));
            [l{2},t{2},w{2},a{2},flr{2}] = get_cellparam(f,cid,locs1,locs(2));
        else
            [l{1},t{1},w{1},a{1}] = get_cellparam(f,cid,1,locs(1));
            [l{2},t{2},w{2},a{2}] = get_cellparam(f,cid,locs1,locs(2));
        end
        
    elseif numel(pks) > 1 || numel(pks1) > 1
        %fprintf('Multiple peaks for cell %d\n',cid)
        l = [];
        t = [];
        w = [];
        a = [];
        if fluor_on
            flr = [];
        end
        
    elseif numel(pks) == 1 % if there is 1 peak
        idx = find(min(l_traj) == l_traj);
        if ~isempty(locs1)
            if fluor_on
                [l{1},t{1},w{1},a{1},flr{1}] = get_cellparam(f,cid,1,locs);
                [l{2},t{2},w{2},a{2},flr{2}] = get_cellparam(f,cid,locs1);
            else
                [l{1},t{1},w{1},a{1}] = get_cellparam(f,cid,1,locs);
                [l{2},t{2},w{2},a{2}] = get_cellparam(f,cid,locs1);
            end
            %[l,t] = get_cellparam(f,cid,locs1);
        else
            if fluor_on
                [l{1},t{1},w{1},a{1},flr{1}] = get_cellparam(f,cid,1,locs);
            else
                [l{1},t{1},w{1},a{1}] = get_cellparam(f,cid,1,locs);
            end
        end
    end
end
if fluor_on
    varargout{1} = flr;
end