%split_ome_stack.m
mkdir('images')
folder = [pwd '/'];
outfolder=[folder 'images/'];
convert_ome_to_stack('folder',folder,'outfolder',folder)

