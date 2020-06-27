function [simbolos_rx, index_simbolo, dmin_decision, demapeo_rx, d_decision, b2] = decision_MD(sRx_Tot, constelacion, mapeo)
%DECISION_MD
%   Demapea los simbolos recibidos con distancia minima

    %Encontrando la distancia minima entre simbolo y simbolo'
    d_decision = zeros(numel(sRx_Tot),numel(constelacion));
    sRx_Tot=sRx_Tot';
    for cont1=1:1:numel(sRx_Tot)
         for cont2=1:1:numel(constelacion)
             d_decision(cont1,cont2) = norm(sRx_Tot(cont1)-constelacion(cont2));
         end
    end
    [dmin_decision,index_simbolo] = min(d_decision,[],2);
    dmin_decision = dmin_decision';
    index_simbolo = index_simbolo';
    
    
    simbolos_rx = zeros(1,numel(index_simbolo));
    demapeo_rx = zeros(numel(index_simbolo),4);

    
    for cont1=1:1:numel(index_simbolo)
        simbolos_rx(1,cont1) = constelacion(1,index_simbolo(1,cont1));
        demapeo_rx(cont1,:) = mapeo(index_simbolo(1,cont1),:); 
        
    end

    b2 = reshape(demapeo_rx,[],1);
end
