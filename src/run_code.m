%% This is the run file for the Indoor positioning 

%% Task 1: Create the reference map.

% get the data files

% Locations 
load('../data/location.mat')

% Measurement files from SenseServe app
text_files = {'../data/train/1001_104748.txt';
              '../data/train/1001_104907.txt';
              '../data/train/1001_105101.txt';
              '../data/train/1001_105335.txt';
              '../data/train/1001_105412.txt';
              '../data/train/1001_105511.txt';
              '../data/train/1001_105606.txt';
              '../data/train/1001_105640.txt';
              '../data/train/1001_105752.txt';
              '../data/train/1001_105833.txt';
              '../data/train/1001_105902.txt';
              '../data/train/1001_110012.txt';
              '../data/train/1001_110108.txt';
              '../data/train/1001_110202.txt';
              '../data/train/1001_110232.txt';
              '../data/train/1001_110356.txt';
              '../data/train/1001_110437.txt';
              '../data/train/1001_110659.txt';
              '../data/train/1001_110758.txt';
              '../data/train/1001_110842.txt';
              };
          
% Reference map, RSS values for BLE beacons and WiFi routers and
% correponding ID's. Check load_data for details.
[reference_map, y_beacon, y_wifi,id_beacon,id_wifi] = get_reference_map(location,text_files);

%% Task 2: Radio map: estimating the RSS values all the other locations.
% For this we are using GP regression using GPStuff.

% predictive locations
x = 0:0.1:40;
y = -3:0.1:5.35;

% Check demo_regression1 from GPStuff!








