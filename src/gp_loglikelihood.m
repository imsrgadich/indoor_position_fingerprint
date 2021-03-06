%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function likelihood = gp_loglikelihood(x,y,options)

% This function maximizes the joint likelihood with resepct to the position 
% [1].
% The GP method here doesn't model the RSSI input error [1].
% SE and Matern were used as covariance functions. 
% 
% [1] M. Aravecchia and S. Messelodi. Gaussian process for rss-based       
%     localisation. InWireless and Mobile Computing, Networking and 
%     Communications (WiMob),2014 IEEE 10th International Conference on, 
%     pages 654659, Oct 2014.



likelihood = zeros(size(x,1),1);
parameters = exp(options.parameters);
train_data = options.locations;
reference_map = options.reference_map(:,3:end);

for i = 1:size(options.parameters,1)
   
        K = gaussian_kernel(train_data,train_data,parameters(i,3:4),parameters(i,2))+ parameters(i,1)+parameters(i,5);
        k_star = gaussian_kernel(train_data,x,parameters(i,3:4),parameters(i,2))+ parameters(i,1);
        K_ = gaussian_kernel(x,x,parameters(i,3:4),parameters(i,2))+ parameters(i,1);
        
        L = chol(K,'lower');
        Lk = L \ k_star;
        
        mean_star = Lk'*(L\reference_map(:,i));
        mean_star(mean_star < -100 | mean_star > -50 | (0>x(:,1) | x(:,1)>40) | (-3>x(:,2) | x(:,2)>5.35)) = -100;
        

        sigma_star = sqrt(abs(diag(K_)' - sum(Lk.^2))');
        %sigma2_star_temp = K_ - (Lk'*Lk);
        
        likelihood = likelihood - (0.5*(y(i)-mean_star).^2)./sigma_star.^2 - 0.5*log(2*pi*sigma_star.^2);
        %likelihood(:,i) = (0.5*(y(i)-mean_star).^2)./sigma_star.^2 - 0.5*log(2*pi*sigma_star.^2);
        
        %% for the prediction to get the noisy 
end
end