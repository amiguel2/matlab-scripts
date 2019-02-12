mkdir('stacks');
for j=1:14
    cd(['Pos',int2str(j)]);
    output = '../stacks/Pos';
    if j<10
        output = [output,'0'];
    end
    output = [output,int2str(j),'.tif'];
    make_tiffstack('*Phase*',output);
    cd ..
end
