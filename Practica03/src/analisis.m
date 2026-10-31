
%% Datos adquiridos de la entrada del proceso
t = out.data.signal1.Time;
entrada = out.data.signal1.Data;

%% Datos adquiridos de la salida del proceso
t = out.data.signal2.Time;
salida = out.data.signal2.Data;

%% Graficación del proceso
plot(t,entrada,'r',t,salida,'b')
grid("on")
title("Respuesta al escalon de un sistema RC con T = 1.0340")
xlabel("Tiempo (s)")
ylabel("Voltaje (v)")