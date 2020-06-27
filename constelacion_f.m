function [constelacion] = constelacion_f(tipo_constelacion)
%CONSTELACION 
%   Genera constelación 16-QAM entre la tradicional y la propuesta (Estrella5)
    
    tipo = 'propuesta';
    
    if  isequal(tipo_constelacion,tipo) 
        % Propuesta: 16-QAM' (Estrella5)
        r=sqrt(2); 
        r2=r*(sind(108)/sind(36)); %r2=r*(1.6180);
        constelacion = [(0+0j),(r+0j),((2*r)+0j),(r*(cosd(72)+sind(72)*j)), (2*r*(cosd(72)+sind(72)*j)), (r*(cosd(72*2)+sind(72*2)*j)),(2*r*(cosd(72*2)+sind(72*2)*j)), (r*(cosd(72*3)+sind(72*3)*j)),(2*r*(cosd(72*3)+sind(72*3)*j)), (r*(cosd(72*4)+sind(72*4)*j)),(2*r*(cosd(72*4)+sind(72*4)*j)), (r2*(cosd(36)+sind(36)*j)),(r2*(cosd(36+72)+sind(36+72)*j)), (r2*(cosd(36+(72*2))+sind(36+(72*2))*j)),(r2*(cosd(36+(72*3))+sind(36+(72*3))*j)), (r2*(cosd(36+(72*4))+sind(36+(72*4))*j))];
    else
        % Tradicional: 16-QAM
        constelacion = [(-3-3i),(-1-3i),(-3-1i),(-1-1i),(-3+1i),(-1+1i),(-3+3i),(-1+3i),(1+3i),(3+3i),(3+1i),(1+1i),(1-1i),(3-1i),(3-3i),(1-3i)];
    end
end
