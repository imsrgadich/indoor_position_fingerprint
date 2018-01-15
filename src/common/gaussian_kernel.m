function [ Kx ] = gaussian_kernel( X1, X2, len_scale,signal_var)
% Compute the Gram matrix of a Gaussian kernel between the sets X1 and X2
%
% INPUTS:
% X1:           matrix of size n1 * dimension
% X2:           matrix of size n2 * dimension
% len_scale:    length scale size 1 * dimension
% signal_var:   signal variance
%
% OUTPUTS:
% Kx:           Gram matrix of size n1 * n2

    n1 = size(X1,1);
    n2 = size(X2,1);
    X1 = bsxfun(@rdivide,X1,len_scale);
    X2 = bsxfun(@rdivide,X2,len_scale);
    
    D = 0.5*(diag(X1*X1')*ones(1,n2) + ones(n1,1)*diag(X2*X2')' - 2*X1*X2');
    
    Kx = signal_var*exp(-D); 
end