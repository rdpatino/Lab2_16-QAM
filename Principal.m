%% Laboratorio II de Sistemas de Telecomunicaciones

clear, close all, clc
%% Generacion de bits 

num_bits = 120000; % CAMBIAR (# BITS DE FUENTE) *multiplo de 4
prob = [0.45 0.55]; % CAMBIAR (PROBABILIDAD) [probabilidad de 0, probabilidad de 1]

% FUNCION fuente_bits
% b - bits generados 
b = fuente_bits(num_bits, prob); % para comentar si se carga variable

% Carga variables guardadas: b y Z_randn 
% *Para no cambiar escenrio de pruebas
% Necesario comentar variables b y Z_randn 
% load pruebas/prueba_1_01.mat 

%% Constelación 16-QAM y 16-QAM' (Estrella5)

% CAMBIAR: Escoger la constelacion propuesta o tradicional
tipo_constelacion = 'propuesta';

% FUNCION constelacion_f
% constelacion - constelacion a trabajar en valores complejos
constelacion = constelacion_f(tipo_constelacion);
M = 16;

%% Mapeo 

% FUNCION mapeo (*recomendable cambir nombre)
% simbolosTx - Simbolos mapeados
% mapeo - Mapeo de constelacion
% mapeo_string - Mapeo de constelacion en string (*util para graficas)
% index_sTx - indices de simbolos de constelacion para transmitir
[simbolosTx, mapeo, mapeo_string, index_sTx, mapeo_tx] = mapeo(tipo_constelacion, constelacion, b);

%% Ganancia de codificacion nominal y entropía

% FUNCION distancias
% dmin - Distancia mínima en la constelación
% dorigen - Distancias del origen a cada uno de los puntos
[dmin,dorigen] = distancias(constelacion);

% FUNCION probabilidadSimbolo
% probabilidades - probabilidades de cada simbolo de la constelacion
probabilidades =  probabilidadSimbolo(mapeo,prob(1),prob(2));

% FUNCION gamma_entropia
% Es - Energia de símbolo 
% Eb - Energia de bit
% gamma - Ganancia nominal de codificacion
% gammadB - Ganancia nominal de codificacion en dB
% entropia - Entropia de la constelacion
[Es,Eb,gamma,gammadB,entropia] = gamma_entropia(dmin,dorigen,probabilidades);

fprintf('Ganancia de codificacion (dB): %.4f\n' , gammadB);
fprintf('Entropia: %.4f\n\n' , entropia);

%% Upsample
rolloff = 0.25; span = 24; L = 8;
sTx = upsample(simbolosTx',L); %Señal de simbolos en Tx

%% Filtro p(t)
sPreF=[sTx zeros(1,L*span+1)]; %Se agregan ceros para compensar tamaño que agrega el filtro
filtroConformador = rcosdesign(rolloff, span, L,'sqrt'); %Filtro de coseno alzado cuya longitud es de L*span+1
sFiltrada = filter(filtroConformador,1,sPreF); %Señal filtrada de simbolos en Tx

%% Señales complejas
fo = 4000;
w = 2*pi*fo;
t = linspace(0,2*pi,numel(sFiltrada));
sTx_R = real(sFiltrada).*(sqrt(2)*cos(w*t));%Parte real del simbolo transmitido 
sTx_I = imag(sFiltrada).*(sqrt(2)*sin(w*t));%Parte imaginaria del simbolo transmitido 
sTx_T = sTx_R - sTx_I; %Señal transmitida total

% FOR: para evaluar diferentes Eb/No
for Eb_No=1:1:9

%% Canal
% Se añade ruido AWGN

%Eb_No = 3; %no es util si se usa el ciclo for
sigma = sqrt(Es/((2*log2(M))*(Eb_No)));
Z_randn = randn(1,length(sTx_T)); % para comentar si se carga variable
Z = sigma*Z_randn;

sRx_T = sTx_T + Z; %Señal total en Rx

% Multitrayecto

% %retardo = randi(10); % numero de bits de retado de señal con multitrayecto
% retardo = 5;
% gan_multi = 0.05; % amplitud que gana o pierde la señal con multitrayecto
% retardoM = zeros(1,retardo);
% Senalmodificada = [sRx_T,retardoM];
% Senalmultitrayecto = [retardoM,(sRx_T)*gan_multi];
% Senalmultitrayecto = Senalmodificada + Senalmultitrayecto;
% sRx_T = Senalmultitrayecto(1:numel(sFiltrada));

%% Señales complejas

sRx_R = sRx_T.*(sqrt(2)*cos(w*t)); %Parte real del simbolo en Rx
sRx_I = sRx_T.*(-1*(sqrt(2)*sin(w*t))); %Parte imaginaria del simbolo en Rx

%% Filtro p(-t)
sRx_R = filter(filtroConformador,1,sRx_R); %Filtraje parte real de los simbolos en Rx
sRx_I = filter(filtroConformador,1,sRx_I); %Filtraje parte imaginaria de los simbolos en Rx

sRx_R = sRx_R(L*span+1:end-1); %Se quitan los ceros agregados en Tx
sRx_I = sRx_I(L*span+1:end-1); %Se quitan los ceros agregados en Tx
%% Downsample
sRx_R = downsample(sRx_R, L); %Toma muestras en el instante optimo de la señal recibida (Parte real)
sRx_I = downsample(sRx_I, L); %%Toma muestras en el instante optimo de la señal recibida (Parte imaginaria)

%% Decision - Distancia minima 16-QAM y 16-QAM' (Estrella5)

sRx_Tot = sRx_R+(sRx_I*1i);

% FUNCION decision_MD
% simbolos_rx - Simbolos recibidos decididos por distancia minima
% index_simbolo - indices de simbolos decididos 
% dmin_decision - matriz de distancias minimas para decision
% demapeo_rx - simbolos recibidos en string
% d_decision - distancias para decision entre cada simbolo trasmitido y cada simbolos de la constelacion
% b2 - bits recibidos decididos con MD
[simbolos_rx, index_simbolo, dmin_decision, demapeo_rx, d_decision, b2] = decision_MD(sRx_Tot, constelacion, mapeo);

% FUNCION decision_MAP
% simbolos_rx_MAP - Simbolos recibidos decididos por MAP
% index_simbolo_MAP - indices de simbolos decididos
% map_decision - matriz de maximos probables para decision
% demapeo_rx_MAP - simbolos recibidos en string
% b2_MAP - bits recibidos decididos con MAP
[simbolos_rx_MAP,index_simbolo_MAP,map_decision,demapeo_rx_MAP,b2_MAP] = decision_MAP(constelacion,sRx_Tot,probabilidades,mapeo,Eb,Eb_No,d_decision);
%% SER y BER

% Simbolos
[Simbolos_erroneos,SER] = symerr(index_sTx,index_simbolo');
% fprintf('MD-Simbolos erroneos: %.0f\n', Simbolos_erroneos);
% fprintf('MD-Symbol Error Rate (SER): %.4f\n', SER);

[Simbolos_erroneos_MAP,SER_MAP] = symerr(index_sTx,index_simbolo_MAP');
% fprintf('MAP-Simbolos erroneos: %.0f\n', Simbolos_erroneos_MAP);
% fprintf('MAP-Symbol Error Rate (SER): %.4f\n\n', SER);

% Bits
[Bits_erroneos,BER] = biterr(b,b2);
% fprintf('MD-Bits erroneos: %.0f\n', Bits_erroneos);
% fprintf('MD-Bit Error Rate (BER): %.4f\n', BER);

[Bits_erroneos_MAP,BER_MAP] = biterr(b,b2_MAP);
% fprintf('MAP-Bits erroneos: %.0f\n', Bits_erroneos_MAP);
% fprintf('MAP-Bit Error Rate (BER): %.4f\n', BER_MAP);

% Variables para guardar SER y BER para cada EB/No de ciclo for
All_SER(1,Eb_No) = SER;
All_SER_MAP(1,Eb_No) = SER_MAP;
All_BER(1,Eb_No) = BER;
All_BER_MAP(1,Eb_No) = BER_MAP;
All_Eb_No(1,Eb_No) = 10*log10(Eb_No); %Eb/No en dB *para graficar

end

%% Graficos

% BER vs Eb/No

EbNoVec = (0:10)';
berTeorica = berawgn(EbNoVec,'qam',M);
figure()
semilogy(EbNoVec,berTeorica);hold on
semilogy(All_Eb_No,All_BER,'*r-'); grid on
semilogy(All_Eb_No,All_BER_MAP,'ob-'); grid minor
hold off
legend('BER Teórica 16-QAM tradicional', 'BER estimada (MD)','BER estimada (MAP)','location','southwest');
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate');
xlim([0 10])
ylim([10^(-3) 1])
title('BER vs Eb/No')

% SER vs Eb/No

figure()
semilogy(All_Eb_No,All_SER,'*r-'); hold on
semilogy(All_Eb_No,All_SER_MAP,'ob-'); grid on, grid minor
hold off
legend('SER estimada (MD)','SER estimada (MAP)','location','southwest');
xlabel('Eb/No (dB)');
ylabel('Symbol Error Rate');
xlim([0 10])
ylim([10^(-3) 1])
title('SER vs Eb/No')

% Constelacion 

if  isequal(tipo_constelacion,'propuesta') 
    % Propuesta: 16-QAM' (Estrella5)
    r=sqrt(2); 
    r2=r*(sind(108)/sind(36)); %r2=r*(1.6180);
    r3 = r/2*(1/sind(54));
    rombo = [(r3*(cosd(36)+sind(36)*j)), (r3*(cosd(36+72)+sind(36+72)*j)), (r3*(cosd(36+(72*2))+sind(36+(72*2))*j)), (r3*(cosd(36+(72*3))+sind(36+(72*3))*j)), (r3*(cosd(36+(72*4))+sind(36+(72*4))*j)), (r3*(cosd(36+(72*5))+sind(36+(72*5))*j))];
    rombo1=((-1)*rombo)+(r2*(cosd(36)+sind(36)*j));
    rombo2=((-1)*rombo)+(r2*(cosd(36+72)+sind(36+72)*j));
    rombo3=((-1)*rombo)+(r2*(cosd(36+(72*2))+sind(36+(72*2))*j));
    rombo4=((-1)*rombo)+(r2*(cosd(36+(72*3))+sind(36+(72*3))*j));
    rombo5=((-1)*rombo)+(r2*(cosd(36+(72*4))+sind(36+(72*4))*j));
    contorno = [rombo1(2), rombo1(1), rombo1(5), rombo2(3), rombo2(2), rombo2(1), rombo3(4), rombo3(3), rombo3(2), rombo4(5), rombo4(4), rombo4(3), rombo5(1), rombo5(5), rombo5(4), rombo1(2)];
    figure()
    plot(sRx_Tot,'.b'),grid on 
    hold on
    plot(constelacion,'*k'),grid on, grid minor
    plot(rombo,'-k')
    plot(contorno,'-k')
%     plot([0 + 0.01i, r + 0.01i], '-b') % graficar radio 1 (distancia minima)
%     plot([0 + 0.01i, r2*cosd(36) + r2*sind(36)*i], '-r') %graficar radio2
    plot([rombo1(1), rombo(1)],'-k')
    plot([rombo1(1), rombo(1)] + (r+0j),'-k')
    plot([rombo5(5), rombo(5)] + (r+0j),'-k')
    plot([rombo2(2), rombo(2)],'-k')
    plot([rombo2(2), rombo(2)]+constelacion(4),'-k')
    plot([rombo1(1), rombo(1)] + constelacion(4),'-k')
    plot([(rombo3(3)+(.01*j)), (rombo(3)+(.01*j))],'-k')
    plot([(rombo3(3)+(.01*j)), (rombo(3)+(.01*j))] + constelacion(6),'-k')
    plot([rombo2(2), rombo(2)]+constelacion(6),'-k')
    plot([rombo4(4), rombo(4)],'-k')
    plot([rombo4(4), rombo(4)] + constelacion(8),'-k')
    plot([(rombo3(3)+(.01*j)), (rombo(3)+(.01*j))] + constelacion(8),'-k')
    plot([rombo5(5), rombo(5)],'-k')
    plot([rombo5(5), rombo(5)] + constelacion(10),'-k')
    plot([rombo4(4), rombo(4)] + constelacion(10),'-k')
    title('Constelación');
    hold off
else
    % Tradicional: 16-QAM
    figure()
    plot(sRx_Tot,'.b'),grid on 
    hold on
    plot(constelacion,'*k'),grid on, grid minor
    title('Constelación');
    hold off
end

% Probabilidades

figure()
subplot(1,3,1);
histogram(b2);grid on
xticks(0:1:1);
xticklabels({'0'; '1'});
title('Bits Recibidos')

subplot(1,3,2);
histogram(index_sTx);grid on
xticks(1:1:M);
xticklabels(mapeo_string);
xtickangle(90);
title('Simbolos Generados')

subplot(1,3,3);
histogram(index_simbolo);grid on
xticks(1:1:M);
xticklabels(mapeo_string);
xtickangle(90);
title('Simbolos Recibidos')

%% Para Guardar

%t1_01 = [All_SER; All_SER_MAP; All_BER; All_BER_MAP]; 

%save('prueba_t1_01.mat', 't1_01')
%save('prueba_1_01.mat','b','Z_randn','prob','num_bits')

% Simbologia de variables guardadas
% - prueba_1_01 
% (1: primer prueba de probabilidades, util para tradicional y propuesta )
% (01: numeracion de ruido(b y Z_rand), va de 01 a 10)
% - prueba_t1_01 
% (t1: (1)primer prueba de probabilidades, (t)para tradicional)
% (01: numeracion de ruido(b y Z_rand), va de 01 a 10)
