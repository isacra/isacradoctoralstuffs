function im_out = imUnpad(im_in, mask_pad, pad)

im_out1 = im_in ./ mask_pad;
im_out = im_out1(pad+1:end-pad, pad+1:end-pad, :);
