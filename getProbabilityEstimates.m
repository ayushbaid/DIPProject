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

[xCounts, ~, xBins] = histcounts(x,numOfBins);
[yCounts, ~, yBins] = histcounts(y,numOfBins);

xPdf = xCounts/n;
pX = xPdf(xBins);

yPdf = yCounts/n;
pY = yPdf(yBins);

% performing 2D binning
xyCounts =zeros(numOfBins,numOfBins);

for xIndex=1:numOfBins
    for yIndex=1:numOfBins
        xyCounts(xBins(xIndex),yBins(yIndex))=xyCounts(xBins(xIndex),yBins(yIndex))+1;
    end
end
xyPdf = xyCounts/n;
disp(size(xyPdf));
pXY = xyPdf(xBins,yBins);
