function exportPocos2Geoms( pocos , filename )

%exportPocos2Geoms pega pocos carregados com carregaPocos e exporta para o
%formato do geoms2


fileID = fopen(filename,'W');

fprintf(fileID,'angola\n4\nX\nY\nZ\nAI\n');


    for i=1:length(pocos)

        for j=1:length(pocos{i}.time)

            if (~isnan(pocos{i}.ai(j))) && (~isnan(pocos{i}.time(j)))
                if (isvector(pocos{i}.traceNumber))
                    fprintf(fileID,[num2str(pocos{i}.traceNumber(j)) ' \t1\t' num2str(pocos{i}.time(j)) '\t' num2str(pocos{i}.ai(j)) '\n']);
                else
                    fprintf(fileID,[num2str(pocos{i}.traceNumber) ' \t1\t' num2str(pocos{i}.time(j)) '\t' num2str(pocos{i}.ai(j)) '\n']);
                end
            end
        end

    end


fclose(fileID);

end

