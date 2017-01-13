function [ Kx ] = gaussian_kernel( X1, X2, sigma)
% Compute the Gram matrix of a Gaussian kernel between the sets X1 and X2
%
% INPUTS:
% X1:           matrix of size n1 * p
% X2:           matrix of size n2 * p
% sigma:        parameter of the Gaussian kernel
%
% OUTPUTS:
% Kx:           Gram matrix of size n1 * n2

    n1 = size(X1,1);
    n2 = size(X2,1);
    
    D = diag(X1*X1')*ones(1,n2) + ones(n1,1)*diag(X2*X2')' - 2*X1*X2';
    
    Kx = exp(- D ./ (2 * sigma^2));

    
end