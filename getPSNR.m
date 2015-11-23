function [mse,psnr] = getPSNR(x,d)
% getPSNR: calculates the MSE and PSNR between 2 images x and d

m1 = size(x,1);
m2 = size(x,2);
mse = sumsqr(x-d)/(m1*m2);

psnr = 10*log10(1/mse);
