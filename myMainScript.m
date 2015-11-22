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

MAX_ITER = 5; % for the iterative algo

% looping over all the available images
for i=1:nfiles
    currentImageName = images(i).name;
    x = imread([imgPath currentImageName]);
    x = im2double(x);
    
    % rescaling 0-255 to 0-1
    x = x/255;
    
    % looping over noise's s.d.
    for j=1:6

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

        fprintf('Image number = %d\n',i);
        fprintf('S.D = %d', sd_set(j));
        % fprintf('application of simple adaptive wiener\n');
        % fprintf('MSE = %d\n',mse);
        % fprintf('PSNR = %d\n', psnr);
        % fprintf('SSIM = %d\n', ssim);
        % fprintf('\n');


        ssim = zeros(MAX_ITER,1);
        psnr = zeros(MAX_ITER,1);
        mse = zeros(MAX_ITER,1);
        for k = 1:MAX_ITER
            d1 = D1_filter(d0);
            r = y - d1;
            %     t = pearsonCorrelationCoefficientTest( r,y,N );
            %     fprintf('t = %d\n',t);
            
            r1 = wiener2(r); % Denoising the residue
            d0 = d1 + r1; % Adding back the denoised residue
            [mse(k),psnr(k)] = getPSNR(y,d0,sd);
            ssim(k) = getSSIM(y,d0,sd_ratio,c1,c2,c3);
            
            %         fprintf('Iteration = %d\n',k);
            %         fprintf('MSE = %d\n',mse(k));
            %         fprintf('PSNR = %d\n', psnr(k));
            %         fprintf('SSIM = %d\n', ssim(k));
            %         fprintf('\n');
        end
    
    
        figure()
        hold on
        plot(ssim);
        plot(ssim0*ones(MAX_ITER));
        hold off
        legend('Iterative Method', 'TVI');
        title('ssim for image = %d s.d = %d',i,sd_set(j));

        figure()
        hold on
        plot(psnr);
        plot(psnr0*ones(MAX_ITER));
        hold off
        legend('Iterative Method', 'TVI');
        title('psnr for image = %d s.d = %d',i,sd_set(j));

    end
end
