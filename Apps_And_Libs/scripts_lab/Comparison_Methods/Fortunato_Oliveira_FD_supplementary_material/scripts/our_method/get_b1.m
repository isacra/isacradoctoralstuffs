function b1 = get_b1(im_in)

dx   = [-0.5, 0, 0.5];
dy   = [-0.5; 0; 0.5];
dxx  = [-1 / 1.4142, 2 / 1.4142, -1 / 1.4142];
dyy  = [-1 / 1.4142; 2 / 1.4142; -1 / 1.4142]; 
dxy  = [-1.4142, 1.4142, 0; 1.4142, -1.4142, 0 ; 0, 0, 0];

dx  = rot90(dx,2 ); %rot 180 deg, same as flipud(fliplr(dx));    
dy  = rot90(dy,2 );
dxx = rot90(dxx,2);
dyy = rot90(dyy,2);
dxy = rot90(dxy,2); 

conj_dx  = rot90(dx,2 ); %rot 180 deg, same as flipud(fliplr(dx));    
conj_dy  = rot90(dy,2 );
conj_dxx = rot90(dxx,2);
conj_dyy = rot90(dyy,2);
conj_dxy = rot90(dxy,2);    

% use_dx
lambda = 0.065;

w  = conv2(im_in, dx, 'same');       
w  = sparse(w, lambda);
b1 = conv2(w, conj_dx, 'same');

w  = conv2(im_in, dy, 'same');
w  = sparse(w, lambda);
b1 = b1 + conv2(w, conj_dy, 'same');

% use_dxx
lambda = 0.5 * lambda;

w  = conv2(im_in, dxx, 'same');
w  = sparse(w, lambda);
b1 = b1 + conv2(w, conj_dxx, 'same');

w  = conv2(im_in, dyy, 'same');
w  = sparse(w, lambda);
b1 = b1 + conv2(w, conj_dyy, 'same');

% use_dxy
w  = conv2(im_in, dxy, 'same');
w  = sparse(w, lambda);
b1 = b1 + conv2(w, conj_dxy, 'same');  % b1xy
        
%---------------------------------------------------
function dw = sparse(x, lambda)
%dw =  x .* ( 1 - (1 ./ (1 + ((x / lambda) .^ 4)) ) );
    
    xl = lambda ./ x;
    xl = xl .* xl;
    xl = xl .* xl; % = (lambda ./ x) .^ 4
    xl = 1 + xl;
    
    dw =  x ./ xl;

    
