% Script for final iterative scheme
% Quality Enhancement of Denoised Images

%1. Set j ? 1, ˜d(0) ? y and d(0) ? 0;
%2. Denoise the image: d(j) ? D1(˜d(j));
%3. Compute the residual: r(j) ? y ? d(j);
%4. Denoise the residual: ˜r(j) ? D2(r(j));
%5. Add it back to the denoised image: ˜d(j) ? d(j) + ˜r(j);
%6. While j < J, increment j ? j + 1 and go to step 2.
%7. Find j that maximizes Q(d(j)) or Q(˜d(j));
%8. If Q(d(j)) > Q(˜d(j)) return d(j), else return ˜d(j).

tic;

%% Generating input image for the denoiser
clear all; close all; clc;

l=load('data/lena512.mat');
x = im2double(l.lena512);

% rescaling 0:255 to 0:1
x = x/255;
sd_ratio = 0.1;
intensity_range = 1;
sd = sd_ratio*intensity_range;

% Generating an iid gaussian noise
n = sd*randn(size(x)); % TODO check is sd or sd^2

% calculating corrupted image y
y = x+n;
[a,b] = size(y);
N = 2*a*b;

%% Denoising the image repeatatively

d0 = y;
d = wiener2(d0);
[mse,psnr] = getPSNR(y,x,sd);
ssim = getSSIM(y,d,sd,10e-6,10e-6,10e-6);

%fprintf('application of simple adaptive wiener\n');
%fprintf('MSE = %d\n',mse);
%fprintf('PSNR = %d\n', psnr);
%fprintf('SSIM = %d\n', ssim);
%fprintf('\n');


for j = 1:5
    d1 = wiener2(d0);
    r = y - d1;
    t = pearsonCorrelationCoefficientTest( r,y,N );
    fprintf('t = %d\n',t);
    r1 = wiener2(r);
    d0 = d1 + r1;
end

[mse1,psnr1] = getPSNR(x,d1,sd);
ssim1 = getSSIM(x,d1,sd,10e-6,10e-6,10e-6);
%fprintf('application of iterative denoiser along with use of residual image - d1\n');
%fprintf('MSE = %d\n',mse1);
%fprintf('PSNR = %d\n', psnr1);
%fprintf('SSIM = %d\n', ssim1);
%fprintf('\n');


[mse0,psnr0] = getPSNR(x,d0,sd);
ssim0 = getSSIM(x,d0,sd,10e-6,10e-6,10e-6);
%fprintf('application of iterative denoiser along with use of residual image - d0\n');
%fprintf('MSE = %d\n',mse0);
%fprintf('PSNR = %d\n', psnr0);
%fprintf('SSIM = %d\n', ssim0);
%fprintf('\n');



    
    
    
    
    
    
    
    
    