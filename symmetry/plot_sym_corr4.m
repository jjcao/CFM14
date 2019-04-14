function plot_sym_corr4(V,F,corr,index,string)

figure('name',string); set(gcf,'color','white');
options.alfa = 0.1;
h = plot_mesh(V, F, options); 
set(h, 'edgecolor', 'none'); set(h, 'FaceColor', 'white');set(h, 'FaceAlpha', 0.6); 
hold on;axis off; axis equal;

line1=corr(~index,1);line2=corr(~index,2);
x = [ V(line1,1)';(V( line2,1))'];
y =  [ V( line1,2)';(V( line2,2))'];
z =  [ V( line1,3)';(V( line2,3))'];
h = line(x,y,z, 'LineWidth', 2.5,'Color',[0 1 0]);
hold on;
stableIdx=line1==line2;
scatter3(V( line1(stableIdx),1),V( line1(stableIdx),2), V( line1(stableIdx),3), 150,[0,1,0],'filled');

line1=corr(index,1);line2=corr(index,2);
x = [ V(line1,1)';(V( line2,1))'];
y =  [ V( line1,2)';(V( line2,2))'];
z =  [ V( line1,3)';(V( line2,3))'];
h = line(x,y,z, 'LineWidth', 3,'Color',[1 0 0]);
hold on;
stableIdx=line1==line2;
scatter3(V( line1(stableIdx),1),V( line1(stableIdx),2), V( line1(stableIdx),3), 150,[1,0,0],'filled');
% scatter3(V( line1,1),V( line1,2), V( line1,3), 50,[0,0,1],'filled');
% scatter3(V( line2,1),V( line2,2), V( line2,3), 50,[0,0,1],'filled');
% colormap Lines; 





