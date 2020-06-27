function [Es,Eb,gamma,gammadB,entropia] = gamma_entropia(dmin,dorigen,probabilidades)

M = numel(probabilidades);
dorigen2 = dorigen.^2; %Distancias al cuadrado del origen a cada uno de los puntos
Es = sum(dorigen2*probabilidades); %Energ�a de s�mbolo 
Eb = Es/log2(M); %Energía de bit
gamma = (dmin^2)./(4*Eb); %Ganancia nominal de codificaci�n
gammadB = 10*log10(gamma); %Ganancia nominal de codificaci�n en dB

entropia = sum((probabilidades.*(log2(probabilidades)))*-1); %Entropia de la constelacion 