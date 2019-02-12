function f= hist_transparent(data,varargin)

bin = 50;
colors = [1 0 0];
face = 1;
edges = NaN;

if ~isempty(varargin)
    % print default variable information
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

if isnan(edges)
[counts,centers] = histcounts(data,bin);
else
    [counts,centers] = histcounts(data,edges);
end
if size(centers,1) ~= 1
    centers = centers';
end
if numel(centers)>numel(counts)
    centers = diff(centers)/2+centers(1:end-1);
end

if face
f = fill([centers(1) centers centers(end)],[0 counts/sum(counts) 0],colors,'FaceAlpha',0.1,'EdgeColor',colors);
else
    f = fill([centers(1) centers centers(end)],[0 counts/sum(counts) 0],colors,'FaceAlpha',0,'EdgeColor',colors);
end
end