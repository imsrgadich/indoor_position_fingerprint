function [t, id_beacon, y, t_imu, id_imu, y_imu, t_wifi, id_wifi, y_wifi,location] = load_data(file,flag)
%
% SYNOPSIS
%   [t, id, y] = load_data(file)
%   [t, id, y, t_imu, id_imu, y_imu, t_wifi, id_wifi, y_wifi] = load_data(file)
%ar
% DESCRIPTION
%   Loads the data logged using the IndoorAtlas Sensserve Android app into
%   Matlab. For now, only Bluetooth and IMU data is loaded.
% 
% PARAMETERS
%   file
%       Data file name
%   flag (optional) - (default) train data
%      'test' for test data.
%
% RETURNS
%   t, id, y
%       Bluetooth timestampst s, beacon IDs (translated to 1-13), and RSS 
%       values.
%
%   t_imu, id_imu, y_imu
%       IMU timestamps, sensor IDs (accelerometer, gyroscope, etc.), and
%       data.
%
%   t_wifi, id_wifi, y_wifi
%       WiFi timestaps, ids (access point MACs), and RSS values.
%
% TODO:
%   * Return the data in structs instead of vectors for everything to
%     simplify things.
%

if nargin < 2
    flag = 'train';
elseif ~contains(flag, 'test')
    error('use correct flag')
end

    %% Definitions and Parameters
    % Blue tooth sensor ID
    SensorType = struct( ...
        'ACC', 3, ...
        'GYRO', 4, ...
        'MAG_RAW', 5, ...
        'GYRO_RAW', 6, ...
        'MAG', 7, ...
        'WIFI', 12, ...
        'BLUETOOTH', 13 ...
    );
    
    % ID's of beacons and wifi AP can be used as column # in the reference
    % map
    
    % Lookup Table Beacon ID <-> MAC
%     beacons = {
%          3, 'D2:48:C0:58:92:5F';
%          4, 'F4:2A:FF:C3:13:61';
%          5, 'F6:F4:43:BF:2A:78';
%          6, 'CD:03:21:C3:66:4F';
%          7, 'FC:53:69:7A:5C:4B';
%          8, 'D7:2B:87:29:F1:23';
%          9, 'E5:CC:23:DC:7E:1B';
%         10, 'C2:24:B6:F1:58:C5';
%         11, 'CE:FA:1D:8D:48:28';
%         12, 'DA:8A:9C:57:49:E2';
%         13, 'CA:F0:7A:87:90:12';
%         14, 'C3:6D:AB:9F:8B:04';
%         15, 'F2:7C:B0:2D:B2:1B';
%     };

  beacons = {
        % mac_id, mac_address
        3, '00:13:04:10:8C:AA';
        4, '00:13:04:10:8B:11';
        5, '00:13:04:10:8B:1D';
        6, '00:13:04:10:8B:3F';
        7, '00:13:04:10:8A:F5';
        8, '00:13:04:10:8A:F4';
        9, '00:13:04:10:8B:32';
        10,'00:13:04:10:8B:44';
        11,'00:13:04:10:8C:D1';
        12,'00:13:04:10:8C:A0';
        13,'00:13:04:10:8B:30';
        14,'00:13:04:10:8B:26';
        15,'00:13:04:10:8B:33';
        16,'00:13:04:10:8B:14';
        17,'00:13:04:10:8B:E4';
        18,'00:13:04:10:8B:F3';
        19,'00:13:04:10:8B:62';
        20,'00:13:04:10:8B:89';
        21,'00:13:04:10:8B:65';
        22,'00:13:04:10:8C:57';
        23,'00:13:04:10:8C:34';
        24,'00:13:04:10:8C:27';
        25,'00:13:04:10:8C:65';
        26,'00:13:04:10:8C:0F';
        27,'00:13:04:10:8C:6D';
        28,'00:13:04:10:8C:4A';
        29,'00:13:04:10:8C:39';
        30,'00:13:04:10:8C:6A';
    };

    % Lookup table for WIFI <-> MAC (as per WIFI present in the building)
    % Mobile app ask user to select WIFI networks mostly used in the
    % location.
    % Lookup table for WIFI <-> MAC (as per WIFI present in the building)
    % Mobile app ask user to select WIFI networks mostly used in the
    % location.
