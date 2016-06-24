function [pocos,pocosLas,wellsLele] = carregaPocos

%carregaPocos Carrega pocos com o read_las_file da biblioteca Seislab e
%coloca em estruturas usadas por outros scripts


pocosLas{1} = read_las_file('D:/btsync/dados/Jason_projects/JASON BACKUPS/Angola_2014/las_merged/Well_1jgw_merged.las');
pocosLas{2} = read_las_file('D:/btsync/dados/Jason_projects/JASON BACKUPS/Angola_2014/las_merged/Well_2jgw_merged.las');
pocosLas{3} = read_las_file('D:/btsync/dados/Jason_projects/JASON BACKUPS/Angola_2014/las_merged/Well_3jgw_merged.las');
pocosLas{4} = read_las_file('D:/btsync/dados/Jason_projects/JASON BACKUPS/Angola_2014/las_merged/Well_4jgw_merged.las');

stackAllWellSegy = read_segy_file('d:/btsync/dados/stack_allWell.sgy');
wellsLele= [];
for i=1:length(pocosLas)
    [ W_, property, time, timeCalc ] = wellUpscaleMultipleLog(pocosLas{i},4,3000,stackAllWellSegy);
    wellsLele = setfield(wellsLele,['W' num2str(i)],W_);
    
    curvas = [pocosLas{i}.curves(:,5) pocosLas{i}.curves(:,12)];
    curvas(isnan(curvas(:,2)),:)=[];
    pocos{i}.timeInd = ((time-3000)./4)';
    pocos{i}.time = time';
    pocos{i}.ai =property;
    pocos{i}.traceNumber = W_.traceNumber;
    pocosLas{i}.traceNumber = W_.traceNumber;
    pocosLas{i}.time = curvas(:,1);
    pocosLas{i}.ai = curvas(:,2);
end