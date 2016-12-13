function SA = sarea_from_mesh(mesh, centerline)

% mesh result gives parallel lines from two sides of the contour
% centerline is the coordinates of center for each parallel set of mesh
% for each circular truncated cone, the lateral surface area is L = ( r1 +
% r2 ) * ? * s, where s = ? (r1 - r2)² + h² 

    
    SA = 0;
    r = zeros(1, size(mesh, 1));
    for i = 1 : size(mesh, 1)
        r(i) = mesh_dist(mesh(i, :)) / 2;
    end
    
    for i = 2 : size(mesh, 1)
        r1 = r(i - 1);
        r2 = r(i);
        h = centerline_dist(centerline(i - 1, :), centerline(i, :));
        SA = SA + cirTrunConL(r1, r2, h);
    end
end




function y = mesh_dist(meshline)
% returns the length of a meshline
    x1 = meshline(1);
    x2 = meshline(3);
    y1 = meshline(2);
    y2 = meshline(4);
    y = sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2);
end

function y = centerline_dist(centerlineentry1, centerlineentry2)
    % returns the length of a centerline entry
    x1 = centerlineentry1(1);
    y1 = centerlineentry1(2);
    x2 = centerlineentry2(1);
    y2 = centerlineentry2(2);
    y = sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2);
end

function y = cirTrunConslantheight(r1, r2, h)
    y = sqrt((max(r1,r2)-min(r1,r2))^2 + h^2);
end 

function y = cirTrunConL(r1, r2, h)
    s = cirTrunConslantheight(r1, r2, h);
    y = (r1 + r2)*pi*s;
end 