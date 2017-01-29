function [m,P,pf] = particle_filter(sx,y,w,r,T,options,iter)
% particleFilter Implementation of Particle Filter with PSIS
%
% Syntax:
%   [m,pf] = particleFilter(sx,y,w,r,T,options,iter)
%
% In:
%   sx      - particles propagated from previous time step
%   y       - measurements. (N x N_measmsnts; see below for description)
%   w       - weights 
%   r       - random samples from standard normal distribution
%   T       - Time step
%   options - Structure with following elements. 
%       N          - Number of data points
%       N_states   - dimension of states 
%       N_measmnts - dimension of measurements
%       Q          - system noise covariance
%       R          - measurement noise covariance
%       A          - dynamic model matrix
%       H          - measurement model matrix
%       Am         - Dynamic model matrix for stochastic oscillator
%       imp        - flag is 1 if not bootstrap filter
%       PSIS       - flag, PSIS part will run only ifX1.
%       PSIS_switch- flag for smoothing, from 0 to 12. More info below.
%       kHat_thres - 0.7 or 1, threshold beyond which resampling is done.
%       PSIS_smooth- flag, PSIS smoothing only when 1
%       iter       - MC iteration
%
% Out:
%   m   - Estimated state values (N x N_states)
%   pf  - Structure with following elements
%       SX          - Particles transfromed
%       w           - weights
%       neff        - Effective Sample size
%       kHat        - Pareto shape parameter
%       resamp      - is set when resampling is done
%       uniq        - gives the count of unique particles after resampling
%
% Description:
%   Gives the Particle filter estimate for the given measuremenent values.
%   See Pg. 117 of Bayesian Filtering and Smoothing, Simo Särkkä.
%   
% Set the PSIS flag (default: no PSIS) before the function is called.

nS= size(sx,1); % Number of particles
H = options.H;
pf.resamp = 0;
pf.uniq = nS;
pf.fail = 0;

if options.model_switch == 1
    A = options.Am(T);
else
    A = options.A;
end

% Compute depending on conventional PF or Bootstrap
if options.imp == 1
    % samples from importance distribution
    pf.SX = gauss_rand(options.m_IS(sx,y,A)',options.P_IS,nS)';
    meas_cal = log_mvnpdf(y,options.h(pf.SX,H),options.R); 
    dyn_cal = log_mvnpdf(pf.SX, options.f(sx,A),options.Q);
    imp_cal = log_mvnpdf(pf.SX,options.m_IS(sx,y,A),options.P_IS);
    log_w = log(w)+meas_cal+dyn_cal-imp_cal;
    pf.w = exp(log_w - max(log_w));
else 
    %Bootstrap Filter
    pf.SX = options.f(sx,A) + r * chol(options.Q,'lower'); % dynamic model
    pf.w = w.*mvnpdf(y,options.h(pf.SX,H),options.R);
end

% Normalize the weights
pf.w  = pf.w / sum(pf.w);
pf.wr = pf.w;

% Depending on PSIS flag either check effective number of sample or get the
% khat value (also PSIS smoothed weights)
if options.PSIS == 1
    % Get the PSIS shape parameter and log weights else get neff
    [log_psis_w,pf.kHat] = psislw(log(pf.w),options.tailPrct);
    
    if options.PSIS_smooth == 1
        if (options.PSIS_switch == 2  && pf.kHat > 0) ...
                || (options.PSIS_switch == 3  && pf.kHat > 0.05) ...
                || (options.PSIS_switch == 4  && pf.kHat > 0.10) ...
                || (options.PSIS_switch == 5  && pf.kHat > 0.15) ...
                || (options.PSIS_switch == 6  && pf.kHat > 0.20) ...
                || (options.PSIS_switch == 7  && pf.kHat > 0.25) ...
                || (options.PSIS_switch == 8  && pf.kHat > 0.30) ...
                || (options.PSIS_switch == 9  && pf.kHat > 0.35) ...
                || (options.PSIS_switch == 10 && pf.kHat > 0.40) ...
                || (options.PSIS_switch == 11 && pf.kHat > 0.45) ...
                || (options.PSIS_switch == 12 && pf.kHat > 0.50) ...
                || options.PSIS_switch == 1
            pf.w = exp(log_psis_w);
        end
    end
else
    pf.neff = (sum(pf.w.^2))^-1;
end

%Get the mean based on the resamp_switch
if options.resamp_switch == 0
    m = sum(repmat(pf.w,1,options.N_states) .* pf.SX,1);
    SX_m = bsxfun(@minus,pf.SX,m);
    P = (repmat(pf.w,1,options.N_states) .* SX_m)'*SX_m;
else
    key = 1;
    if options.resamp_switch == 2
        key = mod(T,options.steps);
    end
    
    if  options.resamp_switch == -1
        if options.PSIS == 1
            if pf.kHat > options.kHat_thres
                key = 0;
            end
        elseif pf.neff < nS * options.neff_thres;  %%nS/10
            key = 0;
        end
    end
                
       
    if options.resamp_switch == 1
        key = 0;
    end
    
    if key == 0
        try
            pf.resamp = 1;
            %dbstop if infnan
            ind = resampstr(pf.w);
            pf.uniq = length(unique(ind));
            pf.SX   = pf.SX(ind,:);
            m = mean(pf.SX);
            pf.w = (1/nS)*ones(nS,1);
            SX_m = bsxfun(@minus,pf.SX,m);
            P = (repmat(pf.w,1,options.N_states) .* SX_m)'*SX_m;
        catch
            pf.fail = 1;
            m = zeros(1,options.N_states);
            P = zeros(options.N_states,options.N_states);
            warning('Complete particle weight degeneration (%d partilces,%d time, iteration %d).'...
                                                          , nS, T, iter)
            return
        end
    elseif (key ~= 0 && options.resamp_switch == 2) || ...
           (options.resamp_switch == -1)
        m = sum(repmat(pf.w,1,options.N_states) .* pf.SX);
        SX_m = bsxfun(@minus,pf.SX,m);
        P = (repmat(pf.w,1,options.N_states) .* SX_m)'*SX_m;
    end
end
end
