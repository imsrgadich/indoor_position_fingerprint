function test_data = get_test_data()


% test_text_files = {'../data/test/1001_113436.txt';
%               '../data/test/1001_113627.txt';
%               '../data/test/1001_113814.txt';
%               '../data/test/1001_113915.txt';
%               '../data/test/1001_114004.txt';
%               '../data/test/1001_114142.txt';
%               '../data/test/0702_083456.txt';
%               };

test_text_files = {'../data/helvar_rd/test/2017.09.06.18.08.18.txt';
              };
          
test_data = {};
          
for i = 1:size(test_text_files,1)
    [t_beacon, id_beacon, y_beacon, ~, ~, ~, ~, ~, ~] = ...
                                             load_data(test_text_files{i});
    % Spliting the string of timestamp to get the seconds part and
    % converting to double.
    t_beacon=regexp(t_beacon, '[:]', 'split');
    t_beacon = str2double(cellfun(@(x) x{3}, t_beacon, 'uni', 0));
    temp_test_data = [];
    for t=1:ceil(max(t_beacon))
        ind = find(t_beacon <t & t > t_beacon-1);
        temp_id_beacon = id_beacon(ind);
        temp_y_beacon = y_beacon(ind);
         % for beacons average value of RSS
         for j = 1:max(id_beacon)-2
             b_ind = temp_id_beacon == j+2;
             if sum(b_ind)==0
                 temp_test_data(t,j) = -93; % minimum sensitivity of device
             else
                 temp_test_data(t,j) = mean(temp_y_beacon(b_ind));
             end
         end
    end
    
    test_data{i} = temp_test_data;
   
    
    
%     % for wifi average value of RSS
%     for k= 16:42
%         w_ind = id_wifi == k;
%         test_data(i,k) = mean(y_wifi(w_ind));  
%     end    
end


end