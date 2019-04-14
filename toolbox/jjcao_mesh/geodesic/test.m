faceIndex=zeros(size(faces,1),1); 
%i-th face属于 faceIndex(i)-th cell;若faceIndex(i)为0，则不属于任何一个cell
for i=1:nbr_landmarks
    vertIndex=find(Q(:,1)==i);  %第i个cell中顶点的编号
    index=zeros(size(faces));
    for j=1:length(vertIndex)
        index=index+(faces==vertIndex(j));
    end
    faceIndex=faceIndex+i*(index(:,1).*index(:,2).*index(:,3));
end

%%
%% display mesh
figure('Name','Supervertex by NCut'); set(gcf,'color','white'); 
    options.face_vertex_color =faceIndex;
    h = plot_mesh(verts, faces, options);
%     set(h, 'edgecolor', 'none');
    colormap(jet(nbr_landmarks)); 
    view3d rot; lighting none;