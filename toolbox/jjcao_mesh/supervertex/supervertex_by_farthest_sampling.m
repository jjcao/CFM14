function [face_patch,vert_patch,patch_area,landmark]=supervertex_by_farthest_sampling(verts,faces,nbr_landmarks)
% 
% Input: verts
%        faces
%        nbr_landmark�� number of supervertex
         
% Output: agd
%         landmark, the index of center vertex of each patch
%         patch_area, the area of each patch
%         face_patch, face_patch(i) = j means that the ith face is blong to patch j
% 
% Pipeline��
% 1. ���������landmark
% 1.1 ����perform_farthest_point_sampling_mesh.m
% 2. ����voronoi patch���õ�ÿ����������һ��������Q
% 2.1 ���� computer_voronoi_mesh �ú����ֵ���
% 2.1.1 check_face_vertex.m �� perform_fast_marching_mesh.m
% 3. ���� face_patch���õ�ÿ���������Ǹ�������
% 4. ����cellArea,�õ�ÿ���������Ӧ��cell�����
%
% Copyright (c) 2013 Shuhua Li, Junjie Cao

DEBUG = 0;

%% compute voronoi mesh
nverts = size(verts,1);
options.W = ones(nverts,1); % the speed function, for now constant speed to perform uniform remeshing
landmark = perform_farthest_point_sampling_mesh(verts,faces,[],nbr_landmarks,options);% perform the sampling of the surface
[Q,DQ, voronoi_edges] = compute_voronoi_mesh(verts,faces, landmark); %  i-th �������� Q(i)-th landmark

vert_patch = Q(:,1);
%% display voronoi patch
if DEBUG
    options.voronoi_edges = voronoi_edges;
    options.start_points = landmark;
    figure('name','voronoi');
    plot_fast_marching_mesh(verts,faces, Q(:,1), [], options); 
    view3d zoom;
end

%% ����ÿ��face������һ��cell
%i-th face���� faceIndex(i)-th cell;��faceIndex(i)Ϊ0���������κ�һ��cell
face_patch=zeros(size(faces,1),1);

%% ����2-3����������b_i��face���� cell_i
for i=1:nbr_landmarks           % cell_i
    vertIndex=find(Q(:,1)==i);  %����cell_i �Ķ���ı�ţ�������
    % indexTemp:  nfaces*3 ��index1(s,t)=1,�򶥵�faces(s,t)�� cell_i�У�����Ϊ0
    indexTemp=zeros(size(faces));  
    for j=1:length(vertIndex)   
        indexTemp=indexTemp+(faces==vertIndex(j));
    end
    %index_3p�� 3�����㶼��cell_i�е�face���,������
    index_3p=find(indexTemp(:,1).*indexTemp(:,2).*indexTemp(:,3)); 
    indexTemp(index_3p,:)=0;
    %index_2p: 2�����㶼��cell_i�е�face���,������
    index_2p=find(indexTemp(:,1).*indexTemp(:,2)+indexTemp(:,1).*indexTemp(:,3)+indexTemp(:,2).*indexTemp(:,3));
    face_patch(index_3p)=i;
    face_patch(index_2p)=i;
end

%% 3���������ڲ�ͬ��landmark b��face,����face�����ĵ�3�������Ӧ�Ĳ�����������face�����ĸ�cell
index_1p=find(face_patch==0);    %3���������ڲ�ͬ��landmark b��face���
for i=1:size(index_1p)          %��index_1p(i)��face
    triIndex=faces(index_1p(i),:); %face��3�������� 3*1
    triVerts=verts(triIndex,:);   %face��3���������� 3*3
    faceCenter=sum(triVerts)/3;   %face����������
    distTriVerts=zeros(3,1);              %face��3�����㵽���ĵľ��� 3*1
    for j=1:3
    distTriVerts(j)=sum((triVerts(j,:)-faceCenter).^2);
    end
    dist=distTriVerts+DQ(triIndex,1);
%     idx=find(dist==min(dist));    %face�����ĸ�����
    [~,idx]= min(dist);
    face_patch(index_1p(i))=Q(triIndex(idx)); %face�����ĸ�cell
end   

%% display cell
if DEBUG
    figure('Name','cell'); set(gcf,'color','white'); 
    options.face_vertex_color =face_patch;
    h = plot_mesh(verts, faces, options);
    colormap(jet(nbr_landmarks));     view3d rot; lighting none;    hold on;
%  display landmarks
    ms=25;
   for i=1:nbr_landmarks
       cellCenter= verts(landmark(i),:);
       h = plot3( cellCenter(1),cellCenter(2), cellCenter(3), 'r.');
       set(h, 'MarkerSize', ms);    
   end
end

%% compute area(b_i)
patch_area=zeros(nbr_landmarks,1);  %cell_i�����Ϊ patch_area(i)
for i=1:nbr_landmarks           % cell_i
    index2=find(face_patch==i);  %cell_i ����ı�ţ�������
    cellFaces=faces(index2,:);  %cell_i ����
    A = cross(verts(cellFaces(:,2),:)- verts(cellFaces(:,1),:), verts(cellFaces(:,3),:)- verts(cellFaces(:,1),:)); %���
    patch_area(i) = sum(0.5 * sqrt(A(:,1).^2+A(:,2).^2+A(:,3).^2));  %���
end
