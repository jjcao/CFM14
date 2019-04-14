function landmark_sym=endpoint_symmetry(landmark,Matching,D)
% Copyright (c) 2013 Shuhua Li
%D was normalized
landmark_sym=[];
for i=1:length(landmark)
    v1=landmark(i);
    v2=Matching(:,i);
    d=full(D(v1,v2));
    [val,I]=max(d);
    if val>1.0000e-06
        landmark_sym=[landmark_sym;v1,v2(I)];
    end
end
I=landmark_sym(:,1)>landmark_sym(:,2);
tmp=landmark_sym(I,1);
landmark_sym(I,1)=landmark_sym(I,2);
landmark_sym(I,2)=tmp;
landmark_sym=unique(landmark_sym,'rows');
% landmark=[landmark_sym(:,1)' landmark_sym(:,2)']';
% [~,p1]=ismember(landmark_sym(:,1),landmark);
% [~,p2]=ismember(landmark_sym(:,2),landmark);
% p=[p1,p2];