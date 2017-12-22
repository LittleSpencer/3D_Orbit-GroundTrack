%{
INPUT:
Alt0: Distance to earth surface [m]
mass: Mass of satellite [kg] ***Note:generally negligible***
Vel:  Initial desired velocity [m/s]
inc:  Desired inclination [º]
delT: Time between measured points [s]

OutPut:
************************************SAT*Matrix*******************************
--1-- --2-- --3--  --4--   --5--   --6--   --7--     --8--   --9--   |
--X-- --Y-- --Z-- --V_X-- --V_Y-- --V_Z-- -APOGEE- -PERIGEE- -ALT-   |
  |     |     |      |       |       |       |         |       |     |
  |     |     |      |       |       |       |         |       |OrbPer/DelT
  |     |     |      |       |       |       |         |       |     |
  |     |     |      |       |       |       |         |       |     |
  |     |     |      |       |       |       |         |       |     |
  V     V     V      V       V       V       V         V       V     V
******************************************************************************
OrbitalPeriod: Time between measured points [s]
%}
function [ SAT, OrbitalPeriod] = my3dOrbit( Alt0, mass, Vel, inc, delT )

%Constants

G               = 6.674*(10^-11);	% universal gravitaional constant[(m^3)/(kg*(s^2))]
mass_Earth   	  = 5.974*(10^24);  	% [kg]
radius_Earth  	= 6350000;			% [m]

%Calclate Standard gravitational parameter
mu = G*mass_Earth;

% a is the orbit's semi-major axis [m]
a = -1/((Vel^2/mu)-(2/(radius_Earth+Alt0)));

%Calculating orbital period [s]
OrbitalPeriod = 2*pi*sqrt(a^3/mu);

% number of seconds simulated
points = OrbitalPeriod/delT+10;  % Note: Addition 10 helps plot to fill in
% i.e. appear continuous for plotting



%************************Initial Satellite parameters**********************

%inclination to radians
inc		= inc*pi/180;


apogee0		= 0;                                    % max |positions| [m]
perigee0	= Alt0+radius_Earth;                    % min |positions| [m]
SAT(1,1)	= (radius_Earth+Alt0)*cos(inc);         % position x [m]
SAT(1,2)	= 0;                                    % position y [m]
SAT(1,3)	= (radius_Earth+Alt0)*sin(inc);         % position z [m]
SAT(1,4) 	= 0;                                    % velocity x [m/s]
SAT(1,5)	= Vel;                                  % velocity y [m/s]
SAT(1,6)	= 0;                                    % velocity z [m/s]

Alt = sqrt((SAT(1,2)^2)+(SAT(1,1)^2)+(SAT(1,3)^2)); % Alt |positions| [m]
SAT(1,9)    = Alt-radius_Earth;                     % Alt to Surface  [m]


%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



%*********************************CALCULATING*THE*POSTION*AND*VELOCITIES*FOR*EACH*STEP********************************

for i=2:points
    
    % Calculating next postion
    SAT(i,1) = SAT(i-1,1) + SAT(i-1,4)*delT;
    SAT(i,2) = SAT(i-1,2) + SAT(i-1,5)*delT;
    SAT(i,3) = SAT(i-1,3) + SAT(i-1,6)*delT;
    
    %***************CALCULATING*THE*ALT*******************
    Alt = sqrt((SAT(i,2)^2)+(SAT(i,1)^2)+(SAT(i,3)^2));
    SAT(i,9) = Alt-radius_Earth;
    
    % Testing if the orbit's initial parameters were is sufficent enough
    if (Alt<radius_Earth)
        text(SAT(i,1),SAT(i,2),SAT(i,2),'o*');
        SAT(i,8) = Alt;
        OrbitalPeriod = i;
        break;
    end
    %^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
    
    
    %*******************TESTING*FOR*APOGEE*&*PERIGEE***********************
    if (Alt>apogee0)
        SAT(:,7) = 0;
        apogee0 = Alt;
        SAT(i,7) = Alt- radius_Earth;
    end
    
    if (Alt<perigee0)
        SAT(:,8) = 0;
        perigee0 = Alt;
        SAT(i,8) = Alt-radius_Earth;
    end
    %^^^^^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
    % calculating the acceleration from gravity for x y z
    
    
    gravity  = -((G*(mass_Earth+mass))/(Alt^3));	% [1/S^2]
    
    acc_x = gravity*SAT(i,1);		      	% [m/s^2]
    acc_y = gravity*SAT(i,2);           % [m/s^2]
    acc_z = gravity*SAT(i,3);           % [m/s^2]
    
    % Calculating the next velocity
    SAT(i,4)  = SAT(i-1,4) + acc_x*delT;
    SAT(i,5)  = SAT(i-1,5) + acc_y*delT;
    SAT(i,6)  = SAT(i-1,6) + acc_z*delT;
    
    
end
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^END^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

end