%     wifi = {
%         16,  '24:01:c7:b9:1c:8f'; 
%         17,  '24:01:c7:b9:1c:8d';
%         18,  '00:27:0d:2f:f5:ff';
%         19,  '00:27:0d:2f:f5:fd';
%         20,  '24:01:c7:b9:1c:80';
%         21,  '24:01:c7:b9:1c:82';
%         22,  '00:27:0d:08:c1:4f';
%         23,  '00:27:0d:2f:e6:dd';
%         24,  '24:01:c7:91:69:5f';
%         25, '24:01:c7:b9:1c:8e';
%         26, '00:27:0d:2f:f5:fe';
%         27, '24:01:c7:b9:1c:81';
%         28, '24:01:c7:91:69:5d';
%         29, '00:27:0d:08:c1:4e';
%         30, '24:01:c7:91:69:5e';
%         31, 'd4:d7:48:81:e9:23';
%         32, '00:27:0d:2f:f4:61';
%         33, '24:01:c7:91:69:50';
%         34, 'd4:d7:48:81:e9:22';
%         35, '00:27:0d:2f:f4:6d';
%         36, 'd4:d7:48:81:e9:20';
%         37, '00:27:0d:2f:f4:60';
%         38, '00:27:0d:2f:e6:d1';
%         39, '00:27:0d:08:c1:41';
%         40, '00:27:0d:08:c1:40';
%         41, '00:27:0d:2f:f4:6f';
%         42, '00:27:0d:08:9b:6e';        
%     };

  

    % Templates for the different types of data in the file
    formats = {
        '%f%f%f%f%f';       % Regular 3-axial sensor data
        %'%f%f%s%s%f%d%d%s'; % Bluetooth
        '%s%f%s%s%f'; % Bluetooth for Helvar
        '%s%s%f%s%s%f'; % BT with extra timestamp.
        '%f%f%s%s%d%d%d';   % WiFi
    };

    %% Load the Data
    % Stores the Bluetooth data as 
    t = [];
    id_beacon = [];
    %mac_beacon = [];
    y = [];
    t_wifi = [];
    id_wifi = [];
    y_wifi = [];
    t_imu = [];
    id_imu = [];
    y_imu = [];

    fp = fopen(file);

    % comment this line no needed. Skip first line and get x and y
    % coordinates from next two lines onlg if train data
    if contains(flag,'train')
        for k=1:3
            line = fgets(fp);
            switch k
                case 2
                    data = textscan(line, '%s%f', 'Delimiter', ':');
                    x_coord = data{2}/1000;
                    
                case 3
                    data = textscan(line, '%s%f', 'Delimiter', ':');
                    y_coord = data{2}/1000;
            end
        end
        location = [x_coord,y_coord];
    end
    
    
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
            
            % Parse Bluetooth data %changed the format to get 
            if iFormats == 2
                switch data{2}
                    case SensorType.BLUETOOTH
                        % For Active Aheads we have a pattern
                        try
                             iId = strcmp(data{4}, beacons(:, 2));
                        catch
                            continue
                        end
                        
                        % If we decide to mac address instead of mac_id.
                        %iId = contains(data{4}, '00:13:04:10');
                        %iId = contains(data{3}, 'Kontakt');
                        if sum(iId) == 1
                            t = [t, data{1}];
                            id_beacon = [id_beacon, beacons{iId, 1}];
                            %mac_beacon = [mac_beacon, data{4}];
                            y = [y, data{5}];
                        end
                        
                    case SensorType.WIFI
                        wId = strcmp(data{4}, wifi(:, 2));
                        if sum(wId) == 1
                            t_wifi = [t_wifi, data{1}];
                            %id_wifi = [id_wifi, wifi{wId, 1}];
                            mac_beacon = [mac_beacon, data{4}];
                            y_wifi = [y_wifi, data{5}];
                        end
                        
                    case {SensorType.ACC, SensorType.GYRO}
                        t_imu = [t_imu, data{1}];
                        id_imu = [id_imu, data{2}];
                        y_imu = [y_imu, cell2mat(data(3:5)).'];
                        
                    otherwise
                        %error('Unknown data type.');
                end
            else
                switch data{3}
                    case SensorType.BLUETOOTH
                        % For Active Aheads we have a pattern
                        iId = strcmp(data{5}, beacons(:, 2));
                        
                        % If we decide to mac address instead of mac_id.
                        %iId = contains(data{4}, '00:13:04:10');
                        %iId = contains(data{3}, 'Kontakt');
                        if sum(iId) == 1
                            t = [t, data{1}];
                            id_beacon = [id_beacon, beacons{iId, 1}];
                            %mac_beacon = [mac_beacon, data{4}];
                            y = [y, data{6}];
                        end
                        
                    case SensorType.WIFI
                        wId = strcmp(data{4}, wifi(:, 2));
                        if sum(wId) == 1
                            t_wifi = [t_wifi, data{1}];
                            %id_wifi = [id_wifi, wifi{wId, 1}];
                            mac_beacon = [mac_beacon, data{4}];
                            y_wifi = [y_wifi, data{5}];
                        end
                        
                    case {SensorType.ACC, SensorType.GYRO}
                        t_imu = [t_imu, data{1}];
                        id_imu = [id_imu, data{2}];
                        y_imu = [y_imu, cell2mat(data(3:5)).'];
                        
                    otherwise
                        %error('Unknown data type.');
                end
            end
                
        end
    end
    
    fclose(fp);
end