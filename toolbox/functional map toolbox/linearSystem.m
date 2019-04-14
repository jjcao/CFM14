function C=linearSystem(A,B,S,R)
%Incorporate CA=B、CS=RC into a linear system
%T:M到N 的双射，C为T对应的函数映射矩阵.
%想要求得C,s.t.CA=B,CS=RC.
%这里用的交换性为Laplace 算子的交换性，S为M对应的特征值形成的对角阵，R对应N.
%% CA=B。C，B按行展成列向量得BigA*Cvec=Bvec
[n,k]=size(A);
Bvec=reshape(B',numel(B),1);
%% BigA
BigA=spalloc(k*n,n^2,k*n^2);
l=1;
for i=1:n
    for j=1:n
        BigA(:,l)=[zeros(1,i*k-k) A(j,:) zeros(1,k*n-i*k)]';
        l=l+1;
    end
end

%% CS=RC. C按行展成列向量BigS*Cvec=BigR*Cvec
Sdiag=diag(S,0);
Rdiag=diag(R,0);
S=[];R=[];
for i=1:n
    S=[S Sdiag'];
    R=[R Rdiag(i)*ones(1,n)];
end
%%    
BigS=sparse(1:n^2,1:n^2,S',n^2,n^2);
BigR=sparse(1:n^2,1:n^2,R',n^2,n^2);

%% Incorporate into a linear system X*Cvec=Y
Y=spalloc(k*n+n^2,1,k*n);
Y(:,1)=[Bvec',zeros(1,n^2)]';
%%
X=spalloc(k*n+n^2,n^2,k*n^2+2*n^2);
for i=1:n^2
    X(:,i)=[BigA(:,i)' (BigS(:,i)-BigR(:,i))']';
end
%%
Cvec=X\Y;
%% 将列向量Cvec恢复成阵C
Cspa=reshape(Cvec,n,n);
C=full(Cspa);
C=C';
