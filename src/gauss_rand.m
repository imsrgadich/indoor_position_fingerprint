%GAUSS_RAND Sampling from Multivariate Gaussian random variables. Handles
% both single and multiple mean(M) inputs.
%
% Syntax:
%   X = GAUSS_RAND(M,C,N)
%
% In:
%   M - Dx1 mean of distibution or K values as DxK matrix.
%   C - DxD covariance matrix
%   N - Number of samples (optional, default 1)
%
%   where D is number of dimensions od state.
%
% Out:
%   X - Dx(K*N) matrix of samples.
%   
% Description:
%   Draw N samples from multivariate Gaussian distribution
% 
%     X ~ N(M,C)  where X is N x D
%
%(c) Srikanth Gadicherla


function X = gauss_rand(M,C,N)

  if nargin < 3
    N = 1;
  end
  
  if size(M,1) ~= size(C,1)
      error('States dimension mismatch')
  end
  
  L = chol(C)';
  if size(M,2) == 1
      X = (repmat(M,1,N) + L*randn(size(M,1),size(M,2)*N));
  else
      X = M + L*randn(size(M,1),size(M,2)); 
  end
