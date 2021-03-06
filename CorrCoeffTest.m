function [ corr_coeff_matrix, testResult ] = CorrCoeffTest( im1, im2, N)
%pearsonCorrelationCoefficientCalc: Calculates the Pearson's Correlation for a
%pixel pair using a window centered at that pixel.
%tests it using a student-t distribution
%Coeffiecient between 2 images x and y
%   param: im1 - input image 1
%   param: im2 - input image 2
%   param: N - the size of the window (along one dimension)
%   returns: corr_coeff_matrix - the corr. coefficents matrixs
%   returns: testResult - the result about the rejection of independence
%                         hypothesis

R = size(im1,1);
C = size(im1,1);

l = floor(N/2);

corr_coeff_matrix = zeros(R,C);

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
        
        % slicing the window and reshaping to create local vector
        vector_x = reshape(im1(x1:x2,y1:y2),[],1);
        vector_y = reshape(im2(x1:x2,y1:y2),[],1);
        
        % calculating covariance matrix and the s.ds
        cov_matrix = cov(vector_x, vector_y);
        
        sx = sqrt(cov_matrix(1,1));
        sy = sqrt(cov_matrix(2,2));
        sxy = cov_matrix(1,2);
        
        corr_coeff_matrix(i,j) = sxy/(sx*sy);
    end
end

t = corr_coeff_matrix.*sqrt((N*N-2)./(1-corr_coeff_matrix.^2));

% Thresholding for 99.9% confidence
testResult = t<=3.373;

% test result = 1 indicates rejection of indepence hypothesis
end

