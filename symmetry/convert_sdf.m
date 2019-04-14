function vert_sdf=convert_sdf(V,F,face_sdf)

% Copyright (c) 2013 Shuhua Li
nverts=size(V,1);
faceIdx_of_v=cell(nverts,1);
for i=1:size(F,1)
    faceIdx_of_v{F(i,1)}(end+1)=i;
    faceIdx_of_v{F(i,2)}(end+1)=i;
    faceIdx_of_v{F(i,3)}(end+1)=i;
end
%%
vert_sdf=zeros(nverts,1);
for i=1:nverts
    vert_sdf(i)=mean(face_sdf(faceIdx_of_v{i}));
end