function [num1,t] = readEpochdata(file,varargin)

% Default 
data_start = 'C35:CT240';
time_start = 'A35:A240';

if numel(varargin) > 0
    data_start = varargin{1};
end
if  numel(varargin) > 1
    time_start = varargin{2};
end

[num1,~,~] = xlsread(file,data_start);
N = size(num1);
t = xlsread(file,time_start);
t = t(1:N(1))*24*60';
end