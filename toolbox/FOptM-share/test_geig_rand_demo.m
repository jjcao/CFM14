function test_geig_rand_demo

%-------------------------------------------------------------
% A demo of solving
%   min f(X), s.t., X'*M*X = I, where X is an n-by-p matrix
%
%  This demo solves the eigenvalue problem by letting
%  f(X) = -0.5*Tr(X'*A*X);
clc;clear all;
A = [ 1 -1 1; -1 2 0; 1 0 3]; %A是对称矩阵
B = [5 2 -4;2 1 -2;-4 -2 5]; % B是 Hermitian 正定方阵

G = chol(B,'lower');
S = inv(G)*A*inv(G)';
[V, D1] = eig(S);
V1 = inv(G)'*V;   %V1中的各个列是 Ax = λBx 的特征向量
ierror1=V1'*B*V1-eye(size(B));
derror1=V1'*A*V1-D1;
f1=-0.5*sum(dot(V1,A*V1,1));

opts.record = 0;
opts.mxitr  = 5000;
opts.xtol = 1e-5;
opts.gtol = 1e-5;
opts.ftol = 1e-8;
out.tau = 1e-3;
V0=rand(size(V1));
V0= MGramSchmidt_m(V0,B);
ierror2=V0'*B*V0-eye(size(B));
[V2,f2,out]= OptStiefelGBBM(V0,B,@funeig, opts, A)
ierror3=V2'*B*V2-eye(size(B));
ferror=f1-f2;
verror=V1-V2;
    function [F, G] = funeig(V,  A)
        
        G = -(A*V);
        %F = 0.5*sum(sum( G.*X ));
        F = 0.5*sum(dot(G,V,1));
        % F = sum(sum( G.*X ));
        % G = 2*G;clc   
    end


end
