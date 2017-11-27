function [gp,opt] = gp_model_2()

%% Scaled mixture model.

clear ('gp','gpcf','lik','pn','pl','pm','w','opt')
% likelihood
lik = lik_gaussiansmt('ndata', 3, 'sigma2', repmat(0.2^2,n,1), ...
                      'nu_prior', prior_logunif());

% kernels
%gpcf_const = gpcf_constant('constSigma2',75, 'constSigma2_prior', prior_gaussian('mu',75, 's2', 20));

gpcf_se = gpcf_sexp('lengthScale', [3 3], ...
                    'lengthScale_prior', prior_gaussian('mu',3, 's2', 2),...
                     'magnSigma2', 5^2,...
                     'magnSigma2_prior', prior_gaussian('mu',5^2, 's2', 3^2));

gp = gp_set('lik',lik,'cf',{gpcf_se});
% gp = gp_set('lik',lik,'cf',{gpcf_se gpcf_const});
opt = optimset('TolFun',1e-3,'TolX',1e-3,'Display','iter');