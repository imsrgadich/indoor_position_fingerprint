%% load the txt files here using the load_data function.
%% Get the RSS, WIFI data for each measurement location 
%  (as given in the location.mat)

function map = get_reference_map(location,files)

% matrix for reference map: # predefined input locations based on the text
% file and measurements [(x,y) + 13 beacons' RSS + 177 WIFI's RSS]
map = zeros(size(location,1),42);
          
for i = 1:size(map,1)
    [~, id_beacon, y_beacon, ~, ~, ~, ~, id_wifi, y_wifi] = load_data(files{i});
    
    % location 
    map(i,1:2) = location(i,:);
    
    % for beacons average value of RSS
    for j = 3:15 
        b_ind = id_beacon == j;
        map(i,j) = mean(y_beacon(b_ind));
    end
    
    % for wifi average value of RSS
    for k= 16:42
        w_ind = id_wifi == k;
        map(i,k) = mean(y_wifi(w_ind));  
    end
end

map(isnan(map)) = 0;

end

