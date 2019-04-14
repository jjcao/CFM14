function [L,dist]=delete_by_feature(L,fea,opts)
% input :sample_d was not normalized.
% output :sample_d_ori was not normalized.
descriptor1=fea(L(:,1),:);
descriptor1 = descriptor1./repmat(sqrt(sum(descriptor1.^2,2)),1,size(descriptor1,2));
descriptor2=fea(L(:,2),:);
descriptor2 = descriptor2./repmat(sqrt(sum(descriptor2.^2,2)),1,size(descriptor2,2));

dist=zeros(size(L,1),1);
for i=1:size(L,1)
    dist(i) = sqrt(sum((descriptor1(i,:) - descriptor2(i,:)).^2,2));
end

I=dist>opts.fea_diff;
L(I,:)=[];dist(I)=[];