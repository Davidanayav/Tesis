[y,Fs] = audioread('Multiphonic.wav'); %leer archivo de audio y asignar variable
y = y(1:44100,1)'; %obtener primer canal y un segundo del audio                    
t = linspace(0, 1, length(y));
[cfs,f] = cwt(y,'morse', Fs); %Transformada continua de wavelet
freqs = (40:80);
times = (8820:11025);
coef = zeros(size(cfs));
coef(freqs, times) = cfs(freqs, times);
grain = icwt(coef);           %Transformada inversa
p = audioplayer(grain/max(grain), Fs);   %Reproducir el grano
% audiowrite('GranoCWT.wav',grain, Fs);
play(p)

%Graficar señal y grano
t2 = linspace(0, 1, length(grain));
figure(1);
subplot(2,1,1);
plot(t,y);
grid on;
title('Señal Original');
subplot(2,1,2);
plot(t2,grain)
grid on;
title('Grano');

figure(2);
subplot(1,2,1);
% cfsplot=flip(cfs,1);
imagesc(t, f, abs(cfs).^2);
shading interp
axis tight
view(0, 90)
x0=10;
y0=10;
width=900;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])
set(gca, 'FontName', 'Arial', 'FontSize', 14)
xlabel('Tiempo(s)')
xticklabels = 0:0.2:1;
xticks = linspace(1, size(cfs, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels, 'Ydir', 'normal' )
ylabel('Escala')
title('Escalograma Señal Original')
hcol = colorbar;
set(hcol, 'FontName', 'Arial', 'FontSize', 14)
ylabel(hcol, 'Magnitud (db)')


subplot(1,2,2);
% coefplot=flip(coef,1);
imagesc(t, f, abs(coef).^2);
shading interp
axis tight
view(0, 90)
x0=10;
y0=10;
width=900;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])
set(gca, 'FontName', 'Arial', 'FontSize', 14)
xticklabels = 0:0.05:1;
xticks = linspace(1, size(cfs, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels, 'Ydir', 'normal' )
xlabel('Tiempo (s)')
ylabel('Escala')
title('Escalograma Señal Procesada')
hcol = colorbar;
set(hcol, 'FontName', 'Arial', 'FontSize', 14)
ylabel(hcol, 'Magnitud (db)')


% %Síntesis granular
% framesize = .05 * Fs;
% hopsize = round(.5 * framesize); 
% numframes = floor((length(y) - framesize + hopsize) / hopsize); 
% framematrix = zeros(framesize,numframes);
% 
% %Decompose signal into frames
% for currentframe = 1:hopsize:length(y)-framesize
%         %thisframe = y(currentframe:currentframe+framesize-1);
%         grain2 = grain.' ;
%         framematrix(:,round(currentframe/hopsize)+1) = grain2(2000:4399) .* hanning(framesize);
%         %plot(thisframe' .* hanning(framesize));
%         %pause;
% end
% 
% %% Reconstructing the signal in random grain order
% newsignal = zeros(1, length(y));
% randframes = randperm(numframes);
% for currentframe = 1:numframes
%         signalindex = (currentframe-1)*hopsize+1:(currentframe-1)*hopsize+framesize;
%         newsignal(signalindex) = newsignal(signalindex) + framematrix(:,randframes(currentframe))';
% end
% 
% p = audioplayer(newsignal, Fs); %Reproducir señal reconstruída aleatoriamente con los granos
% play(p)
