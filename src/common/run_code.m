clear all, clc;
clf;

%% load the parameters from GP regression training.

load('../../mat_files/code_param/options_old_ref_1.mat')
load('../../mat_files/test_files/test_data.mat')

%% Switch to select measurement model
% 1 for GP
% 2 for k-NN

options.meas_model_switch =1;

%% Switch to select the method
% 1 Grid Filter
% 2 Unscented Kalman Filter
% 3 Particle Filter.
method = 3;


%options.omega = 0.0001; %frequency
%options.T = 1;

% Dynamic model Augmented Turn Coordinated Model
% options.f = @(x,xdot,y,ydot,T,omega) ...
%     [x+(xdot.*sin(omega*T)./omega)-(ydot.*(1-cos(omega*T))./omega);
%      y+(xdot.*(1-cos(omega*T))./omega)+(ydot.*sin(omega*T)./omega);
%      sqrt(xdot.^2+ydot.^2);
%      omega];
% Dynamic model Augmented Turn Coordinated Model
% options.f = @(x,xdot,y,ydot,T,omega) ...
%     [x+(xdot.*sin(omega*T)./omega)-(ydot.*(1-cos(omega*T))./omega);
%      y+(xdot.*(1-cos(omega*T))./omega)+(ydot.*sin(omega*T)./omega);
%      sqrt(xdot.^2+ydot.^2);
%      omega];


% Quasi Constant model
options.A =@(dt) [1 0 dt 0;
        0 1 0 dt;
        0 0 1 0;
        0 0 0 1];
    
options.dt =1;

% options.g = @(T) [0.5*T*T 0       0;
%                   0       0.5*T*T 0;
%                   T       T       0;
%                   0       0       1];

% Process noise: only for location and angle measurement.              
options.Q = 2^2*eye(4);


%% Get the test data

%test_data = get_test_data(options);

%% Filter Initializations
options.N_states = 4;
P_F(:,:,1) = 3*eye(options.N_states);
m_F(1,:) = [1.379 0.805 0 0];
%m_F(1,:) = [0 0 0 0];
i=2;
done = false;

%% Get the test data
%testData = test_data{3};
[test_data,time,id,y] = get_test_data(options);

% testData = test_data{3};
% tt = [1:size(testData,1)]';
% idd = repmat([1:options.num_beacons]+2,size(testData,1),1);

tt = time{3};
testData = y{3};
idd = id{3};

%image = imread('../../images/floorplan.png');
%image=rgb2gray(image); 
%imshow(image), hold on
%figure(1),clf, hold on

% options.g = @(T) [0.5*T*T 0       0;
%                   0       0.5*T*T 0;
%                   T       T       0;
%                   0       0       1];

% Process noise: only for location and angle measurement.              
options.Q = 2^2*eye(options.N_states);

