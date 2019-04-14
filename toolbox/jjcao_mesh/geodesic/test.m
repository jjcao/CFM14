faceIndex=zeros(size(faces,1),1); 
%i-th face���� faceIndex(i)-th cell;��faceIndex(i)Ϊ0���������κ�һ��cell
for i=1:nbr_landmarks
    vertIndex=find(Q(:,1)==i);  %��i��cell�ж���ı��
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