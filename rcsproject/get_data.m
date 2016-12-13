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

if nargin == 0
    fprintf('Usage: get_data(list,tframe,pxl,[optional]...)\n')
    fprintf('Options: ''fluor_on'',''lineage'',''tshift'',''microbej'',''onecolor''\n')
    fprintf('Example: get_data(list,tframe,pxl,''lineage'',1,''onecolor'',[1 0 0])\n')
    return
end


% default parameters
fluor_on = 0;
lineage = 0;
microbej = 0;
onecolor = 0;
tshift = 0;
excludehighresiduals = 1; % excludes cells that have high residuals when fit to an exponential

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: get_data(list,tframe,pxl,[optional] fluor lineage tshift microbej onecolor)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end


s = warning('error', 'stats:nlinfit:IllConditionedJacobian'); %#ok<CTPCT>

%
c1=[0 1 1];
c2 =[1 0 0];
count = 0;
cellstructure = {};

for i = 1:numel(list)
    
    % preparing each mat file
    fprintf('%s\n',list(i).name)
    f = load(list(i).name);
    if ~isfield(f,'cells')
        f = make_celltable(f);
    end
    if microbej
        f = add_microbj_parameters(f);
    end
    maxt = (numel(f.frame)*tframe)-(tframe)+tshift;
    
    % find cells with at minimum 3 frames
    cells = find(cellfun(@numel,{f.cells.object}) > 4);
    
    % for these cells
    for cid = cells;
        lin_cell = 0;
        if fluor_on
            [l,t,w,a,v,sa,flr] = splitcells(f,cid);
        else
            [l,t,w,a,v,sa] = splitcells(f,cid);
        end
        
        % filter for high norm resiudal
        if excludehighresiduals && ~isempty(l)
            l = eval_resid(l,t);
        end
        
        if ~isempty(l) && ~iscell(l)
            count = count + 1;
            l_temp = l*pxl;
            t_temp = (t*tframe)-(tframe)+(tshift);
            w_temp = w*pxl;
            a_temp = a*(pxl^2);
            v_temp = v*(pxl^3);
            sa_temp = sa*(pxl^2);
            
            deltalength = l_temp(end) - l_temp(1);
            deltaarea = a_temp(end) - a_temp(1);
            if length(onecolor) == 3
                c = onecolor;
            else
                c = c1 + (c2-c1)*double(t_temp(1))/double(maxt);
            end
            % instantaneous lambda
            smootha = smooth(a_temp)';
            instant_lambda = log(smootha(2:end)./smootha(1:end-1))./double(diff(t_temp));
            
            % fit area curves
            try
                beta = [a_temp(1) 0.025];
                [beta,r] = nlinfit(t_temp,a_temp,@expfit,beta);
                
                lambda.beta = beta;
                lambda.res = r;
            catch
                lambda.beta= [nan];
                labda.res = [nan];
            end
            divtime = t_temp(end)-t_temp(1);
            finalt = t_temp(end);
            startt= t_temp(1);
            if fluor_on
                if lineage
                    lin_cell = check_lineage(f,cid);
                    cellstructure{count} = struct('cid',cid,'length',l_temp,'width',w_temp,'time',t_temp,'area',a_temp,'volume',v_temp,'surfacearea',sa_temp,'deltalength',deltalength,'deltaarea',deltaarea,'color',c,'instant_lambda',instant_lambda,'lambda',lambda,'divtime',divtime,'finalt',finalt,'startt',startt,'lineage',lin_cell,'avg_fluor',flr,'contourfile',list(i).name);
                else
                    cellstructure{count} = struct('cid',cid,'length',l_temp,'width',w_temp,'time',t_temp,'area',a_temp,'volume',v_temp,'surfacearea',sa_temp,'deltalength',deltalength,'deltaarea',deltaarea,'color',c,'instant_lambda',instant_lambda,'lambda',lambda,'divtime',divtime,'finalt',finalt,'startt',startt,'avg_fluor',flr,'contourfile',list(i).name);
                end
            else
                if lineage
                    if t_temp(end) == maxt || t_temp(1) < 10
                        lin_cell = 0;
                    else
                        lin_cell = check_lineage(f,cid);
                    end
                    cellstructure{count} = struct('cid',cid,'length',l_temp,'width',w_temp,'time',t_temp,'area',a_temp,'volume',v_temp,'surfacearea',sa_temp,'deltalength',deltalength,'deltaarea',deltaarea,'color',c,'instant_lambda',instant_lambda,'lambda',lambda,'divtime',divtime,'finalt',finalt,'startt',startt,'lineage',lin_cell,'contourfile',list(i).name);
                    
                else
                    cellstructure{count} = struct('cid',cid,'length',l_temp,'width',w_temp,'time',t_temp,'area',a_temp,'volume',v_temp,'surfacearea',sa_temp,'deltalength',deltalength,'deltaarea',deltaarea,'color',c,'instant_lambda',instant_lambda,'lambda',lambda,'divtime',divtime,'finalt',finalt,'startt',startt,'contourfile',list(i).name);
                end
            end
        elseif iscell(l)
            n = numel(l);
            for k = 1:n
                if ~isempty(l{k}) & numel(l{k}) > 2
                    
                    count = count + 1;
                    l_temp = l{k}*pxl;
                    t_temp = (double(t{k}*tframe))-(tframe)+tshift;
                    w_temp = w{k}*pxl;
                    a_temp = a{k}*(pxl^2);
                    v_temp = v{k}*(pxl^3);
                    sa_temp = sa{k}*(pxl^2);
                    if microbej
                        l_temp = l_temp(~isnan(l_temp));
                        t_temp = t_temp(~isnan(l_temp));
                        w_temp = w_temp(~isnan(l_temp));
                        a_temp = a_temp(~isnan(l_temp));
                        v_temp = v_temp(~isnan(l_temp));
                        sa_temp = sa_temp(~isnan(l_temp));
                        if fluor_on
                            flr = flr(~isnan(l));
                        end
                    end
                    deltalength = l_temp(end) - l_temp(1);
                    deltaarea = a_temp(end) - a_temp(1);
                    if length(onecolor) == 3
                        c = onecolor;
                    else
                        c = c1 + (c2-c1)*(t_temp(1)/maxt);
                    end
                    % instantaneous lambda
                    smootha = smooth(a_temp)';
                    instant_lambda = log(smootha(2:end)./smootha(1:end-1))./double(diff(t_temp));
                    
                    % fit area curves
                    try
                        beta = [a_temp(fi(1)) 20];
                        [beta,r] = nlinfit(t_temp,a_temp,@expfit,beta);
                        lambda.beta = beta;
                        lambda.res = r;
                    catch
                        lambda.beta= [nan nan];
                        labda.res = [nan];
                    end
                    
                    divtime = t_temp(end)-t_temp(1);
                    finalt = t_temp(end);
                    startt= t_temp(1);
                    if fluor_on
                        if lineage
                            lin_cell = check_lineage(f,cid);
                            cellstructure{count} = struct('cid',cid,'length',l_temp,'width',w_temp,'time',t_temp,'area',a_temp,'volume',v_temp,'surfacearea',sa_temp,'deltalength',deltalength,'deltaarea',deltaarea,'color',c,'instant_lambda',instant_lambda,'lambda',lambda,'divtime',divtime,'finalt',finalt,'startt',startt,'lineage',lin_cell,'avg_fluor',flr{k},'contourfile',list(i).name);
                        else
                            cellstructure{count} = struct('cid',cid,'length',l_temp,'width',w_temp,'time',t_temp,'area',a_temp,'volume',v_temp,'surfacearea',sa_temp,'deltalength',deltalength,'deltaarea',deltaarea,'color',c,'instant_lambda',instant_lambda,'lambda',lambda,'divtime',divtime,'finalt',finalt,'startt',startt,'avg_fluor',flr{k},'contourfile',list(i).name);
                        end
                    else
                        if lineage
                            if t_temp(end) == maxt || t_temp(1) == tframe
                                lin_cell = 0;
                            else
                                lin_cell = check_lineage_splitcell(f,cid,l,k);
                            end
                            cellstructure{count} = struct('cid',cid,'length',l_temp,'width',w_temp,'time',t_temp,'area',a_temp,'volume',v_temp,'surfacearea',sa_temp,'deltalength',deltalength,'deltaarea',deltaarea,'color',c,'instant_lambda',instant_lambda,'lambda',lambda,'divtime',divtime,'finalt',finalt,'startt',startt,'lineage',lin_cell,'contourfile',list(i).name);
                        else
                            cellstructure{count} = struct('cid',cid,'length',l_temp,'width',w_temp,'time',t_temp,'area',a_temp,'volume',v_temp,'surfacearea',sa_temp,'deltalength',deltalength,'deltaarea',deltaarea,'color',c,'instant_lambda',instant_lambda,'lambda',lambda,'divtime',divtime,'finalt',finalt,'startt',startt,'contourfile',list(i).name);
                        end
                    end
                end
            end
        end
    end
end
end

function l = eval_resid(l,t)
if iscell(l)
    l1 = l{1};
    t1 = t{1};
    [p,S] = polyfit(t1,log(l1),1);
else
    [p,S] = polyfit(t,log(l),1);
end
r = S.normr;
if sum(r) > 0.05
    l = [];
end
end
