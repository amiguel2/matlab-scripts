function  [cellstructure]=get_data(list,tframe,pxl,varargin)
% get_data(list,tframe,pxl,[fluor_on],[lineage],[tshift],[microbej],[onecolor])
% plots the data for a list of contour files
% Options: 'fluor_on','lineage','tshift','microbej','onecolor'
% Example:
% get_data(list,tframe,pxl,'lineage',1,'onecolor',[1 0 0])
% get_data(list,tframe,pxl,'fluor_on',1,'lineage',1,'onecolor',[1 0 0])

% old order
%     fluor_on = varargin{1};
%     lineage = varargin{2};
%     tshift = varargin{3};
%     microbej = varargin{4};
%     onecolor = varargin{5};

% setting paramaters
args = varargin;
paramset = set_funcparam(tframe,pxl,args);

% Error handling
s = warning('error', 'stats:nlinfit:IllConditionedJacobian'); %#ok<CTPCT>

%
count = 0;
cellstructure = {};

for i = 1:numel(list)
    
    % preparing each mat file
    fprintf('\n%s',list(i).name)
    f = load(list(i).name);
    
    try
    if ~isfield(f.frame(1).object(1),'mesh')
        fprintf('...No mesh, skipping...');
        continue
    end
    catch
        fprintf('...No mesh in first frame because no cells, but will continue...');
    end
    
    if ~isfield(f,'cells')
        fprintf('...Making Cell Table...');
        f = make_celltable(list(i).name);
    end
    
%     if paramset.lineage == 1
%         % split any mislabbeled cells
%         fprintf('splitting mislabelled cells\n')
%         f = fix_celllabel(f,tframe);
%         % split any mislabbeled cells
%         fprintf('calculating lineage')
%         f = calc_lineage(f);
%     end
    
    if f.Ncell > 0
        if paramset.microbej
            f = add_microbj_parameters(f);
        end
        maxt = (numel(f.frame)*tframe)-(tframe)+paramset.tshift;
        
        % find cells with at minimum 4 frames
%         minframe = 4;
        cells = find(cellfun(@numel,{f.cells.object}) > paramset.minframe);
        
        % for these cells
        fprintf('..Collecting cell data... ');
        for cid = cells
            lin_cell = 0;
            ccell.cid = cid;
            
            [ccell.l,ccell.t,ccell.w,ccell.a,ccell.v,ccell.sa,ccell.cont,ccell.mesh,ccell.flr,ccell.flr_prof,ccell.int_fluor,ccell.totflr] = splitcells(f,cid,paramset);
            
            % filter for high norm residual
            if paramset.falseposfilters && ~isempty(ccell.l)
                ccell = falseposfiltersfun(ccell);
            end
            
            if ~isempty(ccell.l) && ~iscell(ccell.l)
                count = count + 1;
                ccell.cid = cid;
                ccell.file = list(i).name;
                ccell.lineage = check_lineage(f,cid);
                cellstructure = get_data_cell(ccell,paramset,cellstructure,count);
            elseif iscell(ccell.l)
                n = numel(ccell.l);
                for k = 1:n
                    if ~isempty(ccell.l{k}) & numel(ccell.l{k}) > 2
                        count = count + 1;
                        subcell = get_splitcell(ccell,k);
                        subcell.cid = cid;
                        subcell.file = list(i).name;
                        subcell.lineage = check_lineage(f,cid);
                        cellstructure = get_data_cell(subcell,paramset,cellstructure,count);
                        
                    end
                end
            end
        end
    end
    fprintf('total count: %d',count)
end
end

function ccell = falseposfiltersfun(ccell)
if iscell(ccell.l)
    for i = 1:numel(l)
        l1 = ccell.l{i};
        t1 = ccellt{i};
        idx = find(abs(diff(l1)) > .1*l1(2:end));
    end
    
else
    l = ccell.l;
    t = ccell.t;
    idx = find(diff(l) > 0);
    templ = l([idx+1]);
end

end

function result = test_lengthjumps(l)
result = false;
if ~isempty(find(diff(l) > 0,1))
    result = true;
end
end


function lineage = check_lineage(f,c)
lineage = NaN;
if isfield(f.cells(c),'mother')
    lineage = 0;
    if ~isempty(f.cells(c).mother) && ~isempty(f.cells(c).daughter)
        lineage = 1;
    end
