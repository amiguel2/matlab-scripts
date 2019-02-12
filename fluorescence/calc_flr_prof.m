function flr = calc_flr_prof(ob)
% restructure calc_flr to fit mesh coordinates
warning('off','MATLAB:colon:nonIntegerIndex')
flr = {};
for j = 1:numel(ob.flr_profile)
    x = ob.flr_profile{j}';
    temp = x(1:(end/2))+[x(1+end/2:end)];
    temp = interp1(1:numel(temp),temp,linspace(1,numel(temp),numel(temp)*2));
    flr = [flr temp(1:numel(ob.int_fluor{j}))'];
end
end