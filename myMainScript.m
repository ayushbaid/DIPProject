% This script is an implementation of an Image Denoising algorithm which uses
% the residual noise structure for improved performance.

% Paper - The Use of Residuals in Image Denoising, Brunet et. al.

tic;
% Read the input image(s) and add a gaussian noise to it
close all; clc;

imgPath = '.\USC_SIPI_database\';
imgType = '*.tiff';
images = dir([imgPath imgType]);
nfiles = length(images);

% init the set of standard deviations to test on
sd_set = [0 5 10 15 25 70];

% initializing SSIM params
c1 = 10e-4;
c2 = 9e-4;
c3 = c2/2;

MAX_ITER = 20; % for the iterative algo

% looping over all the available images
for i=1:1
    currentImageName = images(i).name;
    x = imread([imgPath currentImageName]);
    x = im2double(x);
    
    % rescaling 0-255 to 0-1
    x = x/255;
    
    % looping over noise's s.d.
    for j=2:2

        sd_ratio = sd_set(j)/255;
        intensity_range = 1;
        sd = sd_ratio*intensity_range;

        % Generating an iid gaussian noise
        n = sd*randn(size(x));

        % calculating corrupted image y
        y = x+n;
        [a,b] = size(y);


        % performing the first iteration
        d0 = y;
        d = D1_filter(d0);
        
        % Calculating the PSNR and SSIM without residual processing
        [mse0,psnr0] = getPSNR(y,d,sd);
        ssim0 = getSSIM(y,d,sd,c1,c2,c3);

        fprintf('Image number = %d',i);
        fprintf('S.D = %d', sd_set(j));
        % fprintf('application of simple adaptive wiener\n');
        % fprintf('MSE = %d\n',mse);
        % fprintf('PSNR = %d\n', psnr);
        % fprintf('SSIM = %d\n', ssim);
        % fprintf('\n');


        ssim = zeros(MAX_ITER);
        psnr = zeros(MAX_ITER);
        mse = zeros(MAX_ITER);
        for k = 1:MAX_ITER
            d1 = D1_filter(d0);
            r = y - d1;
            %     t = pearsonCorrelationCoefficientTest( r,y,N );
            %     fprintf('t = %d\n',t);
            % Denoising the residue
            r1 = wiener2(r);
            d0 = d1 + r1;
            [mse(k),psnr(k)] = getPSNR(y,d0,sd);
            ssim(k) = getSSIM(y,d0,sd,c1,c2,c3);
            %         fprintf('Iteration = %d\n',j);
            %         fprintf('MSE = %d\n',mse(j));
            %         fprintf('PSNR = %d\n', psnr(j));
            %         fprintf('SSIM = %d\n', ssim(j));
            %         fprintf('\n');
        end
    
    
        figure()
        hold on
        plot(ssim,'Iterative Method');
        plot(ssim0*ones(MAX_ITER),'TVI');
        title('ssim');

        figure(2)
        hold on
        plot(psnr,'Iterative Method');
        plot(psnr0*ones(MAX_ITER),'TVI');
        title('psnr');

    end
end
