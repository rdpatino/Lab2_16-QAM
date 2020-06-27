% Para graficas generales
% Es necesario cargar los 2 resultados promedio
% Utilice buscar y remplazar

load prueba_promedio_t3.mat
load prueba_promedio_p3.mat

load Eb_No_dB.mat % carga Eb/No en dB

%% Graficos

% BER vs Eb/No

EbNoVec = (0:10)';
berTeorica = berawgn(EbNoVec,'qam',16);
figure()
semilogy(EbNoVec,berTeorica);hold on

semilogy(All_Eb_No,t3_promedio(3,:),'*r-'); grid on
semilogy(All_Eb_No,p3_promedio(3,:),'*b-')

semilogy(All_Eb_No,t3_promedio(4,:),'o-','Color',[0.48,0,0]); grid minor
semilogy(All_Eb_No,p3_promedio(4,:),'o-','Color',[0,0.06,0.4])

hold off
legend('BER Teórica 16-QAM tradicional', 'BER estimada promedio tradicional(MD)', 'BER estimada promedio propuesta(MD)','BER estimada promedio tradicional (MAP)','BER estimada promedio propuesta (MAP)','location','southwest');
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate');
xlim([0 10])
ylim([10^(-3) 1])
title('BER vs Eb/No')

% SER vs Eb/No

figure()
semilogy(All_Eb_No,t3_promedio(1,:),'*r-'); hold on, grid on
semilogy(All_Eb_No,p3_promedio(1,:),'*b-')

semilogy(All_Eb_No,t3_promedio(2,:),'o-','Color',[0.48,0,0]); grid minor
semilogy(All_Eb_No,p3_promedio(2,:),'o-','Color',[0,0.06,0.4])
hold off
legend('SER estimada promedio tradicional (MD)','SER estimada promedio propuesta (MD)','SER estimada promedio tradicional (MAP)','SER estimada promedio propuesta (MAP)','location','southwest');
xlabel('Eb/No (dB)');
ylabel('Symbol Error Rate');
xlim([0 10])
ylim([10^(-3) 1])
title('SER vs Eb/No')