%% This is the run file for the Indoor positioning 

%  'log(constant.constSigma2)'
%  'log(sexp.magnSigma2)'
%  'log(sexp.lengthScale x 2)'
%  'log(gaussian.sigma2)'


%% Task 1: Create the reference map.

% get locations
load('/home/imsrgadich/Documents/gitrepos/aalto/indoor_position_fingerprint/data/helvar_rd/locations.mat')
% load('../data/aalto_kwarkki/reference_map/reference_map_updated.mat')
% reference_map = reference_map_updated;
train_points = location;

% training data from files
text_files = get_training_data();
          
% Reference map, RSS values for BLE beacons and WiFi routers and
% correponding ID's. Check load_data for details.
[reference_map, y_beacon, y_wifi,id_beacon,id_wifi] = get_reference_map(train_points,text_files);

% test data: lets just take the mean of the data for now.
train_data = reference_map(:,3:max(id_beacon));
test_data = get_test_data();

%% Normalize the training points.
min_train_data = min(train_data(:));
max_train_data = max(train_data(:));

mean_train_data = mean(train_data(:),1);
std_train_data = std(train_data(:));

norm_ref_map = (train_data - min_train_data)/(max_train_data - min_train_data);
mean_norm_ref_map = (train_data - mean_train_data)/(std_train_data);
% TODO: interpolate the values.

% %% use k-NN for interpolating model: k=1
% 
% 
% %% Task 2: Radio map: estimating the RSS values all the other locations.
% % For this we are using GP regression using GPStuff.
% 
% predictive locations
x = 0:1:6;
y = 0:1:26;

[X_test,Y_test] = meshgrid(x,y);
test_points = [X_test(:) Y_test(:)];

%%  Train GP with the reference map.
% The location (x,y) is the latent variable with the RSS values are the
% measurements. 
% The process model we use here is y_i = f(x_i) + n, n ~ N(0,sigma_n^2)

% Using the GPStuff 4.6 package (using few initial parameter values as 
% given in the toolbox)


% lik = lik_gaussian('sigma2',4^2);
% 
% % % select length scale for two directions (for simplicity not considering 
% % % change in floors), using squared exponential covariance function.
% gpcf = gpcf_sexp('lengthScale',[3 3],'magnSigma2',2^2);  
% % 
% % % Setting the prior for the noise in the measurement likelihood model
% % % 
% % % % Priors for the parameters of the covariance fucntion. 
% pl = prior_logunif();
% %pl = prior_fixed();
% pm = prior_logunif();
% gpcf = gpcf_sexp(gpcf,'lengthScale_prior',pl,'magnSigma2_prior',pm);
% % 
% % select length scale for two directions (for simplicity not considering 
% % change in floors), using squared exponential covariance function
% % Setting the prior for the noise in the measurement likelihood model
% pn = prior_logunif();
% lik = lik_gaussian(lik,'sigma2_prior',pn);
% 
% % Creating the GP model structure
% gp = gp_set('lik',lik,'cf',gpcf);
% 
% % Optimizing the parameter values
% opt = optimset('TolFun',1e-3,'TolX',1e-3,'Display','iter');


%% Juho

clear ('gp','gpcf','lik','pn','pl','pm','w','opt')
% likelihood
lik = lik_gaussian('sigma2',4^2, 'sigma2_prior', prior_logunif());

% kernels
gpcf_const = gpcf_constant('constSigma2',10, 'constSigma2_prior', prior_logunif());
gpcf_se = gpcf_sexp('lengthScale', [3 3], 'lengthScale_prior', prior_logunif(), ...
                 'magnSigma2', 2^2, 'magnSigma2_prior', prior_logunif());  
             
gp = gp_set('lik',lik,'cf',{gpcf_const,gpcf_se});
opt = optimset('TolFun',1e-3,'TolX',1e-3,'Display','iter');

for i = 3 : max(id_beacon)
    [gp]=gp_optim(gp,reference_map(:,1:2),reference_map(:,i),'opt',opt);
    w(i,:) = gp_pak(gp);
    [mean_gp, var] = gp_pred(gp, reference_map(:,1:2),reference_map(:,i), test_points);
    mean_matrix=vec2mat(mean_gp,size(X_test,2));
    var_matrix=vec2mat(var,size(X_test,2));
%     var_plus_matrix = mean_matrix + 2*sqrt(var_matrix);
%     var_minus_matrix = mean_matrix - 2*sqrt(var_matrix);
    figure(i), gp_plot(gp,reference_map(:,1:2),reference_map(:,i))
end

%% %% Fixed hyperparameters for testing
% epsilon = 1^2;    % noise variance
% signal_var = 2.5^2;
% length_scale = [6.5 6.5]; % what if we have a wall?
% 
% %% Training data kernel
% K = gaussian_kernel(train_points,train_points,length_scale,signal_var);
% L = chol(K,'lower');
% alpha = L'\(L\reference_map(:,5));
% pred = gaussian_kernel(train_points,test_points,length_scale,signal_var)'*alpha;
% 
% pred_matrix=vec2mat(pred,size(X_test,2));
% figure,surf(X_test,Y_test,pred_matrix)
% axis tight, hold on

% for i= 1:length(train_points)
%     
%     [~,ind]=max(gaussian_kernel(train_points(i), test_points,length_scale,signal_var));
%     
%     test_index(i)=ind;
%     
% end

plot3(train_points(:,1),train_points(:,2),reference_map(:,5),'.','MarkerSize',30,'MarkerFaceColor','r')


% %% Old priors for reference
% % lik = lik_gaussian('sigma2',30^2);
% % 
% % % % select length scale for two directions (for simplicity not considering 
% % % % change in floors), using squared exponential covariance function.
% % gpcf = gpcf_sexp('lengthScale',[100 100],'magnSigma2',20^2);  
% % % 
% % % % Setting the prior for the noise in the measurement likelihood model
% % % % 
% % % % % Priors for the parameters of the covariance fucntion. 
% % pl = prior_gaussian('mu',2,'s2',30);
% % %pl = prior_fixed();
% % pm = prior_gaussian('mu',2,'s2',30);
% % gpcf = gpcf_sexp(gpcf,'lengthScale_prior',pl,'magnSigma2_prior',pm);
% % % 
% % % select length scale for two directions (for simplicity not considering 
% % % change in floors), using squared exponential covariance function
% % % Setting the prior for the noise in the measurement likelihood model
% % pn = prior_gaussian('mu',4,'s2',30);
% % lik = lik_gaussian(lik,'sigma2_prior',pn);
% % 
% % % Creating the GP model structure
% % gp = gp_set('lik',lik,'cf',gpcf);
% % 
% % % Optimizing the parameter values
% % opt = optimset('TolFun',1e-3,'TolX',1e-3,'Display','iter');
% 
% 











