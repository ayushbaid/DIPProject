% some parameter for the algorithm
options.verb = 0;
options.display = 0;
options.niter = 300;    % number of iterations
options.etgt = 1.1*sigma*n;
options.lambda = .3; % initial regularization
% now we perform the denoising
[Mtv,err,tv,lambda] = perform_tv_denoising(M,options);
