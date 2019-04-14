function [X_smacof,hist_smacof] = use_mds(D,V,Index,dim,options)
%Fangfang Qiu

% Demonstration of multidimensional scaling with reduced rank extrapolation (RRE) 
% and multigtid (MG) acceleration
%
% References:
%
%  [1] G. Rosman, A. M. Bronstein, M. M. Bronstein, A. Sidi, R. Kimmel,
%  "Fast multidimensional scaling using vector extrapolation", Techn. Report CIS-2008-01, 
%  Dept. of Computer Science, Technion, Israel, January 2008.
%
%  [2] G. Rosman, M. M. Bronstein, A. M. Bronstein, and R. Kimmel,
%  "Topologically constrained isometric embedding", Human Motion - Understanding, 
%  Modeling, Capture and Animation, Computational Imaging and Vision, Vol. 36, Springer, 2008.
%
%  [3] M. M. Bronstein, A. M. Bronstein, R. Kimmel, I. Yavneh, 
%  "Multigrid multidimensional scaling", Numerical Linear Algebra with Applications (NLAA), 
%  Special issue on multigrid methods, Vol. 13/2-3, pp. 149-171, March-April 2006.
%
%  [4] A. M. Bronstein, M. M. Bronstein, R. Kimmel, 
%  "Numerical geometry of nonrigid shapes", Springer, 2008.
%
% TOSCA = Toolbox for Surface Comparison and Analysis
% Web: http://tosca.cs.technion.ac.il
% Version: 1.0
%
% (C) Copyright Michael Bronstein, 2008
% All rights reserved.
%
% License:
%
% ANY ACADEMIC USE OF THIS CODE MUST CITE THE ABOVE REFERENCES. 
% ANY COMMERCIAL USE PROHIBITED. PLEASE CONTACT THE AUTHORS FOR 
% LICENSING TERMS. PROTECTED BY INTERNATIONAL INTELLECTUAL PROPERTY 
% LAWS. PATENTS PENDING.


% embed using SMACOF
% options.rtol = 0.0001;
% options.method = 'smacof';
options.rtol = 10^(-12);
% options.atol = 1.5;
options.dim = dim;
options.iter = 100;
if dim == 3
    options.X0 = [V(Index,1),V(Index,2),V(Index,3)];
end
if dim == 2
%     options.X0 = [EV(:,1),EV(:,2)];
    options.X0 = [V(Index,1),V(Index,2)];
end
[X_smacof,hist_smacof] = mds(D,options);
% X(:,1) = X_smacof(Index,1);
% X(:,2) = X_smacof(Index,2);
% X(:,3) = X_smacof(Index,3);

% 
% % embed using SMACOF with RRE
% options.method = 'rre';
% options.atol = hist_smacof.s(end);      % stop when reaching the same stress as SMACOF
% [X_rre,hist_rre] = mds(D,options);
% 
% options.method = 'mg';
% options.DOWNMTX = DOWNMTX;
% options.UPMTX = UPMTX;
% options.IND = IND;
% [X_mg,hist_mg] = mds(D,options);









