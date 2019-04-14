function [avg_error, sample_error]=compute_corError(verts2,faces2,idx)
%T:M-N, M=<verts1,faces1>, N=<verts2,faces2>
num=size(idx,1);
f_our=zeros(num,2);
f_true=zeros(num,2);
s=1:num;    s=s';
f_our(:,1)=s;  f_our(:,2)=idx;
f_true(:,1)=s; f_true(:,2)=s;
[avg_error, sample_error] = CorError(verts2,faces2, f_our, f_true);
