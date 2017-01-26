%% load the txt files here using the load_data function.
%% Get the RSS, WIFI data for each measurement location 
%  (as given in the location.mat)

function [map, y_beacon, y_wifi,id_beacon,id_wifi] = get_reference_map(location,files)

% matrix for reference map: # predefined input locations based on the text
% file and measurements [(x,y) + 13 beacons' RSS + 177 WIFI's RSS]
map = zeros(size(location,1),15);
          
for i = 1:size(map,1)
    [~, id_beacon, y_beacon, ~, ~, ~, ~, id_wifi, y_wifi] = load_data(files{i});
    
    % location 
    map(i,1:2) = location(i,:);
    
    % for beacons average value of RSS
    for j = 3:15 
        b_ind = id_beacon == j;
        map(i,j) = mean(y_beacon(b_ind));
    end
    
%     % for wifi average value of RSS
%     for k= 16:42
%         w_ind = id_wifi == k;
%         map(i,k) = mean(y_wifi(w_ind));  
%     end
end

% if some MAC is not heard at some location, assign a minimum dB value or
% get the device sensitivity level, -93dBm for BLE beacons.
% https://store.kontakt.io/our-products/27-beacon.html
% we dont know the minimum sensitivity of WiFi, we are assuming it to be
% -110 dB.

% Get the indices of the beacons with NaN RSS value.
[i,j]=ind2sub(size(map),find(isnan(map)));

% get only the BLE beacons which are in the columns 3 to 15.
map(i(1:find(j == 15, 1, 'last' )),j(1:find(j == 15, 1, 'last' )))= -93;

% rest which are WiFi beacons are set to -110 (assumed)
map(isnan(map)) = -110;
end

