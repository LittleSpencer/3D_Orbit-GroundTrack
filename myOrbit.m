clc;
clear;
close all;
%{
---------------Sample Orbits--------------
          -Alt-     -Vel-      -Inc-       -delT-
GSO:     35786 km  3070  m/s     0         ~ 100
molniya: 185.2 km  10350 m/s   -60ish     >= 10
ISS:     405   km  7670  m/s    51.63ish   < 20

%}
Orbits = 2;             % # of Orbits 
delT   = 15;              % Time between measured points [s]
Alt    = 185.2*1000;		 % Distance to earth surface [m]
mass   = 300000;	     % Mass of satellite [kg] ***Note:generally negligible***
vel    = 10350;           % Initial desired velocity [m/s]
inc    = -60;			 % Desired inclination [º]



%***************CALLING*FUNCTION*FOR*CALCULATING*SATALLITE*"TELEMETRY"***************
[SAT,OrbitalPeriod] = my3dOrbit( Alt, mass, vel,inc,delT);

%{
************************************SAT*Matrix*******************************
--1-- --2-- --3--  --4--   --5--   --6--    --7--    --8--  `--9--   |
--X-- --Y-- --Z-- --V_X-- --V_Y-- --V_Z-- -APOGEE- -PERIGEE- -ALT-   |
  |     |     |      |       |       |       |         |       |     |
  |     |     |      |       |       |       |         |       |OrbPer/DelT
  |     |     |      |       |       |       |         |       |     |
  |     |     |      |       |       |       |         |       |     |
  |     |     |      |       |       |       |         |       |     |
  V     V     V      V       V       V       V         V       V     V
******************************************************************************
%}

%Orbital period in hours
tHours = OrbitalPeriod/3600;

%Searching SAT DATA for apogee
apogee = max(SAT(:,7));

%Searching SAT DATA for perigee
perigee = min(SAT(:,8));

if perigee == 0
    perigee = Alt;
end

%^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^^

%*************PLOT*OF*VELOCITY*Vs*TIME******************

eccentricity = 1-(2/((apogee/perigee)+1));
%Calculating the magnatude of postion and velocities
Xm = sqrt(SAT(:,1).^2+SAT(:,2).^2+SAT(:,3).^2);
Vm = sqrt(SAT(:,4).^2+SAT(:,5).^2+SAT(:,6).^2);

%Creation of plot
figure(3)
plot(SAT(:,1),SAT(:,4),'r',SAT(:,2),SAT(:,5),'b',SAT(:,3),SAT(:,6),'g',Xm,Vm,'y')
title({'Eccentricity';eccentricity})
xlabel(' Component Alt[m]')
ylabel('Component Velocity [m/s]')
legend('X','Y','Z','Total')
grid on
hold off
%^^^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



%***************CALLING*FUNCTION*TO*3D-PLOT*SATALLITE*TRAJECTORY***********
my3dOrbit(SAT,delT,Orbits);
%OUTPUT:
% 3D figure of Satellite/Spacecraft's Orbit around the rotating earth with
% Satellite/Spacecraft's orbit visulazation 

%***************CALLING*FUNCTION*TO*PLOT*GROUNDTRACK*OF*SATALLITE**********
GroundTrack( SAT,delT,inc,Orbits);
%OUTPUT: 
% Ground Track
% i.e. Figure of path directly below satellite/spacecraft



