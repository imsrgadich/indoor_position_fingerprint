function text_files = get_training_data()

% get the data files


%% Measurement files from SenseServe app
% text_files = {'/home/imsrgadich/Documents/gitrepos/aalto/indoor_position_fingerprint/data/aalto_kwarkki/train/1001_104748.txt';
%               '/home/imsrgadich/Documents/gitrepos/aalto/indoor_position_fingerprint/data/aalto_kwarkki/train/1001_104907.txt';
%               '../data/train/1001_105101.txt';
%               '../data/train/1001_105335.txt';
%               '../data/train/1001_105412.txt';
%               '../data/train/1001_105511.txt';
%               '../data/train/1001_105606.txt';
%               '../data/train/1001_105640.txt';
%               '../data/train/1001_105752.txt';
%               '../data/train/1001_105833.txt';
%               '../data/train/1001_105902.txt';
%               '../data/train/1001_110012.txt';
%               '../data/train/1001_110108.txt';
%               '../data/train/1001_110202.txt';
%               '../data/train/1001_110232.txt';
%               '../data/train/1001_110356.txt';
%               '../data/train/1001_110437.txt';
%               '../data/train/1001_110659.txt';
%               '../data/train/1001_110758.txt';
%               '../data/train/1001_110842.txt';
%               };
          
% text_files = {
%               '../data/helvar_rd/train/2017.09.06.17.41.09.txt';
%               '../data/helvar_rd/train/2017.09.06.17.43.01.txt';
%               '../data/helvar_rd/train/2017.09.06.17.49.34.txt';
%               '../data/helvar_rd/train/2017.09.06.17.56.25.txt';
%               '../data/helvar_rd/train/2017.09.06.18.01.31.txt';
%               '../data/helvar_rd/train/2017.09.06.18.04.56.txt';
%               };


%% for luminaires
% text_files = {
%               '../../data/helvar_rd/luminaire/2017.09.10.22.52.17.txt';
%               '../../data/helvar_rd/luminaire/2017.09.10.23.20.38.txt';
%               '../../data/helvar_rd/luminaire/2017.09.10.23.40.06.txt';
%               '../../data/helvar_rd/luminaire/2017.09.10.23.57.05.txt';
%     };


%% Orientation

% text_files = {
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_2/2017.09.09.22.49.22.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_2/2017.09.09.23.05.59.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_2/2017.09.09.23.25.26.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_2/2017.09.10.00.48.45.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_2/2017.09.10.07.31.20.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_2/2017.09.10.07.46.41.txt';
%     };

% text_files = {
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_1/2017.09.10.09.25.51.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_1/2017.09.10.09.41.52.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_1/2017.09.10.10.16.39.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_1/2017.09.10.11.00.44.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/orientation/loc_1/2017.09.10.11.27.01.txt';           
%     };

%% User Presence

% text_files = {
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_1/2017.09.08.12.58.33.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_1/2017.09.08.13.14.22.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_1/2017.09.08.13.29.33.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_1/2017.09.08.13.44.49.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_1/2017.09.08.14.02.08.txt';           
%     };

% text_files = {
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_2/2017.09.09.18.34.09.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_2/2017.09.09.17.44.58.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_2/2017.09.09.18.00.16.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_2/2017.09.09.18.16.28.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_2/2017.09.09.18.50.28.txt';           
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/user_presence/loc_2/2017.09.09.20.13.37.txt';           
%     };

%% Smartphone

% text_files = {
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/smartphone/loc_1/2014.05.23.17.11.18.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/smartphone/loc_1/2017.09.09.20.11.22.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/smartphone/loc_1/2017.09.09.23.24.20.txt';            
%     };

% text_files = {
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/ware_house_vantaa/smartphone/loc_2/2014.05.25.03.45.58.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/ware_house_vantaa/smartphone/loc_2/2017.09.11.09.15.44.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/ware_house_vantaa/smartphone/loc_2/2017.09.11.09.51.35.txt';
%     };


% text_files = {
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/luminaire/2017.09.10.22.52.17.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/luminaire/2017.09.10.23.20.38.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/luminaire/2017.09.10.23.40.06.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/luminaire/2017.09.10.23.57.05.txt';
%               
%     };


% %% half power
% text_files = {
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/half_power_8b3f/2017.09.29.15.41.29.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/half_power_8b3f/2017.09.29.15.47.06.txt';
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/half_power_8b3f/2017.09.29.15.49.26.txt';            
%     };

% %% comparison with radio-analyzer.
% text_files = {
%               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/radio-analyzer/kontact_b2_1b/full_power/full_power_B2_1B_outside.txt';
%     };

%% comparison with radio-analyzer.
text_files = {
              '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/calibration_data/1.txt';
              '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/calibration_data/1.txt';
              '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/calibration_data/1.txt';
               '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/calibration_data/1.txt';
              '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/calibration_data/1.txt';
              '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/calibration_data/1.txt';
    };



end