function [ cube ] = load_geoms_cube( filename )


if nargin<1
    filename = 'C:\Users\fernando\angolaGeoms2\angola.geoms2\GSI\map_result.ascii';
end

[~,data] = read_named_columns(filename);

%% Create output variable
cube = data{1};


end

