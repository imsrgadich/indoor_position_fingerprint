%% Unscented Kalman Filter implementation

% gp_ukf Implementation of Guassian Process Unscented Kalman Filter
% Quasi Constant model would be used as the dynamic model.
% Gaussian process would be used in the measurement model.
%
% Syntax:
%   [m,pf] = gp_ukf(m,p,y,options)
% In:
%   m - mean from time t-1
%   p - covariance from time t-1
%   y - measurment from time t
% 
% Out:
%   
%
%   ukf - struct for ukf options.
% Description:
%   Gives the Particle filter estimate for the given measuremenent values.
%   See Pg. 86 of Bayesian Filtering and Smoothing, Simo Särkkä.
%   

function [M,P,ukf] = gp_ukf(m,p,y,id,options)

y = y - options.min_rssi+10; % check get_reference_map for details.
n = options.N_states; %number of states


% FIXME : put extra parameters to ukf struct.

% Form the sigma points 
L_minus = chol(p,'lower');
sx = [zeros(n,1) L_minus -L_minus];
sx = sqrt(n + options.lambda)*sx + repmat(m',1,2*n+1);

% Progagate through the dynamic model; dt = 1 sec.
% as we are getting the measurement at a interval 1 sec.
dt = options.dt;
SX = options.A(dt) * sx; %% 4 x 4 * 4 * 9

% Prediction step: Get the predicted mean and covP_Fariance.
m_minus = sum(repmat(options.WM',n,1).* SX,2);
P_minus = zeros(n);
for i = 1:2*n+1
    P_minus = P_minus + options.WC(i) * (SX(:,i) - m_minus) * (SX(:,i) - m_minus)';
end
P_minus = P_minus + options.Q;

% Update step
% Form the sigma points. 
L = chol(P_minus,'lower');
HX = [zeros(n,1) L -L];
HX = sqrt(n + options.lambda)*HX + repmat(m_minus,1,2*n+1);

% Propogate the sigma points through the measurement model.

Y = gpPred(HX(1:2,:)',id-2,options);

% Get the predicted mean and covariance from the measurments. And also the
% cross covariance matrix.
meas_mu = sum(options.WM.*Y,1); 
meas_cov = zeros(size(Y,2)); 
meas_cross_cov = zeros(n,numel(y));
for i = 1:2*n+1
    meas_cov = meas_cov + options.WC(i) * (Y(i) - meas_mu) * (Y(i) - meas_mu)';
    meas_cross_cov = meas_cross_cov + options.WC(i) * (SX(:,i) - m_minus) * (Y(i) - meas_mu)';
end
meas_cov = meas_cov + options.R;

% Compute the filter gain, estimated state and covariance
gain = meas_cross_cov / meas_cov; % 4 x 28
M = m_minus + gain * (y - meas_mu); % 4 x 1
P = P_minus - gain * meas_cov * gain';

end

