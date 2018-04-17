function [ cube ] = load_geoms_cube( filename, gridsize )


if nargin<1
    filename = 'C:\Users\fernando\angolaGeoms2\angola.geoms2\GSI\map_result.ascii';
end

% [~,data] = read_named_columns(filename);
% 
% %% Create output variable
% cube = data{1};

[fid, ~] = fopen(filename);
fgetl(fid);
fgetl(fid);
fgetl(fid);
cube = textscan(fid,'%f');
cube = cube{1};

if nargin>1
    cube = reshape(cube,gridsize);
    cube = permute(cube,[3 2 1]);
    cube = flipud(cube);
%     cube = reshape(cube,gridsize(3),[]);
%     cube = reshape(cube,1,[]);
end

fclose(fid);
end

