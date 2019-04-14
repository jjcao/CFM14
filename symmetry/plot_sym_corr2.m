function plot_sym_corr2(V,F,f,line1,line2,string)
figure('name',string); set(gcf,'color','white');
options.alfa = 0.1;
idx0=find(f==0); idx1=find(f==1); idx2=find(f==2);
idx3=find(f==3);idx4=find(f==4);
c=zeros(size(f,1),3);c(idx0,2)=ones(length(idx0),1);
c(idx1,1)=0.4*ones(length(idx1),1);c(idx2,1)=ones(length(idx2),1);
c(idx3,3)=0.4*ones(length(idx3),1);c(idx4,3)=ones(length(idx4),1);
options.face_vertex_color=c;
h = plot_mesh(V, F, options); 
set(h, 'edgecolor', 'none'); set(h, 'FaceAlpha', 0.6); %colormap jet(256);
hold on;axis off; axis equal;

% x = [ V(line1,1)';(V( line2,1))'];
% y =  [ V( line1,2)';(V( line2,2))'];
% z =  [ V( line1,3)';(V( line2,3))'];
% h = line(x,y,z, 'LineWidth', 2,'Color',[0 0 0]);
% hold on;

% scatter3(V( line1,1),V( line1,2), V( line1,3), 150,[0,0,0],'filled');
% scatter3(V( line2,1),V( line2,2), V( line2,3), 150,[0,0,0],'filled');
% colormap Lines; 