function w = get_width_profile(mesh)
% width at each mesh point
w=sqrt((mesh(:,4)-mesh(:,2)).^2+(mesh(:,3)-mesh(:,1)).^2);
w = w(2:end-1);
end