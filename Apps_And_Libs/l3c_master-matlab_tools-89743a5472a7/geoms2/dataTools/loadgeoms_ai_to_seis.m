function [ ai,seis ] = loadgeoms_ai_to_seis( filename, wavelet, seis_original )

% carrega cubo de ia do geoms, transforma em sismica e compara com a
% sismica original

geomscube = load_geoms_cube(filename);
ai = geoms_ai_to_seis(geomscube,wavelet,seis_original);


end