end
end

function cellstructure = get_data_cell(ccell,param,cellstructure,count)

l_temp = ccell.l*param.pxl;
t_temp = (ccell.t*param.tframe)-(param.tframe)+(param.tshift);
w_temp = ccell.w*param.pxl;
a_temp = ccell.a*(param.pxl^2);
v_temp = ccell.v*(param.pxl^3);
sa_temp = ccell.sa*(param.pxl^2);
mesh_temp = ccell.mesh;
cont_temp = ccell.cont;
flr = [ccell.flr];
totflr = [ccell.totflr];
flr_prof = ccell.flr_prof;
int_fluor = ccell.int_fluor;
finalt = t_temp(end);
startt= t_temp(1);

if length(param.onecolor) == 3
    c = param.onecolor;
else
    c = c1 + (c2-c1)*double(t_temp(1))/double(maxt);
end
% instantaneous lambda
if numel(a_temp) > 2
    smootha = smooth(smooth(a_temp))';
    instant_lambda_A = log(smootha(2:end)./smootha(1:end-1))./double(diff(t_temp));
    smoothl = smooth(smooth(l_temp))';
    instant_lambda_L = log(smoothl(2:end)./smoothl(1:end-1))./double(diff(t_temp));
    smoothf = smooth(smooth(flr))';
    instant_lambda_fluor = log(smoothf(2:end)./smoothf(1:end-1))./double(diff(t_temp));
    smoothw = smooth(smooth(w_temp))';
    instant_lambda_w = log(smoothw(2:end)./smoothw(1:end-1))./double(diff(t_temp));
    smoothv = smooth(smooth(v_temp))';
    instant_lambda_V = log(smoothv(2:end)./smoothv(1:end-1))./double(diff(t_temp));
    % fit volume curves
    try
        beta = [v_temp(1) 0.025];
        [beta,r] = nlinfit(t_temp,v_temp,@expfit,beta);
        
        lambda.beta = beta;
        lambda.res = r;
    catch
        lambda.beta= [NaN];
        lambda.res = [NaN];
    end
    deltalength = l_temp(end) - l_temp(1);
    deltaarea = a_temp(end) - a_temp(1);
    divtime = t_temp(end)-t_temp(1);
else
    lambda.beta= [NaN];
    lambda.res = [NaN];
    instant_lambda_A = NaN;
    instant_lambda_L = NaN;
    instant_lambda_fluor = NaN;
    instant_lambda_w = NaN;
    instant_lambda_V = NaN;
    deltalength = NaN;
    deltaarea = NaN;
    divtime = NaN;
end

cellstructure{count} = struct;
cellstructure{count}.cid = ccell.cid;
cellstructure{count}.length = l_temp;
cellstructure{count}.width = w_temp;
cellstructure{count}.time = t_temp;
cellstructure{count}.area = a_temp;
cellstructure{count}.volume = v_temp;
cellstructure{count}.surfacearea =sa_temp;
cellstructure{count}.cont =cont_temp;
cellstructure{count}.mesh =mesh_temp;
cellstructure{count}.deltalength = deltalength;
cellstructure{count}.deltaarea=deltaarea;
cellstructure{count}.color=c;
cellstructure{count}.instant_lambda_A=instant_lambda_A; % used to be instant_lambda
cellstructure{count}.instant_lambda_length = instant_lambda_L;
cellstructure{count}.instant_lambda_fluor = instant_lambda_fluor;
cellstructure{count}.instant_lambda_w = instant_lambda_w;
cellstructure{count}.instant_lambda_V = instant_lambda_V;
cellstructure{count}.lambda =lambda;
cellstructure{count}.divtime=divtime;
cellstructure{count}.finalt=finalt;
cellstructure{count}.startt=startt;
cellstructure{count}.lineage=ccell.lineage;
cellstructure{count}.avg_fluor=flr;
cellstructure{count}.tot_fluor=totflr;
cellstructure{count}.flr_profile=flr_prof;
cellstructure{count}.int_fluor = int_fluor;
cellstructure{count}.contourfile=ccell.file;

end

function paramset = set_funcparam(tframe,pxl,args)
%  Usage information
if  numel(args) == 0
    fprintf('Usage: get_data(list,tframe,pxl,[optional]...)\n')
    fprintf('Options: ''fluor_on'',''lineage'',''tshift'',''microbej'',''onecolor''\n')
    fprintf('Example: get_data(list,tframe,pxl,''lineage'',1,''onecolor'',[1 0 0])\n')
    return
