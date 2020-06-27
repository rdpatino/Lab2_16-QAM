function [bits_generados] = fuente_bits(n_bits,prob)
%FUENTE_BITS 
%   Genera matriz de 'n_bits' x 1 de 0s y 1s distribuidos segun 'prob'

bits_generados = randsrc(n_bits,1,[0 1; prob]); %Generación de bits

end
