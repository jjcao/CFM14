function idx= evaluate_C(C, verts, faces, eigvector)
% 
%
%   Copyright (c) Shuhua Li, JJCAO 2013

% display functional map C
plot_C(C);

%% compute T
idx=init_correspondence(eigvector,eigvector,C);

%% show result
plot_corr_result(verts,faces,idx); % plot dense correspondence
%% plot sparse correspondence
nverts = size(verts,1);
corres = randi(nverts,80,1);
corres = [corres, idx(corres)];
figure('name','symmetry points'); set(gcf,'color','white');hold on;
h=trisurf(faces, verts(:,1), verts(:,2), verts(:,3), 'FaceColor', 'cyan',  'faceAlpha', 0.4); axis off; axis equal; mouse3d    
set(h, 'edgecolor', 'none'); 
h = plot_edges(corres, verts);



%% compute geometric error
% disp('5. Computing geometric error');
% [avg_error, sample_error]=compute_corError(M2.verts,M2.faces,idx);

%%  save data
% disp('6. Save data');
% corr.filename=sprintf('correspondence of %s and %s',name1,name1);
% corr.C=C;
% corr.idx=idx;
% corr.avg_error=avg_error;
% corr.sample_error=sample_error;
% save(sprintf('corr_%s_%s_%s.mat',name1,name1,METHOD),'-struct','corr');