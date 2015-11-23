function ssim = getNoRefSSIM(x,d,c1,c2,c3)
% getSSIM: Calculates the SSIM between the original image x and the denoised image d
% param: x - image1
% param: d - image2


g = fspecial('gaussian', 11, 1.5);
x_local_mean = conv2(x,g,'same');
d_local_mean = conv2(d,g,'same');

% Calculate sx
sx = sqrt(conv2(x.*x,g,'same') - x_local_mean.*x_local_mean);
sd = sqrt(conv2(d.*d,g,'same') - d_local_mean.*d_local_mean);

% Calculate sxd
sxd = conv2(x.*d,g,'same') - x_local_mean.*d_local_mean;


t1 = (2*x_local_mean.*d_local_mean + c1)./(x_local_mean.^2 + d_local_mean.^2 + c1);
t2 = (2*sx.*sd + c2)./(sx.^2 + sd.^2 +c2);
t3 = (sxd + c3)./(sx.*sd + c3);
ssim_map = (t1.*t2).*t3;
ssim = sum(sum(ssim_map))/(size(ssim_map,1)*size(ssim_map,2));
