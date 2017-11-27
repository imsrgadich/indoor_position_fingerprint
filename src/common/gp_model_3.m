function [gp,opt] = gp_model_3()

%% Student t measurement model.

clear ('gp','gpcf','lik','pn','pl','pm','w','opt')
% likelihood
pn = prior_logunif();
lik = lik_t('nu', 4, 'nu_prior', pn, ...
            'sigma2', 0.2^2, 'sigma2_prior', pn);

% kernels
%gpcf_const = gpcf_constant('constSigma2',75, 'constSigma2_prior', prior_gaussian('mu',75, 's2', 20));

gpcf_se = gpcf_sexp('lengthScale', [3 3], ...
                    'lengthScale_prior', prior_gaussian('mu',5, 's2', 2),...
                     'magnSigma2', 5^2,...
                     'magnSigma2_prior', prior_gaussian('mu',5^2, 's2', 3^2));

gp = gp_set('lik',lik,'cf',{gpcf_se},'jitterSigma2', 1e-6, ...
            'latent_method', 'Laplace');

% gp = gp_set('lik',lik,'cf',{gpcf_se gpcf_const});
opt = optimset('TolFun',1e-3,'TolX',1e-3,'Display','iter');