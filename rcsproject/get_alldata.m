function  [cellstructure]=get_alldata(list,tframe,pxl,varargin)
% plots the data for a list of contour files
% if want to check lineage, include 1/0 after pixel. Default is no-lineage,
% as this takes much longer to calculate.

if numel(varargin) == 1
    fluor_on = varargin{1};
    microbej = 0;
elseif numel(varargin) == 2
    fluor_on = varargin{1};
    microbej = varargin{2};
elseif numel(varargin) > 2
    fprintf('Too many arguments. Use: get_data(list,tframe,pxl,[optional] fluor lineage)\n')
    return
else
    fluor_on = 0;
    microbej = 0;
end


c1=[0 1 1];
c2 =[1 0 0];
count = 0;
cellstructure = {};
for i = 1:numel(list)
    fprintf('%s\n',list(i).name)
    f = load(list(i).name);
    if ~isfield(f,'cells')
        f = make_celltable(f);
    end
    if microbej
        f = add_microbj_parameters(f);
    end
    maxt = numel(f.frame)*tframe;
    for cid = 1:numel(f.cells)
        [l,t,w] = get_celllength(f,cid);
        if numel(l) > 2
            count = count + 1;
            l_temp = l*pxl;
            t_temp = t*tframe;
            w_temp = w*pxl;
            if microbej
                l_temp = l_temp(~isnan(l_temp));
                t_temp = t_temp(~isnan(l_temp));
                w_temp = w_temp(~isnan(l_temp));
                if fluor_on
                    flr = flr(~isnan(l));
                end
            end
            deltalength = l_temp(end) - l_temp(1);
            c = c1 + (c2-c1)*double(t_temp(1))/double(maxt);
            smoothl = smooth(l_temp)';
            lambda = log(smoothl(2:end)./smoothl(1:end-1))./double(diff(t_temp));
            divtime = t_temp(end)-t_temp(1);
            finalt = t_temp(end);
            startt= t_temp(1);
            cellstructure{count} = struct('cid',cid,'length',l_temp,'width',w_temp,'time',t_temp,'deltalength',deltalength,'color',c','lambda',lambda,'divtime',divtime,'finalt',finalt,'startt',startt);
        end
    end
end
end