end

% default parameters
paramset.polaris = 0;
paramset.tframe = tframe;
paramset.pxl = pxl;
paramset.lineage = 0;
paramset.microbej = 0;
paramset.onecolor = 0;
paramset.tshift = 0;
paramset.maxT = Inf;
paramset.minT = 0;
paramset.falseposfilters = 0; % excludes cells that have high residuals when fit to an linear log
paramset.minframe = 4;
paramset.kupper  = Inf;%0.25
paramset.klower =  -0.5;%-0.2;
paramset.arealower = 100;
paramset.localblank = 0;
if ~isempty(args)
    evennumvars = mod(numel(args),2);
    if evennumvars
        fprintf('Too many arguments. Use: get_data(list,tframe,pxl,[optional] fluor lineage tshift microbej onecolor)\n')
        return
    end
    
    for i = 1:2:numel(args)
        eval(sprintf('paramset.%s = args{%d};',args{i},i+1));
    end
end

paramset.maxF = paramset.maxT/paramset.tframe;
paramset.minF = paramset.minT/paramset.tframe;

end

function newccell = get_splitcell(ccell,k)
newccell.l = ccell.l{k};
newccell.t = ccell.t{k};
newccell.w= ccell.w{k};
newccell.a= ccell.a{k};
newccell.v= ccell.v{k};
newccell.sa= ccell.sa{k};
newccell.cont = ccell.cont{k};
newccell.mesh = ccell.mesh{k};
if isfield(ccell,'flr')
    newccell.flr = ccell.flr{k};
    newccell.totflr = ccell.totflr{k};
end
if isfield(ccell,'flr_prof')
    newccell.flr_prof = ccell.flr_prof{k};
    newccell.int_fluor = ccell.int_fluor{k};
end

end

function [l,t,w,a,v,sa,cont,cellmesh,flr,flr_prof,int_fluor,totflr] = get_cellparam(contour,id,param,varargin)
% [l,t,w,varargout] = get_celllength(contour,id,varargin)
% gets cell length. no optional parameters grabs whole thing.
% varargin{1} = start
% varargin{2} = end

% kupper  = Inf;%0.25
% klower =  -0.5;%-0.2;
% arealower = 100;
% localblank = 0; % 1 uses local blank, otherwise, use the frame blank

