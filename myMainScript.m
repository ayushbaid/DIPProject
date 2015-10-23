% This script is an implementation of an Image Denoising algorithm which uses
% the residual noise structure for improved performance.

% Paper - The Use of Residuals in Image Denoising, Brunet et. al.

tic;
%% Read the input image and add a gaussian noise to it
clear all; close all; clc;

x = im2double(imread('../data/lena.png'));

intensity_range = max(max(x)) - min(min(x));
sd_ratio = 0.1;
sd = sd_ratio*intensity_range;

% Generating an iid gaussian noise
n = sd*randn(size(x)); % TODO check is sd or sd^2

% calculating corrupted image y
y = x+n;




