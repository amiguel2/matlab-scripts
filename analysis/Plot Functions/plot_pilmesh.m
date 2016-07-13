% Tristan's Code to plot mesh, ie. cell contour and widths along cell
% length

figure;
for i = 1:length(frame)
    for j = 1:length(frame(i).object)


plot(frame(i).object(j).Xcont,frame(i).object(j).Ycont,'k-')
hold on;
plot(frame(i).object(j).centerline(:,1),frame(i).object(j).centerline(:,2),'b')
for k=1:size(frame(i).object(j).centerline,1)
     plot(frame(i).object(j).pill_mesh(k,1:2:3),frame(i).object(j).pill_mesh(k,2:2:4),'r')

end
axis equal tight
xlabel('X')
ylabel('Y')
hold off;
drawnow
pause(.1);
    end
end