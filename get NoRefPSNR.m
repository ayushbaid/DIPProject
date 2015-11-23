function [mse,psnr] = getNoRefPSNR(y,d,sig)
% getNoRefPSNR: Calculates the no-reference estimate of the peak signal to noise ration between the original image x and
% the denoised image d
%   param: y - noisy image
%   param: d - denoised image
%   param: sig - standard deviation of the Gaussian noise
%   return: mse
%   return: psnr

r = y - d;  % residual image
m1 = size(y,1);
m2 = size(y,2);

% Calculatin the means
mean_y = sum(sum(y))/(m1*m2);
mean_r = sum(sum(r))/(m1*m2);

% performing mean normalization
y1 = y - mean_y;
r1 = r - mean_r;

% calculating the sample covariance

syr = sum(sum(y1.*r1))/(m1*m2);
mean_sq = sumsqr(r)/(m1*m2);
temp = [mean_sq,syr,sig^2];

mse = mean_sq + sig^2 - 2*min(temp);
psnr = 10*log10(1/mse);
