function D=compute_featureDist_wks(verts, faces, landmark)
[wks,e,eigvalue,eigvector] = compute_wks(verts,faces);
k=max(size(landmark,1),size(landmark,2));
D=zeros(size(verts,1),k);
for i=1:k
    D1=abs(wks-repmat(wks(landmark(i),:),size(wks,1),1));
    D2=abs(wks+repmat(wks(landmark(i),:),size(wks,1),1));
    D(:,i)=sum(D1./D2,2);
end
