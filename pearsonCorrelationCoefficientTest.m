function [ t ] = pearsonCorrelationCoefficientTest( x,y,n )
%pearsonCorrelationCoefficientCalc: Calculates the Pearson's Correlation and
%tests it using a student-t distribution
%Coeffiecient between 2 input images x and y
%   param: x - input image 1
%   param: y - input image 2
%   param: n - degrees of freedom for student-t distribution
%   returns: t - the corr. coefficient test result

% unrolling x and y into row vectors
% TODO: check if covariance defn correct
x = reshape(x,1,[]);
y = reshape(y,1,[]);

sxy = cov(x,y);
sx = cov(x);
sy = cov(y);

r = sxy/(sx*sy);

t = r*sqrt((n-2)/(1-r*r));

end

