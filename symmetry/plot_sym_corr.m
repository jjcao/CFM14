function plot_sym_corr(V,F,line1,line2,string)
figure('name',string); set(gcf,'color','white');
options.alfa = 0.1;
h = plot_mesh(V, F, options); 
set(h, 'edgecolor', 'none'); set(h, 'FaceColor', 'white');
set(h, 'FaceAlpha', 0.6); 
hold on;

x = [ V(line1,1)';(V( line2,1))'];
y =  [ V( line1,2)';(V( line2,2))'];
z =  [ V( line1,3)';(V( line2,3))'];
h = line(x,y,z, 'LineWidth', 2.5,'Color',[0 0.3 1]);
hold on;

scatter3(V( line1,1),V( line1,2), V( line1,3), 50,[0,0,0],'filled');
scatter3(V( line2,1),V( line2,2), V( line2,3), 50,[0,0,0],'filled');
axis off; axis equal;view3d rot;
% colormap Lines; 
%  figure('Name','groundTruth'); movegui('southeast'); set(gcf,'color','white');
%         options.face_vertex_color = temp_label;%/label_number;
% %                         options.face_vertex_color = mesh{i}.faces_label;
%         h = plot_mesh(mesh{i}.verts, mesh{i}.faces, options);view3d rot;
%         set(h, 'edgecolor', 'none'); 
%         map = [0 0 1 ;0 1 1; 1 1 0 ;1 0 0; 0 1 0];%map = [0.7 0.8 0.8; 1 0.5 0.3 ];
%         colormap(map); % lighting none;