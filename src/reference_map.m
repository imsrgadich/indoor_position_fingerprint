%% load the txt files here using the load_data function.

%% Get the RSS, WIFI data for each measurement location 
%  (as given in the location.mat)

text_files = {'1001_104748.txt';
              '1001_104907.txt';
              '1001_105101.txt';
              '1001_105335.txt';
              '1001_105412.txt';
              '1001_105511.txt';
              '1001_105606.txt';
              '1001_105640.txt';
              '1001_105752.txt';
              '1001_105833.txt';
              '1001_105902.txt';
              '1001_110012.txt';
              '1001_110108.txt';
              '1001_110202.txt';
              '1001_110232.txt';
              '1001_110356.txt';
              '1001_110437.txt';
              '1001_110659.txt';
              '1001_110758.txt';
              '1001_110842.txt'};
          
for i = 1:20
    [t, id, y, t_imu, id_imu, y_imu, t_wifi, id_wifi, y_wifi] = load_data(file);
end