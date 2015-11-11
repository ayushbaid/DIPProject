function [pX,pY,pXY] = getProbabilityEstimates(x, y)
% getJointProbabilityEstimate this function generates the probability
% distributions by binning the data in a 2D fashion and returns the empirical
% probabaility estimate for each of the sample points
%   param x: the vector of data points for 1st Random Variable
%   param y: the vector of data points for 2nd RV
%   returns pX: a vector of probability estimates for x
%   returns pY: a vector of probability estimates for y
%   returns pXY: a vector of joint probability estimates for (x,y)


n = size(x,1);

numOfBins = ceil(n^(1/3));

% performing 1D binning for x and y

[xCounts, xEdges, xBins] = histcounts(x,numOfBins);
[yCounts, yEdges, yBins] = histcounts(y,numOfBins);

xPdf = xCounts/n;
pX = xPdf(xBins);

yPdf = yCounts/n;
pY = yPdf(yBins);

% performing 2D binning
xyCounts =zeros(numOfBins,numOfBins);
xIndices = find(xEdges>x,1)-1;
yIndices = find(yEdges>y,1)-1;

xyCounts(xIndices,yIndices)=xyCounts(xIndices,yIndices)+1;

xyPdf = xyCounts/n;
pXY = xyPdf(xIndices,yIndices);
