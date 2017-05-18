% particleFilter Implementation of PSIS Particle Filter 
%
% Syntax:
%   [m,pf] = particleFilter(sx,y,w,r,T,options,iter)
%
% In:
%   sx      - particles propagated from previous time step
%   y       - measurements. (N x N_measmsnts; see below for description)
%   w       - weights 
%   r       - random samples from standard normal distribution
%   time_step       - Time step
%   options - Structure with options. #TODO 
%
% Out:
%   m   - Estimated state values (N x N_states)
%   pf  - Structure with following elements
%       SX          - Particles transfromed
%       w           - weights
%       neff        - Effective Sample size
%       kHat        - Pareto shape parameter
%
% Description:
%   Gives the Particle filter estimate for the given measuremenent values.
%   See Pg. 117 of Bayesian Filtering and Smoothing, Simo Särkkä.
%   
% Set the PSIS flag (default: no PSIS) before the function is called.

function [m,P,pf] = particle_filter(sx,Y,w,r,time_step,options)

nS= size(sx,1); % Number of particles
theta = options.theta;
T = options.T;
% pf.resamp = 0;
% pf.uniq = nS;
% pf.fail = 0;
%     % samples from importance distribution
%     pf.SX = gauss_rand(options.m_IS(sx,y,A)',options.P_IS,nS)';
%     meas_cal = log_mvnpdf(y,options.h(pf.SX,H),options.R); 
%     dyn_cal = log_mvnpdf(pf.SX, options.f(sx,A),options.Q);
%     imp_cal = log_mvnpdf(pf.SX,options.m_IS(sx,y,A),options.P_IS);
%     log_w = log(w)+meas_cal+dyn_cal-imp_cal;
%     pf.w = exp(log_w - max(log_w));
% x = sx(:,1);
% y = sx(:,2);
% xdot = sx(:,3)*cos(theta);
% ydot = sx(:,3)*sin(theta);
% omega = sx(:,4);

%Bootstrap Filter
pf.SX = sx*options.A(options.T)' +...
                r * chol(options.Q,'lower'); % dynamic model
%                 r * chol(options.g(options.T)*options.Q*options.g(options.T)','lower'); % dynamic model
if options.meas_model_switch ==1
    log_w = log(w) + gp_loglikelihood(pf.SX(:,1:2),Y,options);
else
    log_w = log(w) + log(knn_likelihood(pf.SX(:,1:2),Y,options));
end
pf.w = exp(log_w-max(log_w));

% Normalize the weights
pf.w  = pf.w / sum(pf.w);


% Depending on PSIS flag either check effective number of sample or get the
% khat value (also PSIS smoothed weights)

    % Get the PSIS shape parameter and log weights else get neff
%     [log_psis_w,pf.kHat] = psislw(log(pf.w),options.tailPrct);
%     pf.w = exp(log_psis_w);
[~,pf.kHat] = psislw(log(pf.w),20);  
%pf.neff = (sum(pf.w.^2))^-1;

 if pf.kHat > 0.7
     pf.resamp = 1;
     %dbstop if infnan
     ind = resampstr(pf.w);
     pf.uniq = length(unique(ind));
     pf.SX   = pf.SX(ind,:);
     m = mean(pf.SX);
     pf.w = (1/nS)*ones(nS,1);
     SX_m = bsxfun(@minus,pf.SX,m);
     P = (repmat(pf.w,1,options.N_states) .* SX_m)'*SX_m;
 else
     m = sum(repmat(pf.w,1,options.N_states) .* pf.SX,1);
     SX_m = bsxfun(@minus,pf.SX,m);
     P = (repmat(pf.w,1,options.N_states) .* SX_m)'*SX_m;
 end




% %Get the mean based on the resamp_switch
% if options.resamp_switch == 0
%     m = sum(repmat(pf.w,1,options.N_states) .* pf.SX,1);
%     SX_m = bsxfun(@minus,pf.SX,m);
%     P = (repmat(pf.w,1,options.N_states) .* SX_m)'*SX_m;
% else
%     key = 1;
%     if options.resamp_switch == 2
%         key = mod(T,options.steps);
%     end
%     
%     if  options.resamp_switch == -1
%         if options.PSIS == 1
%             if pf.kHat > options.kHat_thres
%                 key = 0;
%             end
%         elseif pf.neff < nS * options.neff_thres;  %%nS/10
%             key = 0;
%         end
%     end
%                 
%        
%     if options.resamp_switch == 1
%         key = 0;
%     end
%     
%     if key == 0
%         try
%             pf.resamp = 1;
%             %dbstop if infnan
%             ind = resampstr(pf.w);
%             pf.uniq = length(unique(ind));
%             pf.SX   = pf.SX(ind,:);
%             m = mean(pf.SX);
%             pf.w = (1/nS)*ones(nS,1);
%             SX_m = bsxfun(@minus,pf.SX,m);
%             P = (repmat(pf.w,1,options.N_states) .* SX_m)'*SX_m;
%         catch
%             pf.fail = 1;
%             m = zeros(1,options.N_states);
%             P = zeros(options.N_states,options.N_states);
%             warning('Complete particle weight degeneration (%d partilces,%d time, iteration %d).'...
%                                                           , nS, T, iter)
%             return
%         end
%     elseif (key ~= 0 && options.resamp_switch == 2) || ...
%            (options.resamp_switch == -1)
%         m = sum(repmat(pf.w,1,options.N_states) .* pf.SX);
%         SX_m = bsxfun(@minus,pf.SX,m);
%         P = (repmat(pf.w,1,options.N_states) .* SX_m)'*SX_m;
%     end
% end
end
