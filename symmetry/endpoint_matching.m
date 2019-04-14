function sym=endpoint_matching(V,F,landmark1,landmark2,D1,D2,agd1,agd2,hks1,hks2,wks1,wks2,opts)
% Copyright (c) 2014.06 Shuhua Li 
% Based on the paper" Multiple Shape Correspondence by Dynamic Programming Approximation"

%input: length(landmark1)must be equal to length(landmark2).
%       agd,hks,wks must have been normalized.
%       D was normalized
%output:  Matching: every row is a matching
%         Distor:    the distortion of a matching
%         distor:     the points' distortion of a matching

% if length(landmark1)~=length(landmark2)
%     error('the number of landmarks must be equal.');
% end
%%
num1=length(landmark1); num2=length(landmark2);
D_landmark1=full(D1(landmark1,landmark1));
D_landmark2=full(D2(landmark2,landmark2));
tmpP=perms(1:num2);P=tmpP;j=1;
I=(1:num1);II=landmark1;
Distor=zeros(0,1);distor=zeros(0,num1);
wksDiff=zeros(0,num1); hksDiff=zeros(0,num1);agdDiff=zeros(0,num1);
for i=1:size(tmpP,1)
    J=tmpP(i,:);JJ=landmark2(J);J=J(1:num1);JJ=JJ(1:num1);
    agddiff=abs(agd1(II)-agd2(JJ));
    hksdiff=sum(abs(hks1(II,:)-hks2(JJ,:)),2)./(size(hks1,2));%可以改进
    wksdiff=sum(abs(wks1(II,:)-wks2(JJ,:)),2)./(size(wks1,2));%可以改进
% %     hksdiff= sum( abs( (hks1(II,:)-hks2(JJ,:))./(hks1(II,:)+hks2(JJ,:)) ),2 );
% %     wksdiff= sum( abs( (wks1(II,:)-wks2(JJ,:))./(wks1(II,:)+wks2(JJ,:)) ),2 );

        tmpdistor=zeros(num1,num1);tmpDistor=0;
        for k=1:num1
            tmpdistor(:,k)=(abs(D_landmark1(I(k),I)-D_landmark2(J(k),J)))';
            tmpDistor=tmpDistor+sum(tmpdistor(:,k))/(num1-1);
        end
        tmpDistor=tmpDistor/num1;
        tmpdistor=max(tmpdistor);
            Distor(end+1,1)=tmpDistor;
            distor(end+1,:)=tmpdistor;
            hksDiff(end+1,:)=hksdiff';
            wksDiff(end+1,:)=wksdiff';
            agdDiff(end+1,:)=agddiff';
end
%% 度量扭曲、特征差异的参数曲线 计算 fea
distor=max(distor,[],2);agdDiff=max(agdDiff,[],2);hksDiff=max(hksDiff,[],2);wksDiff=max(wksDiff,[],2);
if num1>2
x=(1:size(P,1))'; 
[fea,~]=sort(distor);[fea0,~]=sort(Distor);
[fea1,~]=sort(agdDiff);[fea2,~]=sort(hksDiff);[fea3,~]=sort(wksDiff);

N=size(P,1);n=min(119,N-1);
if opts.DEBUG
figure;subplot(3,5,1),bar(x(1:n),fea(1:n),'r');hold on;scatter(x(1:8),fea(1:8),50,[0,0,0],'filled');hold on;
       subplot(3,5,2),bar(x(1:n),fea0(1:n),'r');hold on;scatter(x(1:8),fea0(1:8),50,[0,0,0],'filled');hold on;
       subplot(3,5,3),bar(x(1:n),fea1(1:n),'g');hold on;scatter(x(1:8),fea1(1:8),50,[0,0,0],'filled');hold on;
       subplot(3,5,4),bar(x(1:n),fea2(1:n),'b');hold on;scatter(x(1:8),fea2(1:8),50,[0,0,0],'filled');hold on;
       subplot(3,5,5),bar(x(1:n),fea3(1:n),'c');hold on;scatter(x(1:8),fea3(1:8),50,[0,0,0],'filled');hold on;
