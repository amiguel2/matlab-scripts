function matrix = convert2_96plate(data)
% convert from well index (1:96) to row/column format
if iscell(data)
    matrix = convert_cell(data);
else 
    matrix = convert_data(data);
end
   
end

function matrix = convert_data(data)
matrix = zeros(8,12);
count = 0;
for i = 1:8
    for j = 1:12
        count = count + 1;
        matrix(i,j) = data(count);
    end
end
end

function matrix = convert_cell(data)
matrix = cell(8,12);
count = 0;
for i = 1:8
    for j = 1:12
        count = count + 1;
        matrix(i,j) = data(count);
    end
end
end

        