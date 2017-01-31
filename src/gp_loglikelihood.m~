%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function likelihood = gp_loglikelihood(x,y,options)

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
        mean_star(mean_star < -100 | mean_star > -50) = -100;
        sigma_star = sqrt(abs(diag(K_)' - sum(Lk.^2))');
        %sigma2_star_temp = K_ - (Lk'*Lk);
        for j = 1:length(y)
            likelihood = likelihood - (0.5*(y(j)-mean_star).^2)./sigma_star.^2 - 0.5*log(2*pi*sigma_star.^2);
        end
end
end