function plot_descriptor(V,F,f,string)
% Copyright (c) 2014.03.30 Shuhua Li

for i=1:size(f,2)
    figure('name',string); set(gcf,'color','white');
    options.face_vertex_color=f(:,i);
    h = plot_mesh(V, F, options); view3d rot;
    set(h, 'edgecolor', 'none'); %set(h, 'FaceAlpha', 1); 
    axis off; axis equal; colormap jet;
end