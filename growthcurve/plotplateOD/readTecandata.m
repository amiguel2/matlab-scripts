function [num1,t] = readTecandata(file,varargin)

% Default 
data_start = 'B40:FI135';
time_start = 'B38:FI38';



if numel(varargin) > 0
    data_start = varargin{1};
end
if numel(varargin) > 1
    time_start = varargin{2};
end
[num1,~,~] = xlsread(file,data_start);
num1 = flipud(rot90(num1));
t = xlsread(file,time_start);
t = t'/60;
end