end
%% 参数曲线的阈值的自动选取
%光顺曲线 fea_s
Im = repmat(fea/max(fea),1,10);S = L0Smoothing(Im,0.005);feas=S(:,1)*max(fea);
Im = repmat(fea0/max(fea0),1,10);S = L0Smoothing(Im,0.005);fea0s=S(:,1)*max(fea0);
Im = repmat(fea1/max(fea1),1,10);S = L0Smoothing(Im,0.005);fea1s=S(:,1)*max(fea1);
Im = repmat(fea2/max(fea2),1,10);S = L0Smoothing(Im,0.005);fea2s=S(:,1)*max(fea2);
Im = repmat(fea3/max(fea3),1,10);S = L0Smoothing(Im,0.005);fea3s=S(:,1)*max(fea3);
if opts.DEBUG
subplot(3,5,6),bar(x(1:n),feas(1:n),'r');hold on;scatter(x(1:8),feas(1:8),50,[0,0,0],'filled');hold on;
subplot(3,5,7),bar(x(1:n),fea0s(1:n),'r');hold on;scatter(x(1:8),fea0s(1:8),50,[0,0,0],'filled');hold on;
       subplot(3,5,8),bar(x(1:n),fea1s(1:n),'g');hold on;scatter(x(1:8),fea1s(1:8),50,[0,0,0],'filled');hold on;
       subplot(3,5,9),bar(x(1:n),fea2s(1:n),'b');hold on;scatter(x(1:8),fea2s(1:8),50,[0,0,0],'filled');hold on;
       subplot(3,5,10),bar(x(1:n),fea3s(1:n),'c');hold on;scatter(x(1:8),fea3s(1:8),50,[0,0,0],'filled');hold on;
end
% 求梯度 d
d=diff(feas);d0=diff(fea0s);d1=diff(fea1s);d2=diff(fea2s);d3=diff(fea3s);
Im = repmat(d/max(d),1,10);S = L0Smoothing(Im,0.00001);d=S(:,1)*max(d);
Im = repmat(d0/max(d0),1,10);S = L0Smoothing(Im,0.00001);d0=S(:,1)*max(d0);
Im = repmat(d1/max(d1),1,10);S = L0Smoothing(Im,0.00001);d1=S(:,1)*max(d1);
Im = repmat(d2/max(d2),1,10);S = L0Smoothing(Im,0.00001);d2=S(:,1)*max(d2);
Im = repmat(d3/max(d3),1,10);S = L0Smoothing(Im,0.00001);d3=S(:,1)*max(d3);
[pks,locs]=findpeaks(d(1:n));
[pks0,locs0]=findpeaks(d0(1:n));[pks1,locs1]=findpeaks(d1(1:n));
[pks2,locs2]=findpeaks(d2(1:n));[pks3,locs3]=findpeaks(d3(1:n));
if opts.DEBUG
subplot(3,5,11),bar(x(1:n),d(1:n),'r');hold on;scatter(x(locs),d(locs),100,[0,0,0],'filled');hold on;
subplot(3,5,12),bar(x(1:n),d0(1:n),'r');hold on;scatter(x(locs0),d0(locs0),100,[0,0,0],'filled');hold on;
    subplot(3,5,13),bar(x(1:n),d1(1:n),'g');hold on;scatter(x(locs1),d1(locs1),100,[0,0,0],'filled');hold on;
    subplot(3,5,14),bar(x(1:n),d2(1:n),'b');hold on;scatter(x(locs2),d2(locs2),100,[0,0,0],'filled');hold on;
    subplot(3,5,15),bar(x(1:n),d3(1:n),'c');hold on;scatter(x(locs3),d3(locs3),100,[0,0,0],'filled');hold on;
end
%阈值选为梯度的第一个极大值所对应的fea值
locs(locs==2)=[];locs0(locs0==2)=[];locs1(locs1==2)=[]; locs2(locs2==2)=[];locs3(locs3==2)=[];
if ~isempty(locs)
    t=max(fea(locs(1)),0.0005); index=find(~(distor>t));
else
    t=0.1;
end
if ~isempty(locs0)
    t0=max(fea0(locs0(1)),0.0005);index0=find(~(Distor>t0));
else
    t0=0.1;
end
if ~isempty(locs1)
    t1=max(fea1(locs1(1)),0.0005);index1=find(~(agdDiff>t1));
