function [ filters ] = create_filters_map( N, f_size, filter_tipe )
%CREATE_FILTERS_MAP Summary of this function goes here
%   Detailed explanation goes here
filters = zeros(f_size,f_size,N);
for i = 1:N
    filters(:,:,i)=(rand(f_size)- .5);
end

end

