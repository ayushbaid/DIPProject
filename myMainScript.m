% This script is an implementation of an Image Denoising algorithm which uses
% the residual noise structure for improved performance.

% Paper - The Use of Residuals in Image Denoising, Brunet et. al.

tic;
%% Read the input image and add a gaussian noise to it
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


% testing getProbabilityEstimates
xvec = reshape(x,[],1);
yvec = reshape(y,[],1);
[pX,pY,pXY]=getProbabilityEstimates(xvec,yvec);
