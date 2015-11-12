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
        
        block1=reshape(in1(x1:x2,y1:y2),[],1);
        block2=reshape(in2(x1:x2,y1:y2),[],1);
        
        [pX,pY,pXY] = getProbabilityEstimates(block1,block2);
        
        
        % getting pdfs
        
        % calculating the metric for each pixel in the selected block
        
        L=size(block,1);
        
        
                
    end
end
        


end

