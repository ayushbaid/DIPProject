clear all; close all; clc;

l=load('data/lena512.mat');
x = im2double(l.lena512);

% rescaling 0-255 to 0-1
x = x/255;
sd_ratio = 0.1;
intensity_range = 1;
sd = sd_ratio*intensity_range;

% Generating an iid gaussian noise
n = sd*randn(size(x)); % TODO check is sd or sd^2

% calculating corrupted image y
y = x+n;

% calculate the denoised image d
d= wiener2(y);

% figure()
% imshow(y);
% figure();
% imshow(d);

[mse,psnr] = getPSNR(y,d,sd);
ssim = getSSIM(y,d,sd,10e-6,10e-6,10e-6);