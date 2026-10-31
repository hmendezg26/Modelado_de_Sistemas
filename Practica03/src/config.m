%% Declarar PATH con funciones de Simulink
addpath('C:\Users\Documents\MATLAB\ArduinoIO\simulink')
%% Declarar Arduino
delete(instrfind({'Port'},{'COM4'}))
a = myarduino('COM4');

%% Configuracion de puerto
pinMode(a,3,'output');     % Activador del Circuito RC
