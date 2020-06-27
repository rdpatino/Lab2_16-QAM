function [simbolosTx, mapeo, mapeo_string, index_sTx, mapeo_tx] = mapeo(tipo, constelacion, b)
%MAPEO 
%   Mapea los bits recibidos segun el tipo de constelación

    if tipo == "propuesta"
        % 16-QAM' (Estrella5)
        mapeo = [0 1 0 1; 1 0 1 0; 1 0 1 1; 1 1 0 1; 0 0 1 0; 0 0 0 1; 0 0 1 1; 0 1 0 0; 1 1 0 0; 0 1 1 1; 1 1 1 1; 1 0 0 0; 1 0 0 1; 0 0 0 0; 0 1 1 0; 1 1 1 0];
        mapeo_string = ['0 1 0 1'; '1 0 1 0'; '1 0 1 1'; '1 1 0 1'; '0 0 1 0'; '0 0 0 1'; '0 0 1 1'; '0 1 0 0'; '1 1 0 0'; '0 1 1 1'; '1 1 1 1'; '1 0 0 0'; '1 0 0 1'; '0 0 0 0'; '0 1 1 0'; '1 1 1 0'];
        %mapeo_string si funciona pero no tiene un uso aún
    else
        % 16-QAM 
        mapeo = [1 1 1 1; 1 1 1 0; 1 1 0 1; 1 1 0 0; 1 0 1 0; 1 0 0 0; 1 0 1 1; 1 0 0 1; 0 0 1 0; 0 0 1 1; 0 0 0 1; 0 0 0 0; 0 1 0 0; 0 1 1 0; 0 1 1 1; 0 1 0 1];
        mapeo_string = ['1 1 1 1'; '1 1 1 0'; '1 1 0 1'; '1 1 0 0'; '1 0 1 0'; '1 0 0 0'; '1 0 1 1'; '1 0 0 1'; '0 0 1 0'; '0 0 1 1'; '0 0 0 1'; '0 0 0 0'; '0 1 0 0'; '0 1 1 0'; '0 1 1 1'; '0 1 0 1'];
        %mapeo_string si funciona pero no tiene un uso aún
    end

    g4 = reshape(b,[],4); %Agrupacion de bits en grupos de 4 (16-QAM)
    simbolosTx = zeros(size(g4,1),1) +NaN; %Vector de ceros del tama�o de los simbolos
    index_sTx = zeros(size(g4,1),1);
    mapeo_tx = zeros(size(g4,1),4);
    for cont1=1:size(g4,1)
        for cont2=1:size(mapeo,1)
            if g4(cont1,:) == mapeo(cont2,:)
                simbolosTx(cont1) = constelacion(1,cont2); %Simbolos a transmitir
                mapeo_tx(cont1,:) = mapeo(cont2,:); %Simbolos a transmitir en formato de texto
                index_sTx(cont1) = cont2; %Array con los simbolos de acuerdo al array de mapeo (1:16)
            else
            %No hace nada 
            end
        end
    end
    
end
