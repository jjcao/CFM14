function  [endpoint,sym,D,maximal_d]=...
    compute_symConstrains(V,F,agd,hks,wks,endpoint_num,opts)
% Copyright (c) 2013 Shuhua Li

if ~isfield(opts, 'DEBUG')
    opts.DEBUG =0;
end
%% endpoint sample 
[endpoint,D,maximal_d]=endpoint_sample(V,F,agd,endpoint_num);
%% endpoint matching 
sym=endpoint_matching(V,F,endpoint,endpoint,...
    D,D,agd,agd,hks,hks,wks,wks,opts);