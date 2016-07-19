
%% script para carregar um cubo de angola e salvar em binário numpy para ser lido pelo geoms2

[segy] = read_segy_file('D:\btsync\dados\Angola\Angola_00_16.sgy');
indcdp = segy.headers(2,:);
indinl = segy.headers(3,:);
indcdp=indcdp -1409;
indinl=indinl-4900;
indinl=indinl/2;
for i=1:173250
    cubo(indcdp(i)+1,indinl(i)+1,:) = segy.traces(:,i);
end
geomsseis = reshape(cubo,[],1);

% header numpy
copyfile('segyHeader.npy','cubo.npy')
fileID = fopen('cubo.npy','a');

fwrite(fileID,geomsseis,'float','ieee-le');
fclose(fileID);