if isfield(contour,'cells')
    l = [];
    t = [];
    w = [];
    a = [];
    v = [];
    sa = [];
    cont = {};
    cellmesh = {};
    flr = [];
    totflr = [];
    flr_prof = {};
    int_fluor = {};
    
    frames = contour.cells(id).frame;
    objects = contour.cells(id).object;
    
    % remove frames above maxT
    objects = objects(frames>=param.minF);
    frames = frames(frames>=param.minF);
    objects = objects(frames<param.maxF);
    frames = frames(frames<param.maxF);
    
    if ~isempty(frames)
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
        
        
        % for specified start and n (default is start and end of frames)
        for i = start:n
            idx = find(frames == i);
            if numel(idx) == 1 && objects(idx)
                ob = contour.frame(frames(idx)).object(objects(idx));
                ob = convert_paramnames(ob);
                if ~isempty(ob.cell_length)
                    if min(ob.Xcont) < 100 || max(ob.Xcont) > 2400
                        if param.polaris == 1
                            continue
                        end
                    end
                    if ob.kappa_smooth < param.kupper & ob.area > param.arealower & ob.kappa_smooth > param.klower
                        
                        l = [ l ob.cell_length];
                        t = [ t frames(idx)];
                        w = [ w ob.cell_width];
                        a = [ a ob.area];
                        mesh = ob.mesh;
                        v = [ v volume_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)])];
                        sa = [ sa sarea_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)])];
                        cont = [cont [ob.Xcont ob.Ycont]];
                        cellmesh = [cellmesh mesh];
                        if isfield(ob,'fluor_internal_profile')
                            if ~isempty(ob.fluor_internal_profile)
                                if param.localblank
                                    if isfield(ob,'bkg')
                                        blank = sum(ob.bkg);
                                    else
                                        fprintf('No specified blank. Using Blank = 0')
                                        blank = 0;
                                    end
                                else
                                    % ADDED medblank 2018-10-01
                                    if isfield(contour.frame(frames(idx)),'medblankY')
                                        blank = contour.frame(frames(idx)).medblankY(int16(ob.Ycent));
                                        % end add
                                    elseif isfield(contour.frame(frames(idx)),'blank')
                                        if numel(contour.frame(frames(idx)).blank) > 1
                                            blank = contour.frame(frames(idx)).blank(1);
                                        else
                                            blank = contour.frame(frames(idx)).blank;
                                        end
                                    else
                                        fprintf('No specified blank. Using Blank = 0')
                                        blank = 0;
                                    end
                                end
                                flr = [flr sum(ob.fluor_internal_profile-blank)/volume_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)])];
                                totflr = [totflr sum(ob.fluor_internal_profile-blank)];
                                % ADDED elseif statement below 2018-09-05 AVM
                            elseif isfield(ob,'ave_fluor')
                                fprintf('Warning: Using ave_fluor instead of internal_profile')
                                if param.localblank
                                    if isfield(ob,'bkg')
                                        blank = sum(ob.bkg);
                                    else
                                        fprintf('No specified blank. Using Blank = 0')
                                        blank = 0;
                                    end
                                else
                                    % ADDED medblank 2018-10-01
                                    if isfield(contour.frame(frames(idx)),'medblankY')
                                        blank = contour.frame(frames(idx)).medblankY(int16(ob.Ycent));
                                        % end add
                                    elseif isfield(contour.frame(frames(idx)),'blank')
                                        if numel(contour.frame(frames(idx)).blank) > 1
                                            blank = contour.frame(frames(idx)).blank(1);
                                        else
                                            blank = contour.frame(frames(idx)).blank;
                                        end
                                    else
                                        fprintf('No specified blank. Using Blank = 0')
                                        blank = 0;
                                    end
                                end
                                flr = [ flr ob.ave_fluor - double(blank)];
                                totflr = [totflr ob.ave_flour*ob.area];
                                % End of addition 2018-09-05 AVM
                            else
                                flr = [flr NaN];
                                totflr = [totflr NaN];
                            end
                        else
                            flr = [flr NaN];
                            totflr = [totflr NaN];
                        end
                        if isfield(ob,'fluor_profile')
                            flr_prof = [flr_prof ob.fluor_profile];
                            int_fluor = [int_fluor ob.fluor_interior];
                        else
                            
                            flr_prof = [flr_prof NaN];
                            int_fluor = [int_fluor NaN];
                        end
                    end
                end
                
            end
        end
        
        nonnan = ~isnan(l);
        
        %remove nan entries
        t = t(nonnan);
        w = w(nonnan);
        l = l(nonnan);
        a = a(nonnan);
        v = v(nonnan);
        sa = sa(nonnan);
        flr = flr(nonnan);
        totflr = totflr(nonnan);
        flr_prof(nonnan);
        
    else % if frames is empty
        l = [];
        t = [];
        w = [];
        a = [];
        v = [];
        sa = [];
        cont = {};
        cellmesh = {};
        flr = {};
        totflr = {};
        flr_prof = {};
        int_fluor = {};
    end
else
    fprintf('No cells structure. Run make_celltable on contour first\n')
    l = [];
    t = [];
    w = [];
    a = [];
    v = [];
    sa = [];
    cont = {};
    cellmesh = {};
    flr = {};
    totflr = {};
    flr_prof = {};
    int_fluor = {};
end
end

function [l,t,w,a,v,sa,cont,cellmesh,flr,flr_prof,int_fluor,totflr]= splitcells(f,cid,param)
%this script takes a cell as defined by morphometrics and sees if there has
%been a reassignment of the id to a mother and daughter cell. If so,
%returns back separate length trajectories in a cell, if not, returns the length/time
%trajectory defined
if ~isstruct(f)
    f = load(f);
end

l = {};
t = {};
w = {};
a = {};
v = {};
sa = {};
cont = {};
cellmesh = {};
flr = {};
totflr = {};
flr_prof = {};
int_fluor = {};


[l_traj,t_traj,w_traj,a_traj,v_traj,sa_traj,cont_traj,m_traj,flr_traj,flrprf_traj,intflr_traj,totflr_traj] = get_cellparam(f,cid,param);

