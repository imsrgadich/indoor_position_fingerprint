function [test_data,tt,id,y] = get_test_data(options)


% test_text_files = {'../data/test/1001_113436.txt';
%               '../data/test/1001_113627.txt';
%               '../data/test/1001_113814.txt';
%               '../data/test/1001_113915.txt';
%               '../data/test/1001_114004.txt';
%               '../data/test/1001_114142.txt';
%               '../data/test/0702_083456.txt';
%               };

test_text_files = {'/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/test_data/test_meas_4.txt';
                   '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/test_data/test_meas_5.txt';
                   '/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/data/helvar_rd/test_data/test_meas_6.txt';
                  };
          
test_data = {};
tt= {};
id={};
y={};

for i = 1:size(test_text_files,1)
    [t_beacon, id_beacon, y_beacon, ~, ~, ~, ~, ~, ~] = ...
                                             load_data(test_text_files{i});
    % Spliting the string of timestamp to get the seconds part and
    % converting to double.
    
    out = datevec(t_beacon);
    t_beacon=out(:,5)*60+out(:,6);
    
    temp_test_data = [];
    for t=1:2:ceil(max(t_beacon))
        ind = find(t_beacon <t+1 & t > t_beacon-1);
        temp_id_beacon = id_beacon(ind);
        temp_y_beacon = y_beacon(ind);
         % for beacons average value of RSS
         for j = 1:max(id_beacon)-2
             b_ind = temp_id_beacon == j+2;
             if sum(b_ind)==0
                 temp_test_data(ceil(t/2),j) = options.min_rssi; % minimum sensitivity of device
             else
                 temp_test_data(ceil(t/2),j) = mean(temp_y_beacon(b_ind));
             end
         end
    end
    
    tt{i} = t_beacon;
    id{i} = id_beacon';
    y{i} = y_beacon';
    test_data{i} = temp_test_data;  
end

end