else 
    t1=0.1;
end
if ~isempty(locs2)
    t2=max(fea2(locs2(1)),0.0005);index2=find(~(hksDiff>t2));
else
    t2=0.2;
end
if ~isempty(locs3)
    t3=max(fea3(locs3(1)),0.0005);index3=find(~(wksDiff>t3));
else
    t3=0.3; 
end


else 
     t=0.1;t0=0.1;t1=0.1;t2=0.1;t3=0.1;
end
% distortion小于阈值的对应
idx=find(~((distor>t)+(Distor>t0)+(agdDiff>t1).*(hksDiff>t2).*(wksDiff>t3)));

[temp,I]=sort(distor(idx));idx=idx(I);

% for i=1:length(idx)
%     plot_sparse_corr(V,F,V,F,...
%         landmark1,landmark2(P(idx(i),(1:num1))),sprintf('sparse matching by Distor %i',i));
% end
Matching=landmark2(P(idx,(1:num1)));
% sym = zeros(0,2);
%% endpoint symmetry
sym=endpoint_symmetry(landmark1,Matching,D1);
%%
% figure;
%        subplot(2,3,1),bar(x(1:n),fea0(1:n),'g');axis([0 120 0 0.18]);hold on;scatter(x(1:4),fea0(1:4),10,[0,0,0],'filled');
%        xlabel('Mappings');ylabel('Average Distortion');hold on;
%        
%        subplot(2,3,4),bar(x(1:n),fea1(1:n),'c');axis([0 120 0 0.18]);hold on;scatter(x(1:4),fea1(1:4),10,[0,0,0],'filled');
%        xlabel('Mappings');ylabel('Differences of AGD');hold on;
%        
%        subplot(2,3,2),bar(x(1:n),fea0s(1:n),'g');axis([0 120 0 0.18]);hold on;scatter(x(1:4),fea0s(1:4),10,[0,0,0],'filled');
%        xlabel('Mappings');ylabel('Average Distortion (smoothed)');hold on;
%        
%        subplot(2,3,5),bar(x(1:n),fea1s(1:n),'c');axis([0 120 0 0.18]);hold on;scatter(x(1:4),fea1s(1:4),10,[0,0,0],'filled');
%        xlabel('Mappings');ylabel('Differences of AGD (smoothed)');hold on;
%        
%        subplot(2,3,3),bar(x(1:n),d0(1:n),'g');axis([0 120 0 0.06]);hold on;
%         xlabel('Mappings');ylabel('Gradient of Average Distortion (smoothed)');hold on;
%        scatter(x(locs0(1)),d0(locs0(1)),40,[1,0,0],'filled');hold on;
%        
%     subplot(2,3,6),bar(x(1:n),d1(1:n),'c');axis([0 120 0 0.06]);hold on;
%     xlabel('Mappings');ylabel('Gradient of Differences of AGD (smoothed)');hold on;
%     scatter(x(locs1(1)),d1(locs1(1)),40,[1,0,0],'filled');hold on;
    %% 
%        figure;bar(x(1:n),fea0s(1:n),'g');axis([0 120 0 0.18]);hold on;scatter(x(1:4),fea0s(1:4),100,[0,0,0],'filled');
%        xlabel('Mappings');ylabel('Average Distortion (smoothed)');hold on;
%        
%        figure;bar(x(1:n),fea1s(1:n),'c');axis([0 120 0 0.18]);hold on;scatter(x(1:4),fea1s(1:4),100,[0,0,0],'filled');
%        xlabel('Mappings');ylabel('Differences of AGD (smoothed)');hold on;
%        
%        figure;bar(x(1:n),d0(1:n),'g');axis([0 120 0 0.06]);hold on;
%         xlabel('Mappings');ylabel('Gradient of Average Distortion (smoothed)');hold on;
%        scatter(x(locs0(1)),d0(locs0(1)),100,[1,0,0],'filled');hold on;
%        
%     figure;bar(x(1:n),d1(1:n),'c');axis([0 120 0 0.06]);hold on;
%     xlabel('Mappings');ylabel('Gradient of Differences of AGD (smoothed)');hold on;
%     scatter(x(locs1(1)),d1(locs1(1)),100,[1,0,0],'filled');hold on;