jumpdetectthreshold = 0.05 * param.tframe;
if numel(l_traj) > param.minframe
    dl = diff(l_traj);
    locs = find(abs(dl) > jumpdetectthreshold*l_traj(1:end-1));
    pks = l_traj(locs);
    
    if isempty(pks) % if there are no peaks or troughs on the length
        l = l_traj;
        t = t_traj;
        w = w_traj;
        a = a_traj;
        v = v_traj;
        sa = sa_traj;
        cont = cont_traj;
        cellmesh = m_traj;
        flr = flr_traj;
        totflr = totflr_traj;
        flr_prof = flrprf_traj;
        int_fluor = intflr_traj;
        
    else
        tstart = t_traj(1);
        
        % in between peaks
        for i = 1:numel(pks)
            tend = t_traj(locs(i));
            idx1 = find(tstart == t_traj);
            idx2 = find(tend == t_traj);
            if numel(t_traj(idx1:idx2)) > param.minframe
                
                [l{i},t{i},w{i},a{i},v{i},sa{i},cont{i},cellmesh{i},flr{i},flr_prof{i},int_fluor{i},totflr{i}] = get_cellparam(f,cid,param,tstart,tend);
            end
            tstart = t_traj(locs(i)+1);
        end
        
        %last peak
        i = numel(pks)+1;
        idx1 = find(tstart == t_traj);
        if numel(t_traj(idx1:end)) > param.minframe
            [l{i},t{i},w{i},a{i},v{i},sa{i},cont{i},cellmesh{i},flr{i},flr_prof{i},int_fluor{i},totflr{i}] = get_cellparam(f,cid,param,tstart);
        end
    end
end

end

function volume = volume_from_mesh(mesh, centerline)

% mesh result gives parallel lines from two sides of the contour
% centerline is the coordinates of center for each parallel set of mesh
% for each circular truncated cone, the volume is V = pi / 3 * h * (r1^2 +
% r1 * r2 + r2^2)

volume = 0;
r = zeros(1, size(mesh, 1));
for i = 1 : size(mesh, 1)
    r(i) = mesh_dist(mesh(i, :)) / 2;
end

for i = 2 : size(mesh, 1)
    r1 = r(i - 1);
    r2 = r(i);
    h = centerline_dist(centerline(i - 1, :), centerline(i, :));
    volume = volume + cirTrunConVol(r1, r2, h);
end
end

function y = mesh_dist(meshline)
% returns the length of a meshline
x1 = meshline(1);
x2 = meshline(3);
y1 = meshline(2);
y2 = meshline(4);
y = sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2);
end

function y = centerline_dist(centerlineentry1, centerlineentry2)
% returns the length of a centerline entry
x1 = centerlineentry1(1);
y1 = centerlineentry1(2);
x2 = centerlineentry2(1);
y2 = centerlineentry2(2);
y = sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2);
end

function y = cirTrunConVol(r1, r2, h)
y = pi / 3 * h * (r1 ^ 2 + r1 * r2 + r2 ^ 2);
end

function SA = sarea_from_mesh(mesh, centerline)

% mesh result gives parallel lines from two sides of the contour
% centerline is the coordinates of center for each parallel set of mesh
% for each circular truncated cone, the lateral surface area is L = ( r1 +
% r2 ) * ? * s, where s = ? (r1 - r2)² + h²


SA = 0;
r = zeros(1, size(mesh, 1));
for i = 1 : size(mesh, 1)
    r(i) = mesh_dist(mesh(i, :)) / 2;
end

for i = 2 : size(mesh, 1)
    r1 = r(i - 1);
    r2 = r(i);
    h = centerline_dist(centerline(i - 1, :), centerline(i, :));
    SA = SA + cirTrunConL(r1, r2, h);
end
end

function y = cirTrunConslantheight(r1, r2, h)
y = sqrt((max(r1,r2)-min(r1,r2))^2 + h^2);
end

function y = cirTrunConL(r1, r2, h)
s = cirTrunConslantheight(r1, r2, h);
y = (r1 + r2)*pi*s;
end

function ob = convert_paramnames(ob)
    % convert length/width/pillmesh to my common names;

    if ~isfield(ob,'cell_length')
        ob.cell_length = ob.length;
        ob.cell_width = ob.width;
        ob.mesh = ob.pill_mesh;
    end
end