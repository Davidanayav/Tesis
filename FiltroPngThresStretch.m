[a,Fs] = audioread('Multiphonic.wav'); %leer archivo de audio
a = a(:,1)'; %obtener primer canal
t = linspace(0, 1, length(a)); %definir espacio temporal
[cfs,f] = cwt(a,'sym2', Fs); %Wavelet transform


img = imread('mandelbrot.jpg'); %leer imagen y asignar variable
img = im2double( rgb2gray(img) ); %convertir imagen a escala de grises y valores a "double"
img = imresize(img, [size(cfs, 1), size(cfs, 2)] ); %adaptar imagen al tamaño del audio
coef = cfs .* img; %multiplicar audio por imagen

grain = icwt(coef);           %Transformada inversa
p = audioplayer(grain/max(grain), Fs);   %Reproducir el grano
% audiowrite('CírculosCWT.wav',grain,Fs);
play(p) %reproducción

%Graficar señal original y procesada
t2 = linspace(0, 1, length(grain));
figure(1);
subplot(2,1,1);
plot(t,a);
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
xticklabels = 0:1:7;
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
xticklabels = 0:1:7;
xticks = linspace(1, size(coef, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels, 'Ydir', 'normal' )
xlabel('Tiempo (s)')
ylabel('Escala')
title('Escalograma Señal Procesada')
hcol = colorbar;
set(hcol, 'FontName', 'Arial', 'FontSize', 14)
ylabel(hcol, 'Magnitud (db)')