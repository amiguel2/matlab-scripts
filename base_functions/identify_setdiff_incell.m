function idx = identify_setdiff_incell(A,B)
idx = zeros(numel(A),1);
for i = 1:numel(idx)
    idx(i) = ~any(strcmp(A{i},B));
end
idx = logical(idx);
end