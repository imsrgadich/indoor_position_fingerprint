function test_data = get_test_mean_data()


test_text_files = {'../data/test/1001_113436.txt';
              '../data/test/1001_113627.txt';
              '../data/test/1001_113814.txt';
              '../data/test/1001_113915.txt';
              '../data/test/1001_114004.txt';
              '../data/test/1001_114142.txt';
              };
          
test_data = zeros(size(test_text_files,1),42);
          
for i = 1:size(test_text_files,1)
    [~, id_beacon, y_beacon, ~, ~, ~, ~, id_wifi, y_wifi] = ...
                                             load_data(test_text_files{i});
    
    % for beacons average value of RSS
    for j = 3:15 
        b_ind = id_beacon == j;
        test_data(i,j) = mean(y_beacon(b_ind));
    end
    
    % for wifi average value of RSS
    for k= 16:42
        w_ind = id_wifi == k;
        test_data(i,k) = mean(y_wifi(w_ind));  
    end    
end

% Get the indices of the beacons with NaN RSS value.
[i,j]=ind2sub(size(test_data),find(isnan(test_data)));

% get only the BLE beacons which are in the columns 3 to 15.
test_data(i(1:find(j == 15, 1, 'last' )),j(1:find(j == 15, 1, 'last' )))= -93;

% rest which are WiFi beacons are set to -110 (assumed)
test_data(isnan(test_data)) = -110;

end