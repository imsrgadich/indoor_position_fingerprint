%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function likelihood = knn_likelihood(x,y,options)

train_data = options.locations;
reference_map = options.reference_map(:,3:end);


inv_dist=1./sum((repmat(y,size(reference_map,1),1) - reference_map).^2,2);
[val,ind]=sort(inv_dist,1,'descend');

sorted_train_data=train_data(ind,:);

ref_inv_dist = 1./sqrt(diag(x*x')*ones(1,size(sorted_train_data,1)) +...
     ones(size(x,1),1)*diag(sorted_train_data*sorted_train_data')' ...
     - 2*x*sorted_train_data');

likelihood = sum(repmat(val',size(x,1),1) .* ref_inv_dist,2); 


end