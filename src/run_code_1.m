omega = 0.0001; %frequency
T = 1;

% Dynamic model Augmented Turn Coordinated Model
f_act = @(x,xdot,y,ydot,T,omega) ...
    [x+(xdot*sin(omega*T)/omega)-(ydot*(1-cos(omega*T))/omega);
     y+(xdot*(1-cos(omega*T))/omega)+(ydot*sin(omega*T)/omega);
     sqrt(xdot.^2+ydot.^2);
     omega];
                          
g_act = @(T) [0.5*T*T 0       0;
              0       0.5*T*T 0;
              T       T       0;
              0       0       1];
      
      
%% Particle Filter for N_seeds iterations
% Check the filter for various # of paricles.

numSamples = 100;
N_numSamples = size(numSamples,2);

% Initializations for states estimates and corresponding covarainces
m_PF = zeros(N,N_states,N_numSamples,N_seeds);
P_PF = zeros(N_states,N_states,N,N_numSamples,N_seeds);
P_PF_PSIS = P_PF;
P_PF_PSIS_S = P_PF;

% Intialize the true states and measurements matrix.
x = zeros(N,N_states,N_numSamples,N_seeds);
y = zeros(N,N_measmnts,N_numSamples,N_seeds);

% Intialize the matrix for estimated true states for Student filter Filter
m_KF = zeros(N,N_states,N_numSamples,N_seeds);
%P_KF = []; %% use it later if needed.


%% Particle Filter:Initializations
P_PF(:,:,1) = eye(options.N_states);
m_PF(1,:,iter) = [0 0];

SX = gauss_rand(m_PF(1,:,iter)',P_PF(:,:,1),nS)';
w = (1/nS)*ones(nS,1);

for i = 2:options.N
    r = randn(nS,options.N_states); 
    % Call the PF function
    [m,P,pf] =particle_filter(SX,Y(i,:),w,r,i);
    m_PF(i,:,iter) = m;
    P_PF(:,:,i,iter) = P;
    SX = pf.SX;
    neff(i,iter) = pf.neff;
    w = pf.w;
end


      