function maximal_d = maximal_d(V,F,agd,method)


[maxIdx, minIdx] = extrema(F,agd, 1, 1.0);
v = [maxIdx;minIdx];
d = zeros(size(V,1),length(v));

switch method
    case 'marching'
        options.nb_iter_max = Inf;
        for i = 1:length(v)
            [d(:,i),~,~]= perform_fast_marching_mesh(V,F, v(i), options);
        end
    case 'dijkstra'
        A = triangulation2adjacency(F);
        ind = find(A>0);
        [I, J] = ind2sub(size(A), ind);
        dist2 = sum((V(I,:) - V(J,:)).^2, 2);
        W = sparse(I,J, sqrt(dist2) );
        d = perform_dijkstra_fast(W, v)';
    otherwise
        error('undefined method');
end

maximal_d=max(max(d));