close all; clc;

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

[r,testResult] = CorrCoeffTest(x, y, 7);

% rescaling r to display as an image
rmin = min(min(r));
rmax = max(max(r));
scaled_r = (r-rmin)./(rmax-rmin);

figure()
imshow(r)

figure()
imshow(testResult)
