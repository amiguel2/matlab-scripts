%%% Makes a 3D plot of length, width and time. 
%%% Written for analysis of Cephalexin-treated E. Coli
%%% By Amanda Miguel 12-19-12


figure;
if frame(1,end).num_cells == 0
    count = 1;
    c = 0;
while c == 0
    if frame(1,end-count).num_cells ~= 0
        a = length(frame(1,end-count).object(1).width);
        b = length(frame);
        c = 1;
    end
    count = count +1;
end
width = nan(a,b);
else
    a = length(frame(1,end).object(1).width);
    b = length(frame);
end

for i = 1:length(frame)
    if frame(1,i).num_cells ~= 0
    s = size(frame(1,i).object(1).width,1);
    width(1:s,i) = frame(i).object(1).width;
    else
        width(1:s,i) = NaN;
    end
end
width = width*.08;
subplot(1,2,1)
surf(width)
zlim([0.5,1]);
shading interp;
subplot(1,2,2)
contourf(width);
