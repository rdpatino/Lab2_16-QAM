function [probabilidades] =  probabilidadSimbolo(mapeo,probabilidad0,probabilidad1)
            
probabilidades = zeros(size(mapeo,1),1);
acumulado = 1; 
for i=1:1:size(mapeo,1)
    for k=1:1:4
        if mapeo(i,k)==0
            p = probabilidad0;
        else
            p = probabilidad1;
        end
        acumulado = p*acumulado; %Probabilidad acumulada en cada simbolo
    end
    probabilidades(i) = acumulado;
    acumulado = 1;
end