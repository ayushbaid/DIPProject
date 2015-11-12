function [ counts, edges, bins ] = histcounts( x, numOfBins )
%histcounts Temp alternative for histcounts; just to run the scripts

n = size(x,1);

minVal = min(x)-1;
maxVal = max(x)+1;

binRange = (maxVal-minVal)/numOfBins;

edges = minVal:binRange:maxVal;
bins = zeros(n,1);
for i=1:n
    bins(i) = find(edges>x(i),1)-1;
end

counts = zeros(numOfBins,1);

for i=1:numOfBins
    counts(i)=sum(bins==i);
end

end

