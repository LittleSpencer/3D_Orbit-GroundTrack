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
 delT: Time between measured points [s]
 Orbits: # number of orbits

OUTPUT:
3D figure of Satellite/Spacecraft's Orbit around the rotating earth with
Satellite/Spacecraft's orbit visulazation 
%}
function []= my3dOrbit2(SAT,delT,Orbits)



earth_eRadius    = 6350000;          % equatorial radius [m]
earth_pRadius    = 6350000;          % polar radius [m]
earth_Rotation   = 7.2921158553e-5;  % rotation of earth [rad/s]
npanels          = 180;              % Number of globe panels around the equator deg/panel = 360/npanels
alpha            = 1;                % Transparency of mesh

%***************************Figure*Settings*Including*Earth**************************
f=figure('color','k');
movegui(f,[200 200])
set(gca, 'NextPlot','add', 'Visible','off');
ax = axes('XLim',[-inf inf],'YLim',[-inf inf],'ZLim',[-inf inf]);
view(3)
grid on
axis equal
axis auto
[x, y, z] = ellipsoid(0, 0, 0, earth_eRadius, earth_eRadius, earth_pRadius, npanels);
globe = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);
t = hgtransform('Parent',ax);
set(globe,'Parent',t)
cdata = imread('1024px-Land_ocean_ice_2048.jpg');
set(globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');
hold on
axis vis3d
axis off
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

% To find the the number of points measured in the SAT Matrix
[h g] = size(SAT);

%Plotting all the points for a solid orbit around the earth 
plot3(SAT(:,1),SAT(:,2),SAT(:,3),'y','linewidth',2)

i  = 1;   % 
b  = 0;   % Orbit counter
r  = 1;   % Counter for tota Loop iterations

earth_rotation = (earth_Rotation)*delT; % Number of degrees per specific time step

%*****FOR*GIF*CREATION*********
%   filename = 'GSO_30.gif';
%   first_frame = true;

%*******************PLOTTING*EACH*POSTION*OF*THE*SATELLITE*****************

  
while b < Orbits
    
 %Plots Satallite postion for heach timestep
    s = plot3(SAT(i,1),SAT(i,2),SAT(i,3),'r*','linewidth',2);
    
  %Rotates earth everystep
    Rz = makehgtform('zrotate',earth_rotation*r);
    set(t,'Matrix',Rz)
    
  %Calculates magnatude of velocity and plot inplace of title 
    %Vm = sqrt(SAT(i,4).^2+SAT(i,5).^2+SAT(i,6).^2);
    %title({['V= ',num2str(Vm),' m/s']},'color','w',)
    
    pause(.000001)
    
    if i == h-10 % NOTE: subtraction of 10 to prevent redundant points **SEE:"my3dOrbit.m"**
        b = b+1;
        i = 1;
    end
    
 %********For*GIF*Creation********
%       frame = getframe(1);
%         im = frame2im(frame);
%         [imind,cm] = rgb2ind(im,256);
%         if first_frame
%           imwrite(imind,cm,filename,'gif','DelayTime',.01,'Loopcount',inf);
%           first_frame = false;
%         else
%           imwrite(imind,cm,filename,'gif','DelayTime',.01,'WriteMode','append');
%        end
 %^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^
 
    delete(s);
    r =r +1;
    i = i+1;
end

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

end