switch method
    case 1 
        %% Grid filter initialization
        x = 1:3;  %% x-5:0.01:x+5
        y = 1:5;  %% y-5:0.01:y+5
        [X,Y] = meshgrid(x,y);
        %% for grid filter
        while ~done
            
            done = true;
            continue;
            
            if i >100
                done = true;
            end
            
        end
        
    case 2
        %% for unscented kalman filter
        n = options.N_states; %number of states
        alpha = 2;
        beta = 0.5;
        kappa = 3;
        i = 0;
        temp_m=[];
        
        options.lambda = alpha^2 * (n + kappa) - n;        
        options.WM = zeros(2*n+1,1);
        options.WC = zeros(2*n+1,1);
        options.R =  10*eye(size(testData,2));
        
        for j=1:2*n+1
            if j==1
                wm = options.lambda / (n + options.lambda);
                wc = options.lambda / (n + options.lambda) + (1 - alpha^2 + beta);
            else
                wm = 1 / (2 * (n + options.lambda));
                wc = wm;
            end
            options.WM(j) = wm;
            options.WC(j) = wc;
        end
        
        %% start the filtering
        figure, hold on

         for j = 2: size(testData,1)
            % send in previosu mean, covariance and other options.
            options.dt = tt(j,1) - tt(j-1,1);
            [m,P] = gp_ukf(m_F(j-1,:), P_F(:,:,j-1),testData(j,:),idd(j,:),options);
            temp_m = [temp_m;m(1:2)']; 
            m_F(j,:) = m;
            P_F(:,:,j) = P;
            
            if tt(j,1) - i > 1
                temp_avg_mean = mean(temp_m,1);
                plot(temp_avg_mean(1),temp_avg_mean(2),'.','MarkerSize',20), hold on
                temp_m = [];
                i = i+1;
            end
         end
        

    case 3
        %% particle filter
        % Particle Filter for N_seeds iterations
        % Check the filter for various # of paricles.
        
        im= imread('/home/imsrgadich/Documents/gitrepos/helvar/ble-ip-helvar/images/floorplan.png');
        figure, image(im), hold on
        temp_m = [1958.5-(m_F(1,2)*61.2031),913.4651-(m_F(1,1)*60.8977)];
        pos = [temp_m(1)-2*3*61.2031,...
               temp_m(2)-2*3*60.8977,...
               4*3*61.2031,...
               4*3*60.8977];
        rectangle('Position',pos,'Curvature',[1 1],'FaceColor',[0,1,1],'EdgeColor','w',...
                        'LineWidth',3), hold on
        plot(temp_m(1),temp_m(2),'.','Color',[0,0.5,1],'MarkerSize',40), hold on
        options.numSamples = 800;
        
        
        SX = gauss_rand(m_F(1,:)',P_F(:,:,1),options.numSamples)';
        w = (1/options.numSamples)*ones(options.numSamples,1);
        %figure, xlim([0,15]), ylim([0,35]), hold on
        i = 0;
        temp_m=[];
        pause();
       
            for j = 2: size(testData,1)
                
                options.dt = tt(j,1) - tt(j-1,1);
                r = randn(options.numSamples,options.N_states);
                % Call the PF function
                [m,P,pf] =gp_pf(SX,testData(j,:),idd(j,:),w,r,j,options);
                temp_m = [temp_m;m(1:2)]; 
                m_F(j,:) = m;
                P_F(:,:,j) = P;
                SX = pf.SX;
                %neff(i) = pf.neff;
                kHat(j,1) = pf.kHat;
                w = pf.w;
                
                if tt(j,1) - i > 4
                    % transforming the means to plot coordinates.
                    temp_m = [1958.5-(temp_m(:,2)*61.2031),913.4651-(temp_m(:,1)*60.8977)];
                    temp_avg_mean = mean(temp_m,1);
                    mean_std = std(temp_m,0,1);
                    % Clear of the previous point and then plot the next
                    children = get(gca, 'children');
                    delete(children(1)); delete(children(2))
                    pos_circle = [temp_avg_mean(1)-2*mean_std(1),...
                                 temp_avg_mean(2)-2*mean_std(2),...
                                 4*mean_std(1),4*mean_std(2)];
                    rectangle('Position',pos_circle,'Curvature',[1 1],'FaceColor',[0,1,1],'EdgeColor','w',...
                                 'LineWidth',3), hold on
                    plot(temp_avg_mean(1),temp_avg_mean(2),'.','Color',[0,0.5,1],'MarkerSize',40), hold on
                    temp_m = [];
                    i = i+4;
                end
                
                %plot(m_F(i,1),m_F(i,2),'.','MarkerSize',20),hold on
                %plot(m_F(i,1)*26.6+5.5,129-m_F(i,2)*6.75,'.','MarkerSize',20)
                % Pause and draw
                drawnow;
                %pause()
                
            end
            
            % time step
            if i> 50
                done = true;
            end
            
      
            
        
    otherwise
        warning('Unexpected number. Out of filtering methods')
        
end

%figure,scatter(m_F(:,1),m_F(:,2))

      