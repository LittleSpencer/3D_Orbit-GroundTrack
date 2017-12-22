%{
INPUT:
************************************SAT*Matrix*******************************
--1-- --2-- --3--  --4--   --5--   --6--    --7--    --8--  `--9--   |
--X-- --Y-- --Z-- --V_X-- --V_Y-- --V_Z-- -APOGEE- -PERIGEE- -ALT-   |
 [m]   [m]   [m]   [m/s]   [m/s]   [m/s]    [m]       [m]     [m]    |
  |     |     |      |       |       |       |         |       |     |
  |     |     |      |       |       |       |         |       |OrbPer/DelT
  |     |     |      |       |       |       |         |       |     |
  |     |     |      |       |       |       |         |       |     |
  |     |     |      |       |       |       |         |       |     |
  V     V     V      V       V       V       V         V       V     V
******************************************************************************
 OrbitalPeriod: Time to orbit the central body "Earth" [s]
 delT: Time between measured points [s]
 inc: Desired Inclination
 Orbits: # number of orbits

OUTPUT: Ground Track
Figure of path directly below satellite/spacecraft
%}
function [ ] = myGroundTrack( SAT,delT,inc,Orbits)

[S x] = size(SAT);
S = S-10;
Lon = zeros(S*Orbits,1);
X = (SAT(1:S,1));Y= (SAT(1:S,2));Z = (SAT(1:S,3));
c = 1;

%******************Figure*Settings*******************
Earth = imread('1024px-Land_ocean_ice_2048.jpg');
f = figure('color','k');
ax = gca;
movegui(f,[800 200])
imagesc([-180 180], [-90 90],Earth)
hold on
grid on
ax.GridColor= [.5 .5 .5];
ax.GridAlpha= .75;
axis on
%^^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^



%****For GIF creation****
%  filename = 'Molniya_GT.gif';
%  first_frame = true;
% 



Lat = -atand(Z(:,1)./(sqrt(X(:,1).^2+Y(:,1).^2))); %Latatude for First Orbit

%***********Longitude for the first orbit*************%
for i = 1:S
 
    if inc >0                             
        a = -90;
    else
        a = 90;
    end
    Lon(i,1) = -atand(X(i,1)./Y(i,1))+a;
    Lon(i,1) = Lon(i,1)-((7.2921159*10^-5)*(180/(pi))*delT*i);
    if i> 1
        if Lat(i,1) >= Lat(i-1,1)
            Lon(i:end,1) = Lon(i:end,1)+180;
            
            if Lat(i,1) <= 0
                 Lon(i-1,1)= Lon(i,1);
            end
            
        end
       
    end
   
end
%**********************END******************************%
for i = 1:S
    if i> 1 && i < S-1
        m = abs(Lon(i,1)-Lon(i-1,1));    
         if m > 10 
            Lon(i,1)=Lon(i+1,1);
         end
    end
end
%*************|Computing lat and long for N orbits|*****************
if Orbits >1
    O = Orbits-1;
    for i = 1:O
        Lon(i*S+1:(i+1)*S,1) = Lon(1:S,1)+Lon(i*S,1);
        Lat(i*S+1:(i+1)*S,1) = Lat(1:S,1);
    end
end

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%



%********************Defining the bounds of the map*********************
for i = 1:Orbits*S
    if Lon(i,1) > 180
        Lon(i,1) = Lon(i,1)-360;
    end
    if Lon(i,1)< -180
        Lon(i,1) = Lon(i,1)+360;
    end
    
end
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


%***************************Plotting each point*************************
for i = 1:Orbits*S
    title(['T= ',num2str((delT*c)/3600,3),' Hours'],'color','w')
    plot(Lon(i,1),Lat(i,1),'y.','linewidth',1)
    
    drawnow
    pause(.000000000000001)
    
    c = c+1;
    
  %********For*GIF*Creation********
  
%       frame = getframe(1);
%         im = frame2im(frame);
%         [imind,cm] = rgb2ind(im,256);
%         if first_frame
%           imwrite(imind,cm,filename,'gif','DelayTime',.0001,'Loopcount',inf);
%           first_frame = false;
%         else
%           imwrite(imind,cm,filename,'gif','DelayTime',.0001,'WriteMode','append');
%        end
%     
  %^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^
  
  
end
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
end

