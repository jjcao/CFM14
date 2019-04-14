function test1()
X0 =[0,-1]'; 
M=[0.25,0;0,1];
opts.record = 0;
opts.mxitr  = 5000;
opts.xtol = 1e-5;
opts.gtol = 1e-5;
opts.ftol = 1e-8;
out.tau = 1e-3;
tic; [X, out]= OptStiefelGBBM(X0,M,@funt, opts); tsolve = toc;
f=X(1,1);
function [F, G] = funt(X)
        
        G = [1,0]';
        %F = 0.5*sum(sum( G.*X ));
        F =X(1);
        % F = sum(sum( G.*X ));
        % G = 2*G;
end
end