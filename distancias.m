function [dmin,dorigen] = distancias(constelacion)
M = numel(constelacion);

%Encontrando la distancia mínima entre dos símbolos de la constelacion
d = zeros(M,M);
for i=1:1:M
     for k=1:1:M
         if k==i
            d(i,k) = NaN; % Para omitir distancias entre mismos simbolos
         else
            d(i,k) = norm(constelacion(i)-constelacion(k));
         end
     end
end
dmin = min(min(d,[],'omitnan')); %Distancia mínima en la constelación

dorigen = zeros(1,M); 
for i=1:1:M
    dorigen(i) = norm(constelacion(i)-0); %Distancia de cada uno de los puntos al origen
end