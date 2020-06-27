function [Es,Eb,gamma,gammadB,entropia] = gamma_entropia(dmin,dorigen,probabilidades)

M = numel(probabilidades);
dorigen2 = dorigen.^2; %Distancias al cuadrado del origen a cada uno de los puntos
Es = sum(dorigen2*probabilidades); %Energía de símbolo 
Eb = Es/log2(M); %EnergÃ­a de bit
gamma = (dmin^2)./(4*Eb); %Ganancia nominal de codificación
gammadB = 10*log10(gamma); %Ganancia nominal de codificación en dB

entropia = sum((probabilidades.*(log2(probabilidades)))*-1); %Entropia de la constelacion 