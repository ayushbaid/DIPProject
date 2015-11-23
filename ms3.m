% Runs the algo for the lenna image for 5 iterations;
% Denoiser 1 is Wiener filter
% Denoiser 2 is TVD


tic;
% Read the input image(s) and add a gaussian noise to it
clear all; close all; clc;

addpath('./');
addpath('./toolbox_image');
addpath('./toolbox_image/toolbox_image');
addpath('./toolbox_image/toolbox_image/toolbox');

% init the set of standard deviations to test on
sd = [5,15,25,35,45];

% initializing SSIM params
c1 = 10e-4;
c2 = 9e-4;
c3 = c2/2;

MAX_ITERS = 5; % for the iterative algo

% some parameter for the algorithm
options.verb = 0;
options.display = 0;
options.niter = 100;   % number of iterations
options.lambda = .3; % initial regularization


l=load('data/lena512.mat');
x = im2double(l.lena512);
% rescaling 0-255 to 0-1
x = x/255;

R = size(x,1);
C = size(x,2);

d1_array=zeros(MAX_ITERS,R,C);
d0_array=zeros(MAX_ITERS,R,C);
r_array = zeros(MAX_ITERS,R,C);

% looping over noise's s.d.
for i = 1:size(sd,2)
    fprintf('sd = %d \n',sd(i));
    sd_ratio = sd(i)/255;
    intensity_range = 1;
    sd_val = sd_ratio*intensity_range;

    options.etgt = 1.1*sd_ratio*size(x,1);

    % Generating an iid gaussian noise
    n = sd_val*randn(size(x));

    % calculating corrupted image y
    y = x+n;
    [a,b] = size(y);


    % performing the first iteration
    d0 = y;
    [d2,~,~,~] = perform_tv_denoising(d0,options);
    d = wiener2(d0);

    % Calculating the PSNR and SSIM without residual processing
    [mse0,psnr0] = getPSNR(x,d);
    ssim0 = getSSIM(x,d,c1,c2,c3);  % SSIM using just Wiener filter

    [mse2,psnr2] = getPSNR(x,d2);
    ssim2 = getSSIM(x,d2,c1,c2,c3); % SSIM using TVD


    ssim = zeros(1,MAX_ITERS);
    psnr = zeros(1,MAX_ITERS);
    mse = zeros(1,MAX_ITERS);
    for k = 1:MAX_ITERS
        d1 = wiener2(d0);
        d1_array(k,:,:) = d1;
        r = y - d1;
        r_array(k,:,:) = r;
        %     t = pearsonCorrelationCoefficientTest( r,y,N );
        %     fprintf('t = %d\n',t);

        [r1,~,~,~] = perform_tv_denoising(r,options); % Denoising the residue
        d0 = d1 + r1; % Adding back the denoised residue
        d0_array(k,:,:) = d0;
        [mse(k),psnr(k)] = getPSNR(x,d0);
        ssim(k) = getSSIM(x,d0,c1,c2,c3);

    end
    
    imp_tvd = ssim(MAX_ITERS)/ssim2;
    imp_wiener = ssim(MAX_ITERS)/ssim0;
    fprintf('Improvement in SSIM if only TVD is used = %f \n',imp_tvd);
    fprintf('Improvement in SSIM if only adaptive Wiener filter is used = %f \n',imp_wiener);
    fprintf('\n');

    figure()
    subplot(3,3,1)
    imshow(x(100:400,100:400))
    title('Original Image')
    subplot(3,3,2)
    imshow(y(100:400,100:400))
    title('Noisy input')

    subplot(3,3,3)
    imshow(d2(100:400,100:400))
    title('TVD output')

    subplot(3,3,4)
    imshow(d(100:400,100:400))
    title('Wiener filter output')

    subplot(3,3,5)
    imshow(squeeze(r_array(1,100:400,100:400)))
    title('residue in #1')

    subplot(3,3,6)
    imshow(squeeze(d0_array(1,100:400,100:400)))
    title('op after #1')

    subplot(3,3,7)
    imshow(squeeze(d1_array(2,100:400,100:400)))
    title('ip to #2')

    subplot(3,3,8)
    imshow(squeeze(r_array(2,100:400,100:400)))
    title('residue in #2')

    subplot(3,3,9)
    imshow(squeeze(d0_array(2,100:400,100:400)))
    title('op after #2')

    figure()
    hold on;
    plot(ssim); M1='Iterative';
    plot(repmat(ssim0,1,MAX_ITERS)); M2='Wiener';
    plot(repmat(ssim2,1,MAX_ITERS)); M3='TVD';
    legend(M1,M2,M3);
    xlabel('Iteration number');
    ylabel('SSIM');
    caption = sprintf('SSIM plots for sd = %d',sd(i));
    title(caption);

    figure()
    hold on;
    plot(psnr); M1='Iterative';
    plot(repmat(psnr0,1,MAX_ITERS)); M2='Wiener';
    plot(repmat(psnr2,1,MAX_ITERS)); M3='TVD';
    legend(M1,M2,M3);
    xlabel('Iteration number');
    ylabel('PSNR');
    caption = sprintf('PSNR plots for sd = %d',sd(i));
    title(caption);
    
end

