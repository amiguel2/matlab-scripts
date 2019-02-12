function []=resubplot(n,m,k,oldfig,newfig,ax)
% IO:
% resubplot(n,m,k,f);
% n,m,k corresponding to new subplot(n,m,k)
% oldfig corresponing to original
% newfig corresponds to new figure
% ax corresponds to new figure axes
% Please note don't work with subplots where
% suptitle have been used
%
% modified from unsubplot by Anders Björk 2000-08-30



h = get(oldfig,'Children');
figure(newfig)
newh = copyobj(h,newfig.Number);

for j = 1:length(newh)
        posnewh = get(newh(j),'Position');
        possub  = get(ax(k),'Position');
        set(newh(j),'Position',...
            [possub(1)+(possub(3)*posnewh(1)) possub(2)+(possub(4)*posnewh(2)) possub(3)*posnewh(3) possub(4)*posnewh(4)])

end

delete(ax(k));