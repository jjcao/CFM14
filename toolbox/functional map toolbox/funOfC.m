function [F,G]=funOfC(C,A,B,S,R)

lambda=0.01;
F=0.5*(sum(dot(C*A-B,C*A-B,1))+lambda*sum(dot(C*S-R*C,C*S-R*C,1)));
G=C*A*A'-B*A'+lambda*(C*S*S'-R'*C*S-R*C*S'+R'*R*C);
% F=0.5*sum(dot(C*A-B,C*A-B,1));
% G=C*A*A'-B*A';
end 