function [param,time] = get_paramdata(contourlist,paramname,varargin)
% plot given parameter for a list of contours. You can give param names
% that are found within the object such as Xcont, cell_length, etc..
%
% To calculate average fluorescence using fluor_internal_profile, specify
% avgfluor
%
% To calculate volume, specifiy volume and it will calculate from
% appropriate function
%
tperframe = 1;
plot_on = 1;
color = [1 0 0];
frame_blank = 1; % if 0, using local blank
multiply_pixel = 1;
pxl = 0.08;
if ~isempty(varargin)
    % print default variable information using functionname -h
    if strcmp(varargin{1},'-h')
        fprintf('To change variables, use: %s(''variablename'',variablevalue,...)\n',mfilename)
        fprintf('Default variables for %s:\n',mfilename)
        myvals = who;
        for n = 1:length(myvals)
            if ~strcmp(myvals{n},'varargin')
                if isstring(eval(myvals{n})) || ischar(eval(myvals{n}))
                    fprintf('%s = ''%s''\n',myvals{n},eval(myvals{n}))
                elseif isinteger(eval(myvals{n})) || isfloat(eval(myvals{n}))
                    fprintf('%s = %s\n',myvals{n},num2str(eval(myvals{n})))
                else
                    fprintf('%s = ''''\n',myvals{n})
                end
            end
        end
        return
    end
    
    % check if even numbered variables
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Improper arguments. Use ''-h'' flag to see options')
        return
    end
    
    % change variables
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

param = [];
time = [];

for i=1:numel(contourlist)
    f = load(contourlist(i).name);
    for j = 1:numel(f.frame)
        for k = 1:numel(f.frame(j).object)
            
            if strcmp(paramname,'avgfluor')
                if frame_blank
                    blank = f.frame(j).blank;
                else
                    blank = f.frame(j).object(k).bkg;
                end
                param = [param get_avgfluor(f.frame(j).object(k),blank)];
                time = [time j*tperframe];
            elseif strcmp(paramname,'volume')
                param = [param get_volume(f.frame(j).object(k))];
                time = [time j*tperframe];
            else
                if isfield(f.frame(j).object(k),paramname)
                    param = [param f.frame(j).object(k).(paramname)];
                    time = [time j*tperframe];
                else
                    fprintf('paramname does not exist')
                end
            end
            
            
        end
        
    end

end

if multiply_pixel
    param = param*pxl;
end

if plot_on
%     scatter(time,param,50,[0.5 0.5 0.5]); hold on;
    [med_param,err_param] = get_median_param(param,time,min(time));
    plot_med(med_param,err_param,color,1);  hold on;
end
end

function v = get_volume(mesh)
v = volume_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)]);
end

function fl = get_avgfluor(ob,blank)
fl = sum(ob.fluor_internal_profile-blank)/get_volume(ob.mesh);
end

function [med_param,err_param] = get_median_param(all_param,all_t,startt)
med_param = [];
err_param = [];
for ii = startt:max(all_t)
    idx = find(ii == all_t);
    med_param = [med_param;[ii,nanmedian(double(all_param(idx)))]];
    err_param = [err_param; [i,nanstd(double(all_param(idx)))]];
%     err_param = [err_param; [ii,nanstd(all_param(idx))/numel(idx)]];
end
end


function plot_med(med_param,err_param,colors,sm)
    idx1 = ~isnan(med_param(:,2));
    if sm
        med_paramy =smooth(med_param(idx1,2) );
    else
        med_paramy =med_param(idx1,2);
    end
    
    xlen = med_param(idx1,1);
    yupperbound = med_paramy+(err_param(idx1,2)/2);
    ylowerbound = med_paramy-(err_param(idx1,2)/2);
    c = colors + 0.3;
    c(c > 1) = 1;
    p = patch([xlen; flip(xlen)],[ylowerbound;flip(yupperbound)],c,'FaceAlpha',0.2,'EdgeColor','none');
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    plot(med_param(idx1,1),med_paramy,'Color',colors,'LineWidth',2);
end