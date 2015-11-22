% This script is an implementation of an Image Denoising algorithm which uses
% the residual noise structure for improved performance.

% Paper - The Use of Residuals in Image Denoising, Brunet et. al.

tic;
%% Read the input image and add a gaussian noise to it
clear all; close all; clc;

imgPath = '.\USC_SIPI_database\';
imgType = '*.tiff';
images = dir([imgPath imgType]);
nfiles = length(images);
for i=1:1
    currentImage = images(i).name;
    x = imread([imgPath currentImage]);
    x = im2double(x);
    
    % rescaling 0-255 to 0-1
    x = x/255;
    sd_ratio = 15/255;
    intensity_range = 1;
    sd = sd_ratio*intensity_range;

    % Generating an iid gaussian noise
    n = sd*randn(size(x));
    
    % calculating corrupted image y
    y = x+n;
    [a,b] = size(y);
    N = 2*a*b;

    %% Denoising the image repeatatively
    c1 = 10e-4;
    c2 = 9e-4;
    c3 = c2/2;

    d0 = y;
    d = wiener2(d0);
    [mse0,psnr0] = getPSNR(y,d,sd);
    ssim0 = getSSIM(y,d,sd,c1,c2,c3);
    
    fprintf('Image number = %d',i);
%     fprintf('application of simple adaptive wiener\n');
%     fprintf('MSE = %d\n',mse);
%     fprintf('PSNR = %d\n', psnr);
%     fprintf('SSIM = %d\n', ssim);
%     fprintf('\n');

    MAX_ITER = 20;
    ssim = zeros(MAX_ITER);
    psnr = zeros(MAX_ITER);
    mse = zeros(MAX_ITER);
    for j = 1:MAX_ITER
        d1 = wiener2(d0);
        r = y - d1;
    %     t = pearsonCorrelationCoefficientTest( r,y,N );
    %     fprintf('t = %d\n',t);
        r1 = wiener2(r);
        d0 = d1 + r1;
        [mse(j),psnr(j)] = getPSNR(y,d0,sd);
        ssim(j) = getSSIM(y,d0,sd,c1,c2,c3);
%         fprintf('Iteration = %d\n',j);
%         fprintf('MSE = %d\n',mse(j));
%         fprintf('PSNR = %d\n', psnr(j));
%         fprintf('SSIM = %d\n', ssim(j));
%         fprintf('\n');
    end

    figure(1)
    hold on
    plot(ssim);
    if(i==1)
        plot(ssim0*ones(MAX_ITER));
    end
    title('ssim');

    figure(2)
    hold on
    plot(psnr)
    if(i==1)
        plot(psnr0);
    end
    title('psnr');

    figure(3)
    hold on
    if(i==1)
        plot(mse0);
    end
    plot(mse)
    title('mse');
end
