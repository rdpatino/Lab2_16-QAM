% Graficas que puede usar en Principal

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

% Simbolos
simbolos_imprimir = [simbolosTx, sRx_Tot', simbolos_rx']; % Enviados, Recibidos (antes y despues de decision)
[index_sTx, index_simbolo'];

figure()
subplot(2,2,1);
stem(real(sTx'),'x'),hold on %Parte real de los simbolos antes del filtro
stem(imag(sTx')),grid on %Parte imaginaria de los simbolos antes del filtro
title('Simbolos transmisor upsample');
legend('Parte real','Parte imaginaria');
hold off

subplot(2,2,2);
stem(real(simbolosTx),'x'),hold on %Parte real de los simbolos antes del filtro
stem(imag(simbolosTx)),grid on %Parte imaginaria de los simbolos antes del filtro
title('Simbolos transmisor');
legend('Parte real','Parte imaginaria');
hold off

subplot(2,2,3);
stem(real(sRx_Tot'),'x'),hold on %Parte real de los simbolos antes del decisor
stem(imag(sRx_Tot')),grid on %Parte imaginaria de los simbolos antes del decisor
title('Simbolos antes del decisor');
legend('Parte real','Parte imaginaria');
hold off

subplot(2,2,4);
stem(real(simbolos_rx),'x'),hold on %Parte real de los simbolos despues del decisor
stem(imag(simbolos_rx)),grid on %Parte imaginaria de los simbolos despues del decisor
title('Simbolos Receptor');
legend('Parte real','Parte imaginaria');
hold off

%Señal transmitida y filtro
figure()
subplot(3,1,1);
plot(real(sFiltrada)),hold on
plot(imag(sFiltrada)),grid on
title('Señal a la salida del filtro p(t)');
legend('Parte real','Parte imaginaria');
hold off

subplot(3,1,2)
plot(sTx_T),grid on
title('Señal transmitida');

subplot(3,1,3);
plot(sTx_T),hold on
plot(Z,'m'),grid on
title('Señal en el canal');
legend('Señal','Ruido');
hold off

% Probabilidades
figure()
subplot(1,3,1);
histogram(b);grid on
xticks(0:1:1);
xticklabels({'0'; '1'});
title('Bits Generados')

subplot(1,3,2);
histogram(index_sTx);grid on
xticks(1:1:M);
xticklabels(mapeo_string);
xtickangle(-70);
title('Simbolos Generados')

subplot(1,3,3);
histogram(index_simbolo);grid on
xticks(1:1:M);
xticklabels(mapeo_string);
xtickangle(-70);
title('Simbolos Recibidos')
