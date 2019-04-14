function [L,L0,diff] = constructL(maximaIndex,descriptor)
% Copyright (c) 2013 Shuhua Li

L0 = zeros(0,2);L = zeros(0,2); diff=zeros(0,1);
if length(maximaIndex)>1
    
for i = 1:size(maximaIndex,1)
%     D1=abs(repmat(descriptor(i,:),size(descriptor,1),1) - descriptor);
%     D2=abs(repmat(descriptor(i,:),size(descriptor,1),1) +descriptor);
%     dist=sum(D1./D2,2);
    dist = sqrt(sum((repmat(descriptor(i,:),size(descriptor,1),1) - descriptor).^2,2));
    [dist,pos]=sort(dist);
    L0(end+1,1) = i;
    L0(end,2) = pos(2);
    L(end+1,1) = maximaIndex(i);
    L(end,2) = maximaIndex(pos(2));
    diff(end+1,1)=dist(2);
end

else 
   ;
end
    
