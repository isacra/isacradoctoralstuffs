function convolve = convolve(f1,f2,G,w1,w2)

convG1 = w1.*conv(f1,G,'same');
convG2 = w2.*conv(f2,G,'same');

convolve = convG1+convG2;
figure;plot(convolve);
end