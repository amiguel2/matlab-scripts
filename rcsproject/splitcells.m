function [l,t,w,a,varargout]= splitcells(f,cid)
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
        
    else
        tstart = t_traj(1);
        
        % in between peaks
        for i = 1:numel(pks)
            tend = t_traj(locs(i));
            if fluor_on
                [l{i},t{i},w{i},a{i},flr{i}] = get_cellparam(f,cid,tstart,tend);
            else
                [l{i},t{i},w{i},a{i}] = get_cellparam(f,cid,tstart,tend);
            end
            tstart = t_traj(locs(i)+1);
        end
        
        %last peak
        i = numel(pks)+1;
        if fluor_on
            [l{i},t{i},w{i},a{i},flr{i}] = get_cellparam(f,cid,tstart);
        else
            [l{i},t{i},w{i},a{i}] = get_cellparam(f,cid,tstart);
        end
    end
end

if fluor_on
    varargout{1} = flr;
end

end