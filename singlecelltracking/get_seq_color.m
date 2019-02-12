function c = get_seq_color(c0,N)
    c1 = abs(c0+0.6); 
    c1(c1>1) = 1;
    c2 = [0 0 0];
    N1 = N/3;
    N2 = N-N1;
    
%     c = spread_color(c1,c2,N);
    c = abs([flipud(spread_color(c0,c1,N1));spread_color(c0,c2,N2)]);

end

function c = spread_color(c0,c1,n)
c = [];
for i = 1:n
    c = [c; c0+(c1-c0)*(i-1)/(n-1)];
end

end
