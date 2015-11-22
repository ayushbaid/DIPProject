function [ MI ] = gTest( im1, im2, blockSize)
%gTest: Calculates the result of the g-test on two images
%   param in1: input image 1
%   param in2: input image 2
%   param blockSize: the size of the block used for probabilith estimation
%   returns MI: the 2D mutual info matrix

[R,C] = size(im1); % = size(im2)

% defining the mutual information array
MI = zeros(R,C);

% TODO: check if to be defined on block size or image size
numOfBins = ceil(blockSize^(2/3)); % rule of thumb mentioned in the paper

l = floor(blockSize/2);

% iterating over each pixel
for i=1:R
    for j=1:C
        % defining window bounds
        x1 = i-l;
        x2 = i+l;
        y1 = j-l;
        y2 = j+l;
        
        % cropping window when bounds exceed allowed values
        if(x1<1)
            x1=1;
        end
        if(x2>R)
            x2=R;
        end
        if(y1<1)
            y1=1;
        end
        if(y2>C)
            y2=C;
        end
        
        block_x = reshape(im1(x1:x2,y1:y2),[],1);
        block_y = reshape(im2(x1:x2,y1:y2),[],1);
        
        
        % performing binning for x and y separately
        [counts_x, ~, bins_x] = histcounts(block_x,numOfBins);
        [counts_y, ~, bins_y] = histcounts(block_y,numOfBins);
        
        
        L = size(block_x,1);
        counts_xy = zeros(numOfBins,numOfBins);
        % performing 2D binning
        for index=1:L
            bin_index_x = bins_x(index);
            bin_index_y = bins_y(index);
            
            counts_xy(bin_index_x,bin_index_y)=counts_xy(bin_index_x,bin_index_y) + 1;
        end
        
        
        % normalizing counts to get pdfs
        pdf_x = counts_x/L;
        pdf_y = counts_y/L;
        pdf_xy = counts_xy/L;
        
        %         disp(pdf_x);
        %         disp(pdf_y);
        %         disp(pdf_xy);
        
        
        % calculating mutual information
        for bin1=1:numOfBins
            for bin2=1:numOfBins
                if(pdf_xy(bin1,bin2)~=0)
                    temp = pdf_xy(bin1,bin2)*log(pdf_xy(bin1,bin2)/(pdf_x(bin1)*pdf_y(bin2)));
                    MI(i,j) = MI(i,j)+temp;
                end
            end
        end
        
        
    end
end

