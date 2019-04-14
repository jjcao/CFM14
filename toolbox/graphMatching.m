function [M,L]= graphMatching(L0,D1,D2,descriptor1,descriptor2,ind)
m=size(L0,1);
M=zeros(m,m);
for i = 1:m
   for j = 1:m
        tmp= abs(D1(L0(i,1),L0(j,1)) - D2(L0(i,2),L0(j,2)));
        M(i,j) =exp(-(tmp^2)); 
        if L0(i,1) == L0(j,1) || L0(i,2) == L0(j,2)
            M(i,j) = 0;
        end
    end
end
tmp = zeros(m,1);
for i = 1:size(L0,1)
    tmp(i) =  max(abs(descriptor1(L0(i,1),:) - descriptor2(L0(i,2),:)));
end
tmp = tmp / max(tmp);
 M = M + 2*diag(exp(-tmp.^2));
 
 %ind-number of best correpondence
[X,out] = use_Opt(M,1);
x_initial = X;
[~,index] = max(abs(x_initial));
if x_initial(index) < 0 
    x_initial = x_initial *(-1);
end
L=zeros(0,2);
for i=1:ind
[~,in] = max(x_initial);
L(end+1,:)= L0(in,:);
x_initial(in) = 0;
  for j = 1:length(X)
      if L0(j,1) == L0(in,1)|| L0(j,2) == L0(in,2)
        x_initial(j) = 0;
      end 
  end
end

