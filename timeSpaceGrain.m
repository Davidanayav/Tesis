[y,Fs] = audioread('C:\Users\user\Documents\Samples and Loops\Classic drum machines\909 08 - Crash Cymbal\909cc_t0.wav');
t = linspace(0, 1, length(y));
[cfs,f] = cwt(y, 'amor', Fs);
T1 = 1;  T2 = 0.3;
F1 = 1;   F2 = 147;
coef = cfs(10:12, 10000:20000);
%cfs(400:500, 40000:71056) = 0;
grain = icwt(coef);
p = audioplayer(grain, Fs);
play(p)
t2 = linspace(0, 1, length(grain));
subplot(2,1,1);
plot(t,y);
grid on;
title('Original Signal');
subplot(2,1,2);
plot(t2,grain)
grid on;
title('Grain');

