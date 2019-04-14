% compute L-B eigen,hks,wks,agd,(phi)
% Copyright (c) 2013 Shuhua Li

function M=compute_feature(meshname,nbasis,nhks,nwks,opts)

if ~isfield(opts, 'hks')
    opts.hks =1;
end
if ~isfield(opts, 'wks')
    opts.wks =1;
end
if ~isfield(opts, 'agd')
    opts.agd =1;
end
if ~isfield(opts, 'phi')
    opts.phi =0;
end
if ~isfield(opts, 'areaNormal')
    opts.areaNormal =false;
end
if ~isfield(opts, 'normalize')
    opts.normalize =false;
end
M.filename = meshname;
[M.verts,M.faces] = read_mesh(M.filename);
M.nverts = size(M.verts,1);
M.faceArea = compute_area_faces(M.verts, M.faces);
M.verts= M.verts/ sqrt(sum(M.faceArea)); % normalization
%% Compute laplaceEigen
withAreaNormalization = opts.areaNormal; adjustL=true;
[M.eigvector,M.eigvalue,M.vertexArea,~]=compute_Laplace_eigen(M.verts,M.faces,nbasis+20,withAreaNormalization,adjustL);
[M.eigvalue,I,~]=unique(M.eigvalue);
M.eigvector=M.eigvector(:,I);
M.eigvalue=M.eigvalue(1:nbasis);
M.eigvector=M.eigvector(:,1:nbasis);
%% HKS & WKS
if opts.hks
    M.hks = HKS(M.eigvector, M.eigvalue, M.vertexArea, nhks,opts.areaNormal);
    if opts.normalize
        M.hks=normalization(M.hks);
    end
end
if opts.wks
    M.wks = WKS(M.eigvector, M.eigvalue,nwks);
    if opts.normalize
        M.wks=normalization(M.wks);
    end
end
%% AGD
if opts.agd
    if ~isfield(opts, 'dijkstra')
    opts.dijkstra =true;
    end
    %disp('   Computing agd :')
    M.agd = compute_agd(M.verts,M.faces,150, opts);
end
%% compute conformal factor
if opts.phi
    Mhe = to_halfedge(M.verts, M.faces);
    boundary = Mhe.boundary_vertices;
    if iscell(boundary)
        boundary=cell2mat(boundary)';
    end
    options.type = 'normal cycle';
    options.boundary = boundary;
    M.phi = compute_conformal_factor(M.verts, M.faces, options); 
    if opts.normalize
        M.phi=normalization(M.phi);
    end
end