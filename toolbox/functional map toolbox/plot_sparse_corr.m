function plot_sparse_corr(V1,F1,V2,F2,line1,line2,string,...
    index_error,index_sym)
figure('name',string); set(gcf,'color','white');
options.face_vertex_color=ones(size(V1));
h = plot_mesh(V1, F1, options); 
set(h, 'edgecolor', 'none'); %set(h, 'FaceColor', 'white'); 
set(h, 'FaceAlpha', 0.6); hold on;

options.face_vertex_color=ones(size(V2));
h = plot_mesh(V2+0.4, F2, options); 
set(h, 'edgecolor', 'none'); %set(h, 'FaceColor', 'white'); 
set(h, 'FaceAlpha', 0.6); hold on;axis off; axis equal;
x = [ V1(line1,1)';(V2( line2,1)+0.4)'];
y =  [ V1( line1,2)';(V2( line2,2)+0.4)'];
z =  [ V1( line1,3)';(V2( line2,3)+0.4)'];
h = line(x,y,z, 'LineWidth', 2,'Color',[0,1,0]);
scatter3(V1( line1,1),V1( line1,2), V1( line1,3), 50,[0,1,0],'filled');
scatter3(V2( line2,1)+0.4,V2( line2,2)+0.4, V2( line2,3)+0.4, 50,[0,1,0],'filled');
% scatter3(V2( line1,1)+0.4,V2( line1,2)+0.4, V2( line1,3)+0.4, 50,[0,1,0],'filled');

if nargin > 7
    line1_ = line1(index_error); line2_ = line2(index_error);
    x = [ V1(line1_,1)';(V2( line2_,1)+0.4)'];
    y =  [ V1( line1_,2)';(V2( line2_,2)+0.4)'];
    z =  [ V1( line1_,3)';(V2( line2_,3)+0.4)'];
    h = line(x,y,z, 'LineWidth', 2,'Color',[1,0,0]);
    scatter3(V1( line1_,1),V1( line1_,2), V1( line1_,3), 50,[1,0,0],'filled');
    scatter3(V2( line2_,1)+0.4,V2( line2_,2)+0.4, V2( line2_,3)+0.4, 50,[1,0,0],'filled');
end

if nargin > 8 
    line1_ = line1(index_sym); line2_ = line2(index_sym);
    x = [ V1(line1_,1)';(V2( line2_,1)+0.4)'];
    y =  [ V1( line1_,2)';(V2( line2_,2)+0.4)'];
    z =  [ V1( line1_,3)';(V2( line2_,3)+0.4)'];
    h = line(x,y,z, 'LineWidth', 2,'Color',[0,0,1]);
    scatter3(V1( line1_,1),V1( line1_,2), V1( line1_,3), 50,[0,0,1],'filled');
    scatter3(V2( line2_,1)+0.4,V2( line2_,2)+0.4, V2( line2_,3)+0.4, 50,[0,0,1],'filled');
end