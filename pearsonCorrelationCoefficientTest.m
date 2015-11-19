function [ t ] = pearsonCorrelationCoefficientTest( x,y,N,n )
%pearsonCorrelationCoefficientCalc: Calculates the Pearson's Correlation and
%tests it using a student-t distribution
%Coeffiecient between 2 input vectors x and y
%   param: x - input vector 1
%   param: y - input vector 2
%   param: N - a single coeff of 
%   param: n - degrees of freedom for student-t distribution
%   returns: t - the corr. coefficient test result

%TODO: implement sliding window

sxy = cov(x,y);
sx = cov(x);
sy = cov(y);

r = sxy/(sx*sy);

t = r*sqrt((n-2)/(1-r*r));

end

