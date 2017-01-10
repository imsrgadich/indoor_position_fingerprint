function [t, id, y, t_imu, id_imu, y_imu, t_wifi, id_wifi, y_wifi] = load_data(file)
% Load Sensserve logging data
%
% SYNOPSIS
%   [t, id, y] = load_data(file)
%   [t, id, y, t_imu, id_imu, y_imu, t_wifi, id_wifi, y_wifi] = load_data(file)
%
% DESCRIPTION
%   Loads the data logged using the IndoorAtlas Sensserve Android app into
%   Matlab. For now, only Bluetooth and IMU data is loaded.
% 
% PARAMETERS
%   file
%       Data file name
%
% RETURNS
%   t, id, y
%       Bluetooth timestamps, beacon IDs (translated to 1-13), and RSS 
%       values.
%
%   t_imu, id_imu, y_imu
%       IMU timestamps, sensor IDs (accelerometer, gyroscope, etc.), and
%       data.
%
%   t_wifi, id_wifi, y_wifi
%       WiFi timestaps, ids (access point MACs), and RSS values.
%
% VERSION
%   2016-11-01
%
% AUTHORS
%   Roland Hostettler <roland.hostettler@aalto.fi>

% TODO:
%   * Return the data in structs instead of vectors for everything to
%     simplify things.

    %% Definitions and Parameters
    % Bluetooth sensor ID
    SensorType = struct( ...
        'ACC', 3, ...
        'GYRO', 4, ...
        'MAG_RAW', 5, ...
        'GYRO_RAW', 6, ...
        'MAG', 7, ...
        'WIFI', 12, ...
        'BLUETOOTH', 13 ...
    );

    % Lookup Table Beacon ID <-> MAC
    beacons = {
         1, 'D2:48:C0:58:92:5F';
         2, 'F4:2A:FF:C3:13:61';
         3, 'F6:F4:43:BF:2A:78';
         4, 'CD:03:21:C3:66:4F';
         5, 'FC:53:69:7A:5C:4B';
         6, 'D7:2B:87:29:F1:23';
         7, 'E5:CC:23:DC:7E:1B';
         8, 'C2:24:B6:F1:58:C5';
         9, 'CE:FA:1D:8D:48:28';
        10, 'DA:8A:9C:57:49:E2';
        11, 'CA:F0:7A:87:90:12';
        12, 'C3:6D:AB:9F:8B:04';
        13, 'F2:7C:B0:2D:B2:1B';
    };

    % Lookup table for WIFI <-> MAC (as per WIFI present in the building)
    % Mobile app ask user to select WIFI networks mostly used in the
    % location.
    wifi = {
        1,  '24:01:c7:b9:1c:8f'; 
        2,  '24:01:c7:b9:1c:8d';
        3,  '00:27:0d:2f:f5:ff';
        4,  '00:27:0d:2f:f5:fd';
        5,  '24:01:c7:b9:1c:80';
        6,  '24:01:c7:b9:1c:82';
        7,  '00:27:0d:08:c1:4f';
        8,  '00:27:0d:2f:e6:dd';
        9,  '24:01:c7:91:69:5f';
        10, '24:01:c7:b9:1c:8e';
        11, '00:27:0d:2f:f5:fe';
        12, '24:01:c7:b9:1c:81';
        13, '24:01:c7:91:69:5d';
        14, '00:27:0d:08:c1:4e';
        15, '24:01:c7:91:69:5e';
        16, 'd4:d7:48:81:e9:23';
        17, '00:27:0d:2f:f4:61';
        18, '24:01:c7:91:69:50';
        19, 'd4:d7:48:81:e9:22';
        20, '00:27:0d:2f:f4:6d';
        21, 'd4:d7:48:81:e9:20';
        22, '00:27:0d:2f:f4:60';
        23, '00:27:0d:2f:e6:d1';
        24, '00:27:0d:08:c1:41';
        25, '00:27:0d:08:c1:40';
        26, '00:27:0d:2f:f4:6f';
        27, '00:27:0d:08:9b:6e';        
    };
    

    % Templates for the different types of data in the file
    formats = {
        '%f%f%f%f%f';       % Regular 3-axial sensor data
        '%f%f%s%s%d%d%d';   % WiFi
        '%f%f%s%s%f%d%d%s'; % Bluetooth
    };

    %% Load the Data
    % Stores the Bluetooth data as 
    t = [];
    id = [];
    y = [];
    t_wifi = [];
    id_wifi = {};
    y_wifi = [];
    t_imu = [];
    id_imu = [];
    y_imu = [];

    fp = fopen(file);
    done = false;
    while ~done
        % Get a single line from the file and then try to parse it.
        line = fgetl(fp);
        if ~ischar(line)
            done = true;
        else
            parsed = false;
            iFormats = 1;
            while ~parsed && iFormats <= size(formats, 1)
                format = formats{iFormats};
                data = textscan(line, format, 'Delimiter', ',');
                
                % Check if all fields of the template format string
                % could be matched by looking at the no. of rows in the
                % last data field. It is 0 if not all fields could be
                % matched and 1 if it could be matched. If it could be
                % matched, it should be that this is the correct tamplate
                % and we accept it.
                if size(data{end}, 1) == 1
                    parsed = true;
                else
                    iFormats = iFormats+1;
                end
            end
            
            if ~parsed
                fclose(fp);
                error('Could not parse data line: %s', line);
            end
            
            % Parse Bluetooth data
            switch data{2}
                case SensorType.BLUETOOTH
                    iId = strcmp(data{4}, beacons(:, 2));
                    if sum(iId) == 1
                        t = [t, data{1}];               
                        id = [id, beacons{iId, 1}];
                        y = [y, data{5}];
                    end
                    
                case SensorType.WIFI
                    % TODO:
                    % -0.0320,12,SS Wi-Fi Network,80:ea:96:eb:33:26,-73,8143787952,2437
                    t_wifi = [t_wifi, data{1}];
                    id_wifi(end+1) = data{4};
                    y_wifi = [y_wifi, data{5}];
                
                case {SensorType.ACC, SensorType.GYRO}
                    t_imu = [t_imu, data{1}];
                    id_imu = [id_imu, data{2}];
                    y_imu = [y_imu, cell2mat(data(3:5)).'];
                
                otherwise
                    %error('Unknown data type.');
            end
        end
    end
    
    fclose(fp);
end
