function [ result ] = gTest( in1, in2)
%gTest: Calculates the result of the g-test on two images
%   param in1: input image 1
%   param in2: input image 2
%   returns result: the G-Test result

[R,C] = size(in1); % = size(in2)

% defining the mutual information array
MI = zeros(R,C);

% using non-overlapping blocks to perform local binning
blockSize = 15;

% TODO: check if to be defined on block size or image size
numOfBins = ceil(blockSize^(2/3)); % rule of thumb mentioned in the paper

% calculating number of blocks for each dimension
X_max = ceil(R/blockSize);
Y_max = ceil(C/blockSize);

% iterating over blocks
for x=1:X_max
    x1=(x-1)*blockSize+1;
    x2=min(x*blockSize,R);
    for y=1:Y_max
        y1=(y-1)*blockSize+1;
        y2=min(y*blockSize,C);
        
        block1=in1(x1:x2,y1:y2);
        block2=in2(x1:x2,y1:y2);
        
        jointSpace = 
        
        % performing binning
        [counts1,binLoc1] = imhist(block1,numOfBins);
        [counts2,binLoc2] = imhist(block2,numOfBins);
        [counts_joint, binLocJoint] = imcount(
        pdf1 = counts1/(15*15);
        pdf2 = counts2/(15*15);
        
        % calculating the metric for each pixel in the selected block
        
        for a=1:(x2-x1+1)
            for b=1:(y2-y1+1)
                val1=block1(a,b);
                val2=block2(a,b);
                
                
    end
end
        


end

