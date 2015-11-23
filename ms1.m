% This script runs the iterative algorithm on 5 images for 6 possible standard
% deviation values. The results thus point towards effect of s.d. on the algo.

% Denoiser 1 is Wiener filter
% Denoiser 2 is TVD

tic;
% Read the input image(s) and add a gaussian noise to it
clear all; close all; clc;

addpath('./');
addpath('./toolbox_image');
addpath('./toolbox_image/toolbox_image');
addpath('./toolbox_image/toolbox_image/toolbox');

imgPath = './USC_SIPI_database/';
imgType = '*.tiff';
images = dir([imgPath imgType]);
nfiles = length(images);

% init the set of standard deviations to test on
sd_set = [0 5 15 25 40 70];

color_set = ['r' 'g' 'b' 'k' 'y'];

% initializing SSIM params
c1 = 10e-4;
c2 = 9e-4;
c3 = c2/2;

MAX_ITER = 5; % for the iterative algo

% some parameter for the algorithm
options.verb = 0;
options.display = 0;
options.niter = 100;    % number of iterations
options.lambda = .3; % initial regularization


% looping over 6 variance values
for j=1:6
    % looping over 5 images
    for i=1:5
        currentImageName = images(i).name;
        x = imread([imgPath currentImageName]);
        x = im2double(x);
        
        % rescaling 0-255 to 0-1
        x = x/255;
        
        % looping over noise's s.d.

        sd_ratio = sd_set(j)/255;
        intensity_range = 1;
        sd = sd_ratio*intensity_range;
        
        options.etgt = 1.1*sd*size(x,1);

        % Generating an iid gaussian noise
        n = sd*randn(size(x));

        % calculating corrupted image y
        y = x+n;
        [a,b] = size(y);


        % performing the first iteration
        d0 = y;
        d = wiener2(d0);
        [d2,~,~,~] = perform_tv_denoising(d0,options);
        
        % Calculating the PSNR and SSIM without residual processing
        [mse0,psnr0] = getPSNR(x,d);
        ssim0 = getSSIM(x,d,c1,c2,c3);
        
        [mse2,psnr2] = getPSNR(x,d2);
        ssim2 = getSSIM(x,d2,c1,c2,c3);

        fprintf('Image number = %d\n',i);
        fprintf('S.D = %d\n\n', sd_set(j));


        ssim = zeros(MAX_ITER,1);
        psnr = zeros(MAX_ITER,1);
        mse = zeros(MAX_ITER,1);
        for k = 1:MAX_ITER
            d1 = wiener2(d0);
            r = y - d1;
            %     t = pearsonCorrelationCoefficientTest( r,y,N );
            %     fprintf('t = %d\n',t);
            
            [r1,~,~,~] = perform_tv_denoising(r,options); % Denoising the residue
            d0 = d1 + r1; % Adding back the denoised residue
            [mse(k),psnr(k)] = getPSNR(x,d0);
            ssim(k) = getSSIM(x,d0,c1,c2,c3);
        end
    
    
        figure(2+2*j-1)
        hold on
        plot(ssim,color_set(i));
        scatter(1,ssim0,color_set(i));
        title(sprintf('ssim for s.d=%d',sd_set(j)));

        figure(2+2*j)
        hold on
        plot(psnr,color_set(i));
        scatter(1,psnr0,color_set(i));
        title(sprintf('psnr for s.d.=%d',sd_set(j)));

    end
end

