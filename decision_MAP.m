function [simbolos_rx_MAP,index_simbolo_MAP,map_decision,demapeo_rx_MAP,b2_MAP] = decision_MAP(constelacion,sRx_Tot,probabilidades,mapeo,Eb,Eb_No,d_decision)
%DECISION_MAP
%   Demapea los simbolos recibidos con map

    No=Eb/Eb_No;
    numerador = zeros(numel(sRx_Tot),numel(constelacion));
    denominador = zeros(numel(sRx_Tot),1);
    matrix = zeros(numel(sRx_Tot),numel(constelacion));

    for i=1:1:numel(sRx_Tot)
        acumulado = 0;
        for j=1:1:numel(constelacion)
            numerador(i,j) = probabilidades(j)*((exp(-(d_decision(i,j)^2)/No))/sqrt(pi*No));
            %numerador(i,j) = probabilidades(j)*((exp(-(d_decision(i,j)^2)/No)));
            acumulado = acumulado + numerador(i,j);
        end
        denominador(i,1)=acumulado;
    end

    for i=1:1:numel(sRx_Tot)
        for j=1:1:numel(constelacion)
            matrix(i,j) = numerador(i,j)/denominador(i);
        end
    end

    [map_decision,index_simbolo_MAP] = max(matrix,[],2);

    map_decision = map_decision';
    index_simbolo_MAP = index_simbolo_MAP';

    simbolos_rx_MAP = zeros(1,numel(index_simbolo_MAP));
    demapeo_rx_MAP = zeros(numel(index_simbolo_MAP),4);

    for cont1=1:1:numel(index_simbolo_MAP)
        simbolos_rx_MAP(1,cont1) = constelacion(1,index_simbolo_MAP(1,cont1));
        demapeo_rx_MAP(cont1,:) = mapeo(index_simbolo_MAP(1,cont1),:); 
    end
    
    b2_MAP = reshape(demapeo_rx_MAP,[],1);
end

