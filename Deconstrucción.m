[y,Fs] = audioread('Multiphonic.wav'); %leer archivo de audio y asignar a y
y = y(1:44100,1)';  %obtener primer canal y un segundo del audio
t = linspace(0, 1, length(y));
[cfs,f] = cwt(y,'morse', Fs); %Transformada continua de Wavelet

%divir matriz en submatrices

sz = [126 44100]; % tamaño de matriz original
chunk_size = [18 2205]; % tamaño de las submatrices
sc = sz ./ chunk_size; % número de submatrices por cada dimensión (debe ser entero)

divv = mat2cell(cfs, chunk_size(1) * ones(sc(1),1), chunk_size(2) *ones(sc(2),1));
i = randperm(20);
ii = randperm(7);
perm = divv(ii,:);  %permutación
cfs2 = cell2mat(perm);
coef = smooth2a(cfs2, 10, 10); %smoothing

% coef = flip(cfs,2);
grain = icwt(coef);           %Transformada inversa
p = audioplayer(grain/max(grain), Fs);   %Reproducir señal obtenida
% audiowrite('FreqRandomizationSmooth.wav',grain, Fs);
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
title('Señal Procesada');

figure(2);
subplot(1,2,1);
% cfsplot=flip(cfs,1);
imagesc(10*log10(abs(cfs)));
shading interp
axis tight
view(0, 90)
x0=10;
y0=10;
width=900;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])
set(gca, 'FontName', 'Arial', 'FontSize', 14)
xlabel('Tiempo (s)')
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
imagesc(10*log10(abs(coef)));
shading interp
axis tight
view(0, 90)
x0=10;
y0=10;
width=900;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])
set(gca, 'FontName', 'Arial', 'FontSize', 14)
xticklabels = 0:0.2:1;
xticks = linspace(1, size(coef, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels, 'Ydir', 'normal' )
xlabel('Tiempo (s)')
ylabel('Escala')
title('Escalograma Señal Procesada')
hcol = colorbar;
set(hcol, 'FontName', 'Arial', 'FontSize', 14)
ylabel(hcol, 'Magnitud (db)')