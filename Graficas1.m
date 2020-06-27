% Para graficas promedios
% Es necesario cargar los 10 resultados para cada ruido
% Utilice buscar y remplazar

load prueba_p3_01.mat
load prueba_p3_02.mat
load prueba_p3_03.mat
load prueba_p3_04.mat
load prueba_p3_05.mat
load prueba_p3_06.mat
load prueba_p3_07.mat
load prueba_p3_08.mat
load prueba_p3_09.mat
load prueba_p3_10.mat

load Eb_No_dB.mat % carga Eb/No en dB

%% Variables
All_SER = [p3_01(1,:);p3_02(1,:);p3_03(1,:);p3_04(1,:);p3_05(1,:);p3_06(1,:);p3_07(1,:);p3_08(1,:);p3_09(1,:);p3_10(1,:)];
All_SER_MAP = [p3_01(2,:);p3_02(2,:);p3_03(2,:);p3_04(2,:);p3_05(2,:);p3_06(2,:);p3_07(2,:);p3_08(2,:);p3_09(2,:);p3_10(2,:)];

All_BER = [p3_01(3,:);p3_02(3,:);p3_03(3,:);p3_04(3,:);p3_05(3,:);p3_06(3,:);p3_07(3,:);p3_08(3,:);p3_09(3,:);p3_10(3,:)];
All_BER_MAP = [p3_01(4,:);p3_02(4,:);p3_03(4,:);p3_04(4,:);p3_05(4,:);p3_06(4,:);p3_07(4,:);p3_08(4,:);p3_09(4,:);p3_10(4,:)];

All_SER_p = mean(All_SER);
All_SER_MAP_p = mean(All_SER_MAP);

All_BER_p = mean(All_BER);
All_BER_MAP_p = mean(All_BER_MAP);


%% Graficos

% BER vs Eb/No

EbNoVec = (0:10)';
berTeorica = berawgn(EbNoVec,'qam',16);
figure()
semilogy(EbNoVec,berTeorica);hold on

semilogy(All_Eb_No,All_BER_p,'*r-'); grid on
semilogy(All_Eb_No,All_BER_MAP_p,'ob-'); grid minor

hold off
legend('BER Teórica 16-QAM tradicional', 'BER estimada promedio (MD)','BER estimada promedio (MAP)','location','southwest');
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate');
xlim([0 10])
ylim([10^(-3) 1])
title('BER vs Eb/No')

% SER vs Eb/No

figure()
semilogy(All_Eb_No,All_SER_p,'*r-'); hold on
semilogy(All_Eb_No,All_SER_MAP_p,'ob-'); grid on, grid minor
hold off
legend('SER estimada promedio (MD)','SER estimada promedio (MAP)','location','southwest');
xlabel('Eb/No (dB)');
ylabel('Symbol Error Rate');
xlim([0 10])
ylim([10^(-3) 1])
title('SER vs Eb/No')


p3_promedio = [All_SER_p; All_SER_MAP_p; All_BER_p; All_BER_MAP_p];
save('prueba_promedio_p3.mat', 'p3_promedio')