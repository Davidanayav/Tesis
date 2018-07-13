[y,Fs] = audioread('C:\Users\user\Documents\Samples and Loops\Classic drum machines\909 08 - Crash Cymbal\909cc_t0.wav');
t = linspace(0, 1, length(y));
[cfs,f] = cwt(y, 'amor', Fs); %Wavelet transform
T1 = 1;  T2 = 0.3;
F1 = 1;   F2 = 147;
coef = cfs(10:30, 2000:4399); %Filtro en f y t
grain = icwt(coef);           %Transformada inversa
p = audioplayer(grain, Fs);   %Reproducir el grano
play(p)

%Graficar señal y grano
t2 = linspace(0, 1, length(grain));
subplot(2,1,1);
plot(t,y);
grid on;
title('Original Signal');
subplot(2,1,2);
plot(t2,grain)
grid on;
title('Grain');

%Síntesis granular
framesize = .05 * Fs;
hopsize = round(.5 * framesize); 
numframes = floor((length(y) - framesize + hopsize) / hopsize); 
framematrix = zeros(framesize,numframes);

%Decompose signal into frames
for currentframe = 1:hopsize:length(y)-framesize
        %thisframe = y(currentframe:currentframe+framesize-1);
        grain2 = grain.' ;
        framematrix(:,round(currentframe/hopsize)+1) = grain2 .* hanning(framesize);
        %plot(thisframe' .* hanning(framesize));
        %pause;
end

%% Reconstructing the signal in random grain order
newsignal = zeros(1, length(y));
randframes = randperm(numframes);
for currentframe = 1:numframes
        signalindex = (currentframe-1)*hopsize+1:(currentframe-1)*hopsize+framesize;
        newsignal(signalindex) = newsignal(signalindex) + framematrix(:,randframes(currentframe))';
end

p = audioplayer(newsignal, Fs); %Reproducir señal reconstruída aleatoriamente con los granos
play(p)
