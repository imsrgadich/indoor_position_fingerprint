clear all, clc;

%% load the parameters from GP regression training.
load('../data/parameter_trained.mat')
options.parameters = parameters;
load('../data/location.mat');
options.locations = locations;
load('../data/reference_map/reference_map_updated.mat')
options.reference_map = reference_map_updated;

options.omega = 0.0001; %frequency
options.T = 1;

% Dynamic model Augmented Turn Coordinated Model
options.f = @(x,xdot,y,ydot,T,omega) ...
    [x+(xdot*sin(omega*T)/omega)-(ydot*(1-cos(omega*T))/omega);
     y+(xdot*(1-cos(omega*T))/omega)+(ydot*sin(omega*T)/omega);
     sqrt(xdot.^2+ydot.^2);
     omega];
                          
options.g = @(T) [0.5*T*T 0       0;
                  0       0.5*T*T 0;
                  T       T       0;
                  0       0       1];

% Process noise: only for location and angle measurement.              
options.Q = 1^2*eye(3);
%% Get the test data

test_data = get_test_data();
test_data_comb = [test_data{1,1};
                  test_data{1,2};
                  test_data{1,3};
                  test_data{1,4};
                  test_data{1,5};
                  test_data{1,6}];
      
%% Particle Filter for N_seeds iterations
% Check the filter for various # of paricles.

options.numSamples = 500;
options.N_states = 4;


%% Particle Filter:Initializations
P_PF(:,:,1) = 50*eye(options.N_states);
m_PF(1,:) = [20 2.35 0 0];
options.theta = 0;

SX = gauss_rand(m_PF(1,:)',P_PF(:,:,1),options.numSamples)';
w = (1/options.numSamples)*ones(options.numSamples,1);

for i = 2:size(test_data_comb,1)
    r = randn(options.numSamples,options.N_states); 
    % Call the PF function
    [m,P,pf] =particle_filter(SX,test_data_comb(i,:),w,r,i,options);
    m_PF(i,:) = m;
    P_PF(:,:,i) = P;
    SX = pf.SX;
    neff(i,iter) = pf.neff;
    w = pf.w;
    options.theta = 
    options.theta = atan((m_PF(i,2)-m_PF(i-1,2))/(m_PF(i,1)-m_PF(i-1,1))); 
    %options.theta = abs(atan(m_PF(i-1,2)/m_PF(i-1,1))-atan(m_PF(i,2)/m_PF(i,1)));
end


      