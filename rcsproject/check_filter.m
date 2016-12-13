function [pass]= check_filter(f,cid,varargin)

kupper = 0.2;
klower = -0.1;
arealower = 75;

if nargin == 0
    fprintf('Usage: get_data(list,tframe,pxl,[optional]...)\n')
    fprintf('Options: ''kupper'',''klower'',''arealower''')
    fprintf('Example: check_filter(f,cid,''kupper'',0.02)\n')
    return
end

if f.frame

end

