files = get_training_data();

set(0,'DefaultFigureWindowStyle','docked') % docked or normal
figure, hold on, xlim([-110 -50])
title('Smartphone: Helvar loc\_1, 8C:6A luminaire (NLOS)')

[t,mac_beacon,y_beacon, ~, ~, ~, ~, ~, ~]= load_data(files{1});
ids = contains(mac_beacon,'8B:1D');

y = y_beacon(ids);

out = datevec(t);
t_new=out(:,5)*60+out(:,6);
t_new_new=t_new(ids);

plot(t_new_new,y,'LineWidth',4)

disp([mean(y);median(y);mode(y);var(y)])

smartphone_helvar_nexus5_loc1_8c6a= y;
save('smartphone_helvar_nexus5_loc1_8c6a.mat','smartphone_helvar_nexus5_loc1_8c6a')

[f,xi] = ksdensity(y,'Bandwidth',0.5);plot(xi,f); 

legend('S4','S4 mini','Nexus 5')


legend( 'hand')
% legend('90 deg','45 deg','0 deg','hand','pocket')
title('Ergorej loc\_2, S4: RSSI pattern')

title('Aalto Kwarkki 3 kerros: RSSI vs distance (not scaled; with median line plot)')


% %%
% map = brewermap(6,'Set1'); 
% figure
% histf(orientation_helvar_90_loc2_8b14,-110:.01:-40,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none')
% hold on
% histf(orientation_helvar_45_loc2_8b14,-110:.01:-40,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none')
% histf(orientation_helvar_0_loc2_8b14,-110:.01:-40,'facecolor',map(3,:),'facealpha',.5,'edgecolor','none')
% histf(orientation_helvar_hand_loc2_8b14,-110:.01:-40,'facecolor',map(4,:),'facealpha',.5,'edgecolor','none')
% histf(orientation_helvar_hand2_loc2_8b14,-110:.01:-40,'facecolor',map(5,:),'facealpha',.5,'edgecolor','none')
% histf(orientation_helvar_pocket_loc2_8b14,-110:.01:-40,'facecolor',map(6,:),'facealpha',.5,'edgecolor','none')
% box off
% axis tight
% legalpha('90 deg','45 deg','0 deg','hand 1','hand 2', 'pocket')
% legend boxoff


disp([mean(orientation_helvar_90_loc2_8b26);
      median(orientation_helvar_90_loc2_8b26);
      var(orientation_helvar_90_loc2_8b26);
      mean(orientation_helvar_45_loc2_8b26);
      median(orientation_helvar_45_loc2_8b26);
      var(orientation_helvar_45_loc2_8b26);
      mean(orientation_helvar_0_loc2_8b26);
       median(orientation_helvar_0_loc2_8b26);
       var(orientation_helvar_0_loc2_8b26);
       mean(orientation_helvar_hand_loc2_8b26);
    median(orientation_helvar_hand_loc2_8b26);
    var(orientation_helvar_hand_loc2_8b26);
    mean(orientation_helvar_hand2_loc2_8b26);
   median(orientation_helvar_hand2_loc2_8b26);
   var(orientation_helvar_hand2_loc2_8b26);
  mean(orientation_helvar_pocket_loc2_8b26);
  median(orientation_helvar_pocket_loc2_8b26);
  var(orientation_helvar_pocket_loc2_8b26)]')

data = datatruncated(:,:);
data_idx = data{:,1} == '8c39';
%id_data_only_ad = data{:,3}> -41;

data_truncated =data(data_idx,:);
%data_only_ad = data(id_data_only_ad,:);

time_mat=datevec(char(data_truncated{:,3}));
time_time=time_mat(:,4)*3600+time_mat(:,5)*60+time_mat(:,6);
time_time = time_time - time_time(1,1);

figure,plot(time_time,data_truncated{:,4}), hold on

% index for 37 channel.
i_37 = data_truncated{:,2}==37;
scatter(time_time(i_37),data_truncated{i_37,4},30,'filled'), hold on

% index for 38 channel.
i_38 = data_truncated{:,2}==38;
scatter(time_time(i_38),data_truncated{i_38,4},30,'filled'), hold on

% index for 39 channel.
i_39 = data_truncated{:,2}==39;
scatter(time_time(i_39),data_truncated{i_39,4},30,'filled'), hold on

legend('rssi from radio analyzer','channel 37','channel 38','channel 39')

title('Set to full power: Outside scenario kontact B2:1B (1 m distance)')