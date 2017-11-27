%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function likelihood = gp_loglikelihood(x,y,id, options)

likelihood = zeros(size(x,1),1);
sigma = exp(options.parameters(id-2,4));

for i = 1:size(y,1) 
        mean_star = gpPred(x,id(i)-2,options);
        mean_star = mean_star - 115;
        lk(:,i) = (0.5*(y(i)-mean_star).^2)./sigma(i).^2 + 0.5*log(2*pi*sigma(i).^2);
        likelihood = likelihood - lk(:,i);
        %likelihood(:,i) = (0.5*(y(i)-mean_star).^2)./sigma_star.^2 - 0.5*log(2*pi*sigma_star.^2);
end
end