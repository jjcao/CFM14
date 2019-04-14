function [C,fval]= compute_C(A, B, eigvalue1, eigvalue2,METHOD)
% 
%
%   Copyright (c) Shuhua Li, JJCAO 2013

% tic
switch METHOD
    case 'least_square'
        disp('Computing FunMap C by CA=B');
        C=B/A;
    case 'linear_system'
        disp('Computing FunMap C by linear system');
        C=linearSystem(A,B,diag(eigvalue1),diag(eigvalue2));
%         C=rand(nbasis,nbasis);C=orth(C);
    case 'optStiefelGBB'
%         disp('Computing FunMap C by optStiefelGBB');
        C0=linearSystem(A,B,diag(eigvalue1),diag(eigvalue2));    
        [U,S,V]=svd(C0);
        C0=U*V';
%         C0=rand(nbasis,nbasis);C0=orth(C0);
        opts.record = 0;
        opts.mxitr  = 2000;
        opts.xtol = 1e-5;
        opts.gtol = 1e-5;
        opts.ftol = 1e-8;
        out.tau = 1e-3;
        [C, out]= OptStiefelGBB(C0, @funOfC, opts, A,B, diag(eigvalue1),diag(eigvalue2));
        fval = out.fval;
    otherwise 
        warning('Unexpected method type');        
end
% toc