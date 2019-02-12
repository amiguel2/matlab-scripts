function setvariableparam(basevarargin,myvals)

if ~isempty(basevarargin)
    % print default variable information using functionname -h
    if strcmp(basevarargin{1},'-h')
        fprintf('To change variables, use: %s(''variablename'',variablevalue,...)\n',mfilename)
        fprintf('Default variables for %s:\n',mfilename)
%         myvals = who;
        for n = 1:length(myvals)
            variableValue = getVariable('base',myvals{n});
            if ~strcmp(myvals{n},'varargin')
                if isstring(variableValue) || ischar(variableValue)
                    fprintf('%s = ''%s''\n',myvals{n},variableValue)
                elseif isinteger(variableValue) || isfloat(variableValue)
                    fprintf('%s = %s\n',myvals{n},num2str(variableValue))
                else
                    fprintf('%s = ''''\n',myvals{n})
                end
            end
        end
       return
    end

    % check if even numbered variables
    evennumvars = mod(numel(basevarargin),2);
    if evennumvars
        fprintf('Improper arguments. Use ''-h'' flag to see options')
        return
    end

    % change variables
    for i = 1:2:numel(basevarargin)
%         eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
        eval(sprintf('assignin(ws, %s, varargin{%d});',basevarargin{i},i+1));
    end
    end
end