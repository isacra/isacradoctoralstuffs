
f1 = normpdf(1:500,250,5);
f1 = f1/sum(f1);
f2 = normpdf(1:500,250,15);
f2 = f2/sum(f2);
G = randn(500,1);

% w1 = [ones(250,1); zeros(250,1)]';
% w1 = conv(f2,w1,'same');
% w2 = [zeros(250,1); ones(250,1)]';
% w2 = conv(f2,w2,'same');
w1 = [1:500]/500;
w2 = 1-w1;
convolve(f1,f2,G,w1,w2);