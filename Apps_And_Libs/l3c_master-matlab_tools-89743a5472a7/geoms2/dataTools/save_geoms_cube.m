function save_geoms_cube( cube, filename )


if nargin<2
    filename = 'C:\Users\fernando\Documents\MATLAB\mapDSS\geoms\map_strat.prn';
end
cube=cube';

fileID = fopen(filename,'W');

fprintf(fileID,'AI_map\n1\nmap_result\n');

fprintf(fileID,'%f\n',cube(:));



fclose(fileID);


end

