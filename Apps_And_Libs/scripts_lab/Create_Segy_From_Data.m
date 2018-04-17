%%%Precisa criar a estrutura chamada sismica. Nesta estrutura precisam ser
%%% setados os seguintes atributos:
%%%%%seismic.first - o indice do primeiro traço
%%%%%seismic.last - o indice do ultimo traço
%%%%%seismic.traces - os traços, cada inline lado a lado
%%%%%seismic.headers - os headers dos traços. Calculado com a função
%%%%%meshgrid considerando 150 inlines e 200 crosslines

%%%A função utiliza a chamada a write_segy_file, da biblioteca seisLab10

seismic=s_data3d;
seismic.last = 800;
seismic.traces = ai_cubo_norm;
[X,Y] = meshgrid(1:150,1:200);
seismic.headers = [X(:)';Y(:)'];
write_segy_file(seismic,'inversao.segy',{'headers',{'iline_no',189,4},{'xline_no',193,4}});