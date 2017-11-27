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
                get_reference_map_new(options)

map = zeros(options.num_train_points,options.num_beacons+2); % 2 for (x,y)

map = cell(1,options.num_beacons);
for i = 1:options.num_train_points
    
    % Get the file name
    files = strcat(options.training_file_location,num2str(i),'.txt');
    % Load the data first
    [~, id_beacon, y_beacon, ~, ~, ~, ~, id_wifi, y_wifi,locations] = load_data(files);
    
    temp_map = [];
    % location 
    options.min_rssi = 0;
  
    %% Taking the mean as we dont have the infra to mask the channels.
    %  not considering the difference in performance of the BLE channels.
    %  Hence taking the mean of the distributions.
    
    % if some MAC is not heard at some location, assign a minimum dB value or
% get the device sensitivity level for BLE beacons.

    
    % get all the values of 
    for j = 3:options.num_beacons+2
        b_ind = id_beacon == j;
        y_temp = y_beacon(b_ind);
        
        if ~isempty(y_temp)
            temp_map = [repmat(locations,size(y_temp,2),1) y_temp'];
        else
            temp_map = [locations NaN];
        end
        
        min_rssi = min(y_temp);
        if min_rssi < options.min_rssi
            options.min_rssi = min_rssi;
        end
        map{j-2} = [map{j-2};temp_map];
    end
    
end

for i = 1:length(map) 
    temp_map = map{i};
   if sum(sum(isnan(temp_map))) > 0
       ind = isnan(temp_map);
       temp_map(ind) =  options.min_rssi;
   end
   temp_map(:,3) = temp_map(:,3) - options.min_rssi +10;
   map{i} = temp_map ;
end

% to make zero as the minimum point in the data. This would make minimum
% point in the map same as zero mean of the GP. This was to make better the
% boundary performance of the GP's

%map(:,3:end) = map(:,3:end) - options.min_rssi +10;                  
end

