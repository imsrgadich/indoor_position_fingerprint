clear, close all

L0                       = 40.2; %Reference loss value at 1m
n                        = 2;    %Power decay factor

nb_pts                   = 200;  %Number of steps to grid x,y


load  data_mw;
x_min                    = min(min(walls([1 , 3] , :) , [] , 2));
x_max                    = max(max(walls([1 , 3] , :) , [] , 2));
y_min                    = min(min(walls([2 , 4] , :) , [] , 2));
y_max                    = max(max(walls([2 , 4] , :) , [] , 2));
vectx                    = (x_min:(x_max-x_min)/(nb_pts-1):x_max);
vecty                    = (y_min:(y_max-y_min)/(nb_pts-1):y_max);
[X , Y]                  = meshgrid(vectx , vecty);
RXpoint                  = [X(:) , Y(:)]';


offset                   = 0.5;
axis([x_min-offset x_max+offset y_min-offset y_max+offset])
plot(walls([1 , 3] , :) , walls([2 , 4] , :) , 'linewidth' , 2);
title('select beacon(s) '' position (right click to end selection)')
axis equal

hold on
[x , y]                 = getpts;
TXpoint                 = [x' ; y'];
%  text(sum(walls([1 , 3] , :))/2 , sum(walls([2 , 4] , :))/2 , num2str((1:size(walls,2))','%d') , 'fontsize' , 6)
plot(TXpoint(1 , :) , TXpoint(2 , :) , 'k+' , 'markersize' , 10)
hold off
drawnow

rs_amp                   = multiwall_model(TXpoint ,RXpoint , walls , material , L0 , n);
P                        = log(sum(exp(rs_amp) , 1));

figure(1)
imagesc(vectx , vecty , reshape(P , nb_pts, nb_pts));
hold on
plot(walls([1 , 3] , :) , walls([2 , 4] , :) , 'linewidth' , 2);
plot(TXpoint(1 , :) , TXpoint(2 , :) , 'k+' , 'markersize' , 10)
hold off
axis xy
colorbar
axis equal
title(sprintf('Multiwall model, L0 = %4.2f, n = %4.2f' , L0 , n))
