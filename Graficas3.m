% Para graficas finales
% Ya estan cargados los resultados promedio, solo mire cuales comparar

load prueba_promedio_t1.mat
load prueba_promedio_p1.mat
load prueba_promedio_t2.mat
load prueba_promedio_p2.mat
load prueba_promedio_t3.mat
load prueba_promedio_p3.mat

load Eb_No_dB.mat % carga Eb/No en dB

%% Graficos

% BER vs Eb/No

semilogy(All_Eb_No,t1_promedio(4,:),'.-', 'Color',[0.48,0,0]); hold on, grid on, grid minor
semilogy(All_Eb_No,p1_promedio(4,:),'.-', 'Color',[0,0.06,0.4])

semilogy(All_Eb_No,t3_promedio(4,:),'*r-')
semilogy(All_Eb_No,p3_promedio(4,:),'*b-')

hold off
legend('[0.5 0.5] tradicional(MAP)', '[0.5 0.5] propuesta(MAP)','[0.6 0.4] tradicional(MAP)', '[0.6 0.4] propuesta(MAP)','location','southwest');
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate');
xlim([3 10])
ylim([10^(-3) 10^(-1)])
title('BER (estimada promedio) vs Eb/No')

% SER vs Eb/No

figure()
semilogy(All_Eb_No,t1_promedio(1,:),'.-', 'Color',[0.48,0,0]); hold on, grid on, grid minor
semilogy(All_Eb_No,p1_promedio(1,:),'.-', 'Color',[0,0.06,0.4])

semilogy(All_Eb_No,t3_promedio(2,:),'*r-')
semilogy(All_Eb_No,p3_promedio(2,:),'*b-')

hold off
legend('[0.5 0.5] tradicional(MAP)', '[0.5 0.5] propuesta(MAP)','[0.6 0.4] tradicional(MAP)', '[0.6 0.4] propuesta(MAP)','location','southwest');
xlabel('Eb/No (dB)');
ylabel('Symbol Error Rate');
xlim([3 10])
ylim([10^(-2) 1])
title('SER (estimada promedio) vs Eb/No')