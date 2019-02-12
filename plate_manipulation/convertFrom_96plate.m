function data = convertFrom_96plate(matrix)

N = size(matrix);
count = 0;
for i = 1:N(1)
    for j = 1:N(2)
        count = count + 1;
        data(count) = matrix(i,j);
    end
end
   
end


        