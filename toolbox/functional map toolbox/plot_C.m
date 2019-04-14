function [] = plot_C(Fun,string)
% 
%
%   Copyright (c) Shuhua Li, JJCAO 2013

% Index = abs(C)<0.11;C1=C;C1(Index)=0;
% Id = C'*C;
% Index = abs(Id)<0.11;
% Id1=Id;Id1(Index)=0;

figure('name',string);
n = length(Fun);
for i=1:n
    subplot(1,n,i); imshow(Fun{i},[]);colormap(jet);%title(Fun{i,2});
end