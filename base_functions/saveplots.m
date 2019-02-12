function saveplots(fileprefix)
eval(sprintf('export_fig %s.pdf -nocrop',fileprefix) )
savefig([fileprefix '.fig'])
end