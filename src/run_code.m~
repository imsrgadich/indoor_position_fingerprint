%% This is the run file for the Indoor positioning 

%% Task 1: Create the reference map.

% get locations
load('../data/location.mat')

plot()

% training data from files
text_files = get_training_data();
          
% Reference map, RSS values for BLE beacons and WiFi routers and
% correponding ID's. Check load_data for details.
[reference_map, y_beacon, y_wifi,id_beacon,id_wifi] = get_reference_map(location,text_files);

% test data: lets just take the mean of the data for now.
test_data = get_test_mean_data();

%% use k-NN for interpolating model: k=1


%% Task 2: Radio map: estimating the RSS values all the other locations.
% For this we are using GP regression using GPStuff.

% predictive locations
x = 0:0.1:40;
y = -3:0.1:5.35;










