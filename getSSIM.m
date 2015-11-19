function ssim = getSSIM(y,d,sig,c1,c2,c3)
% getSSIM: Calculates the no-reference estimate of the structural
% similarity map between the original image x and the denoised image d
% param: y - noisy image
% param: d - denoised image
% param: sig - standard deviation of the Gaussian noise

% TODO: How to choose values of c1, c2 and c3?

% defining the gaussian filter for local filtering
g = fspecial('gaussian', 11, 1.5);
y_local_mean = conv2(y,g,'same');
d_local_mean = conv2(d,g,'same');

% calculating sx (hat)
sy2 = conv2(y.*y,g,'same') - y_local_mean.^2;
temp = sy2 - sig^2;
mask = temp>0;
sx = sqrt(temp.*mask);

% Calculating sd
sd = sqrt(conv2(d.*d,g,'same') - d_local_mean.*d_local_mean);

% Calculate sxd
syd = conv2(y.*d,g,'same') - y_local_mean.*d_local_mean;
r = y - d;
r_local_mean = conv2(r,g,'same');
r_sample_mean = sumsqr(r)/(size(r,1)*size(r,2));
syr = conv2(y.*r,g,'same') - y_local_mean.*r_local_mean;

temp = [r_sample_mean,syr,sig^2];
temp2 = syd - sig^2 + min(temp);
mask  = temp2>0;
sxd = temp2.*mask;

t1 = (2*y_local_mean.*d_local_mean + c1)./(y_local_mean.^2 + d_local_mean.^2 + c1);
t2 = (2*sx.*sd + c2)./(sx.^2 + sd.^2 +c2);
t3 = (sxd + c3)./(sx.*sd + c3);
ssim_map = (t1.*t2).*t3;
ssim = sum(sum(ssim_map))/(size(ssim_map,1)*size(ssim_map,2));
