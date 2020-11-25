%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Code made by:                                                          %
%                   *María Camila Zuluaga Duque                          %
%                   *Juan Pablo Restrepo Pérez                           %
%                   *Camilo Andrés Ospina Osorio                         %
%                   *Sebastián Pineda Ospina                             %
%                                                                        %
%    The code was initially made in spanish but this is an adaptation    %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                       Use under MIT License                            %
%              https://choosealicense.com/licenses/mit/                  %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% * We used PhyPhox app to collect data from the phone but feel free to  %
%   use whatever you want.                                               %
%                                                                        %
% * In theory you can use this code for any accelerometer data, so u can %
%   use it to arduino (or any processor-accelerometer) data collection   %
%                                                                        %
% * We don´t make us responsables about damages, injuries or death while %
%   collecting data, please take care about you and your cellphone.      %
%   Make experiment under your own risk.                                 %
%                                                                        %
% * Mom if you are reading this, I love you.                             %
%                                                                        %
% * Really, who read this?                                               %
%                                                                        %
% * De Colombia para el mundo papá                                       %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% New run, new all
clc
clear all
close all

%% Data reading
% Check the number of items that you collected and modify this variables
time = xlsread('Aceleración con frenado trasero','Raw Data','A2:A5023');
accelerationTotal = xlsread('Aceleración con frenado trasero','Raw Data','E2:E5023');
accelerationAxisY = xlsread('Aceleración con frenado trasero','Raw Data','F2:F5023');

dataAmount = length(time);

%% Adjustable data

% Check your phone accelerometer hertz
hertz = 200;
deltaTime = 1/hertz;

% Change the mass, put in kg
userMass = 70;
motorcycleMass = 104;
totalMass = userMass + motorcycleMass;

radiusFront = 0.6954/2;                % Rin radius + tyre in meters
radiusRear = 0.6772/2;                 % Rin radius + tyre in meters

reductionRatio = ((32/14) * (73/24))^(-1);      % Search in the motorcycle datasheet
                                                % This experiments was made
                                                % in 1st. gear

% We calculated it in SolidWorks, you can do a manual aproximation
% Put in kg/m^2
inertiaMomentFrontWheel = 2.06898940037;    % 1 kg/m^2 are (1*10^-9) g/mm^2
inertiaMomentRearWheel = 2.32335309794;


%% This is the main code

speed(1) = 0;                   % In m/s
speedInkm(1) = 0;               % In km/h
distance(1) = 0;                % In m
thetaRear(1) = 0;

% We compute the moment by 3 ways, so we need 3 moments variables
% All of them are in [N*m]
momentRearWheel1(1) = 0;
momentRearWheel2(1) = 0;
momentRearWheel3(1) = 0;
momentEngine1(1) = 0;
momentEngine2(1) = 0;
momentEngine3(1) = 0;

RPM_Engine(1) = 0;
mu = 0.85;                      % Friction coeff. between tyre-asphalt
g = 9.81;                       % Gravity in [m/s^2]
alfaRear(1) = 0;
omegaFront(1) = 0;
omegaRear(1) = 0;

for i = 2:dataAmount
    speed(i) = accelerationAxisY(i) * deltaTime + speed(i-1);
    speedInkm(i) = speed(i) * 3.6;
    distance(i) = ((1/2)*accelerationAxisY(i)*deltaTime^2) + (speed(i-1)*deltaTime) + distance(i-1);
    thetaRear(i) = ((distance(i)-distance(i-1))/radiusRear) + thetaRear(i-1);
    omegaRear(i) = speed(i)/radiusRear;
    omegaFront(i) = speed(i)/radiusFront;
    alfaRear(i) = (omegaRear(i) - omegaRear(i-1))/deltaTime;
    
    RPM_Engine(i) = (1/reductionRatio) * omegaRear(i) * 30 / pi;  %the last 3 factors are the RPM in the rear wheel
    
    
    %The Moment in the engine is determined by 3 ways:
    
    %This are the worst results, probably something is wrong
    %Energy conservation
    momentRearWheel1(i) = (1/(thetaRear(i)-thetaRear(i-1))) * ...
        (0.5*totalMass*((speed(i)^2)-(speed(i-1)^2))...
        + 0.5*inertiaMomentRearWheel*((omegaRear(i)^2)-(omegaRear(i-1)^2))...
        + 0.5*inertiaMomentFrontWheel*((omegaFront(i)^2)-(omegaFront(i-1)^2)));
    momentEngine1(i) = momentRearWheel1(i)*reductionRatio;
    
    %This are the better results, we recommend this method
    %Dynamic analysis
    momentRearWheel2(i) = (totalMass*accelerationAxisY(i)*radiusRear/2) - ...
                               inertiaMomentRearWheel*alfaRear(i);
    momentEngine2(i) = momentRearWheel2(i)*reductionRatio;
    
    %Energy conservation with Friction Force
    momentRearWheel3(i) = (1/(thetaRear(i) - thetaRear(i-1))) * (1/4) * totalMass *...
                             ((speed(i)^2)-(speed(i-1)^2)) - ...
                             inertiaMomentRearWheel * alfaRear(i);
    
	momentEngine3(i) = momentRearWheel3(i)*reductionRatio;
