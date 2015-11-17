function [mse,psnr] = getPSNR(y,d,sig)
% getPSNR: Calculates the no-reference estimate of the peak signal to noise ration between the original image x and
% the denoised image d
% param: y - noisy image
% param: d - denoised image
% param: sig - standard deviation of the Gaussian noise

r = y - d;  % residual image
m1 = size(y,1);
m2 = size(y,2);

muy = sum(sum(y))/(m1*m2);
mur = sum(sum(r))/(m1*m2);
y1 = y - muy;
r1 = r - mur;
syr = sum(sum(y1.*r1))/(m1*m2);
sample_mean = sumsqr(r)/(m1*m2);
temp = [sample_mean,syr,sig^2];
L = max(max(d))/min(min(d));    % use the dynamic range of the denoised image or the noisy image?

mse = sample_mean + sig^2 - 2*min(temp);
psnr = 10*log10(L^2/mse);