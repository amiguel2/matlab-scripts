function result = extractGompertzfitresult(data,paramtype)
result = cellfun(@(x) x.(paramtype),data);
end