end

%Suavizado a tres puntos
accelerationAxisYSmooth = movmean(accelerationAxisY,39);
momentEngineSmooth1 = movmean(momentEngine1,39);
momentEngineSmooth2 = movmean(momentEngine2,39);
momentEngineSmooth3 = movmean(momentEngine3,39);

zeros = zeros(dataAmount);

% Due to the data is for the entire test, the unused values are removed
distanceCutted(1:1479) = distance(200:1678);
speedkmCutted(1:1479) = speedInkm(200:1678);
RPM_EngineCutted(1:1479) = RPM_Engine(200:1678);
accelerationAxisYSmoothCutted(1:1479) = accelerationAxisYSmooth(200:1678);
accelerationAxisYCutted(1:1479) = accelerationAxisY(200:1678);
momentEngineSmoothCutted1(1:1479) = momentEngineSmooth1(200:1678);
momentEngineSmoothCutted2(1:1479) = momentEngineSmooth2(200:1678);
momentEngineSmoothCutted3(1:1479) = momentEngineSmooth3(200:1678);
zerosCutted(1:1479) = zeros(200:1678);
timeCutted(1:1479) = time(200:1678);

%% graphing
close all

figure
plot(timeCutted,distanceCutted,'r','Linewidth',0.5)
title('Total Distance'); 
xlabel('Time [s]');    
ylabel('Distance [m]');     
%legend('Distance');
grid on ;

figure
plot(timeCutted,speedkmCutted,'g','Linewidth',0.5)
title('Speed'); 
xlabel('Time [s]');    
ylabel('Speed [km/h]');     
%legend('Speed');
grid on ;

% The values of this chart are bad, the motorcycle was at 7000 RPM in the
% max point. If you find the mistake, please make a pull request
figure
plot(timeCutted,RPM_EngineCutted,'g','Linewidth',0.5)
title('RPMs'); 
xlabel('Time [s]');    
ylabel('Revolutions per minute [RPM]');     
%legend('RPM');
grid on ;

figure
hold on
plot(timeCutted,accelerationAxisYCutted,'k','Linewidth',0.5)
plot(timeCutted,accelerationAxisYSmoothCutted,'g','Linewidth',0.1)
plot(timeCutted,zerosCutted,'r','Linewidth',2)
hold off
title('Acceleration in y Axis'); 
xlabel('Time [s]');    
ylabel('Acceleration [m/s^2]');     
%legend('Acceleration');
grid on ;

% Remember that the moment calculated by the 1st. method is probably bad.
% Believe in the 2nd. and 3rd. method
figure
hold on
plot(timeCutted,momentEngineSmoothCutted1,'r','Linewidth',0.1)
plot(timeCutted,momentEngineSmoothCutted2,'g','Linewidth',5)
plot(timeCutted,momentEngineSmoothCutted3,'b','Linewidth',0.1)
plot(timeCutted,zerosCutted,'r','Linewidth',2)
hold off
title('Engine moment'); 
xlabel('Time [s]');    
ylabel('Moment [N*m]');     
legend({'Engine moment by 1st. method','Engine moment by 2nd. method','Engine moment by 3rd. method'},'Location','southwest')
grid on ;