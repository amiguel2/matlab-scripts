function [maxgr,lag] = get_maxgrowthrate(logod,time,varargin)
% this function uses three methods to calculate growthrate:
% 1. fit a linear curve to logod over a window size N, 2. find max peak of the growthrate, 3. gompertz fit
% this function will also plot each if you turn makeplots == 1.

% variables
makeplots =0;
windowsize = 5;
subplotN = 1;
subplotM = 3;
subplotK = [1 2 3];
detectionlimit = -6;
timelimit = 60; %min

% setvariableparam(varargin,who)
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

if makeplots
    figure('Position',[289 696 951 282]);
end
maxgr = NaN(1,3);
lag = NaN(1,3);

tempidx = find(time > timelimit,1);
templ = logod(tempidx:end);
tempt = time(tempidx:end);

idx = find(templ < detectionlimit,1,'last')+1;
if isempty(idx) || numel(templ) - idx < 3
    idx=find(templ > detectionlimit,1);
end
l = templ(idx:end);
l(isinf(l)) = NaN;
t = tempt(idx:end);

if isempty(l)
    return
end

if makeplots
    subplot(subplotN,subplotM,subplotK(1))
    cla
    plot(t,l); hold on;
end
[maxgr(1),lag(1)] = fitlinear2log(l,t,windowsize,makeplots);


if makeplots
    subplot(subplotN,subplotM,subplotK(2))
    cla
end
[maxgr(2),lag(2)] = findmaxgrpeak(l,t,makeplots);

if makeplots
    subplot(subplotN,subplotM,subplotK(3))
    cla
    plot(t,l); hold on;
end

[maxgr(3),lag(3)] = gompertzgr(l,t,makeplots);


idx = find(max(round(maxgr,3))==round(maxgr,3));
if makeplots
    for i = idx
        subplot(subplotN,subplotM,subplotK(i));
        h = get(gca,'title');
        h.Color = [1 0 0];
    end
    pause;
    close
end
end

function [maxgr,lag] = gompertzgr(l,t,makeplots)
try
    [fitresult,~] = fitGompertzModel(t(~isinf(l)),l(~isinf(l)));
    
    maxgr = fitresult.mu(1);
    lag = fitresult.lambda(1);
    
    if makeplots
        %     text(15,-4,sprintf('gr = %.3f',fitresult.mu(1)))
        plot(t,plotGompertz(fitresult,t),'Color','r');
        title(sprintf('gompertz maxgr = %.3f',maxgr));
        hold off;
    end
    
catch
    maxgr = NaN;
    lag = NaN;
end
end

function [maxgr,lag] = findmaxgrpeak(l,t,makeplots)
rate = diff(l)./diff(t);
rate(isinf(rate)) = NaN;
srate = smooth(rate,5);
t1 = t(1:end-1);
if makeplots
    findpeaks(srate,t1,'Npeaks',1,'MinPeakProminence',0.01); hold on;
end

[P,L] = findpeaks(srate,t1,'Npeaks',1,'MinPeakProminence',0.01);
if ~isempty(P)
    maxgr = P(1);
    lag = L(1);
else
    maxgr = max(srate);
    lag = t1(find(max(srate) == srate,1));
end

if makeplots
    title(sprintf('find peak maxgr = %.3f',maxgr))
    scatter(lag,maxgr,50,'r');
    text(15,0.01,sprintf('gr = %.3f',maxgr));
    hold off;
end
end

function [maxgr,lag] = fitlinear2log(l,t,N,makeplots)
maxgr = 0;
lag = NaN;

maxN = 100;
if numel(t) <= maxN
    maxN = numel(t)-1;
end

if makeplots
    plot(t((0:N:maxN)+1),l((0:N:maxN)+1)); hold on;
end

for i = 1:N:(maxN-N)
    
    xx1 = t(i:i+N);
    yy1 = l(i:i+N);
    if size(yy1,1) ~= size(xx1,1)
        yy1 = yy1';
    end
    xx = xx1(~isnan(yy1)&~isnan(xx1));
    yy = yy1(~isnan(yy1)&~isnan(xx1));
    if ~isempty(xx)&~isempty(yy)
        try
            model = polyfitn(xx,yy,'constant, x');
            if model.Coefficients(2) > maxgr && model.Coefficients(2) < 0.050
                maxgr = model.Coefficients(2);
                lag = xx1(1)+xx1(end)/2;
                maxgrX = xx(1);
                maxgrY = yy(1)+.1;
            end
            if makeplots
                plot(xx,polyval(flip(model.Coefficients),xx),'Color',[0.5 0.5 0.5]); hold on;
                text(xx(1),yy(1)+.1,sprintf('%.3f',model.Coefficients(2)))
            end
        catch
        end
    end
end
if makeplots
    if exist('maxgrX')
        text(maxgrX,maxgrY,sprintf('%.3f',model.Coefficients(2)),'Color','r')
        title(sprintf('fitlinear2log maxgr = %.3f',maxgr))
        hold off;
    end
end
end