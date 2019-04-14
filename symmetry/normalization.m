function g=normalization(f)
% Copyright (c) 2013 Shuhua Li
tmp=max(abs(f));
tmp=repmat(tmp,size(f,1),1);
g=f./tmp;