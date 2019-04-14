function V = MGramSchmidt_m(V,M)
[n,k] = size(V);

for dj = 1:k
    for di = 1:dj-1
        V(:,dj) = V(:,dj) - proj(V(:,di), V(:,dj),M);
    end
    V(:,dj) = V(:,dj)/sqrt(dot(V(:,dj),M*V(:,dj)));
end
end


%project v onto u
function v = proj(u,v,M)
v = (dot(v,M*u)/dot(u,M*u))*u;
end
