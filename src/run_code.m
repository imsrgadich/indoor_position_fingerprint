%% This is the run file for the Indoor positioning 

%% Task 1: Create the reference map.

% get locations
load('../data/location.mat')

% training data from files
text_files = get_training_data();
          
% Reference map, RSS values for BLE beacons and WiFi routers and
% correponding ID's. Check load_data for details.
[reference_map, y_beacon, y_wifi,id_beacon,id_wifi] = get_reference_map(location,text_files);

% test data: lets just take the mean of the data for now.
test_data = get_test_mean_data();

% TODO: interpolate the values.

% %% use k-NN for interpolating model: k=1
% 
% 
% %% Task 2: Radio map: estimating the RSS values all the other locations.
% % For this we are using GP regression using GPStuff.
% 
% % predictive locations
% x = 0:0.1:40;
% y = -3:0.1:5.35;

%%  Train GP with the reference map.
% The location (x,y) is the latent variable with the RSS values are the
% measurements. 
% The process model we use here is y_i = f(x_i) + n, n ~ N(0,sigma_n^2)


% Using the GPStuff 4.6 package (using few initial parameter values as 
% given in the toolbox)
lik = lik_gaussian('sigma2',0.2^2);

% select length scale for two directions (for simplicity not considering 
% change in floors), using squared exponential covariance function.
gpcf = gpcf_sexp('lengthScale',[0.5 0.5],'magnSigma2',0.2^2);  

% Setting the prior for the noise in the measurement likelihood model
pn = prior_unif();
lik = lik_gaussian(lik,'sigma2_prior',pn);

% Priors for the parameters of the covariance fucntion. 
pl = prior_unif();
pm = prior_sqrtunif();
gpcf = gpcf_sexp(gpcf,'lengthScale_prior',pl,'magnSigma2_prior',pm);

% Creating the GP model structure
gp = gp_set('lik',lik,'cf',gpcf);

% Optimizing the parameter values
opt = optimset('TolFun',1e-3,'TolX',1e-3,'Display','iter');
gp=gp_optim(gp,reference_map(:,1:2),reference_map(:,3:end),'opt',opt);














