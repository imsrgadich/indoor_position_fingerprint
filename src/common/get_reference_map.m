%% GET_REFERENCE_MAP: function to get the reference map for the indoor positioning
%
%  [map, y_beacon, y_wifi,id_beacon,id_wifi,options] = get_reference_map(options) 
%
% input :
%  options - 
%   num_train_points - number of calibration points.
%   training_file_location - file location where text files for calibration
%                    data are present.
%   num_beacons - number of beacons.
%   
% output:
%   map - the reference map
%   y_beacon - the rssi values corresponding to the id_beacon.
%   y_wifi - the rssi value of the wifi.
%   id_beacon - the id of the beacon as set in load_data function.
%   id_wifi - the id of the wifi mac as set in load_data function.
%   options:
%       min_rssi - the minimum rssi as seen by the measurement application.
%       locations - locations where the calibration data is taken.
%
% load the txt files here using the load_data function.
% Get the RSS, WIFI data for each measurement location 
%  (as given in the location.mat)

function [map, y_beacon, y_wifi,id_beacon,id_wifi,options] = ...
                get_reference_map(options)

map = zeros(options.num_train_points,options.num_beacons+2); % 2 for (x,y)

for i = 1:options.num_train_points
    
    % Get the file name
    files = strcat(options.training_file_location,num2str(i),'.txt');
    % Load the data first
    [~, id_beacon, y_beacon, ~, ~, ~, ~, id_wifi, y_wifi, options.locations] = load_data(files);
    
    % location 
    map(i,1:2) = options.locations;
  
    %% Taking the mean as we dont have the infra to mask the channels.
    %  not considering the difference in performance of the BLE channels.
    %  Hence taking the mean of the distributions.
    
    % for beacons average value of RSS
    for j = 3:max(id_beacon)
        b_ind = id_beacon == j;
        map(i,j) = mean(y_beacon(b_ind));
    end
    
end

% if some MAC is not heard at some location, assign a minimum dB value or
% get the device sensitivity level for BLE beacons.
options.min_rssi = min(min(map)); 
map(isnan(map)) = options.min_rssi;

% to make zero as the minimum point in the data. This would make minimum 
% point in the map same as zero mean of the GP. This was to make better the
% boundary performance of the GP's

map(:,3:end) = map(:,3:end) - options.min_rssi +10;                  
end

