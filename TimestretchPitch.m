[a,Fs] = audioread('glissup.wav'); %leer archivo de audio
a = a(:,1)'; %obtener primer canal
t = linspace(0, 1, length(a)); %definir espacio temporal
[coef,f] = cwt(a,'amor', Fs); %Transformada continua de Wavelet

%Time stretching
sizex = size(coef,1);
sizey = size(coef,2);
x = 1:sizex; 
y = 1:sizey;
nx = sizex; 
ny = sizey; 
nix = sizex;
niy = sizey*2; %duplicar el tamaño de la tabla
xi = linspace(1,nx,nix); 
yi = linspace(1,ny,niy);
[X,Y] = ndgrid(x,y);
F = griddedInterpolant(X,Y,coef,'cubic'); %interpolación
[XI,YI] = ndgrid(xi,yi);
coef2 = F(XI,YI);

grain = icwt(coef2);           %Transformada inversa
p = audioplayer(grain/max(grain), Fs);   %Reproducir el grano
% audiowrite('TimeStretchFreqFlipGlissup.wav',grain,Fs);
play(p)

%Graficar señal original y procesada
t2 = linspace(0, 1, length(grain));
figure(1);
subplot(2,1,1);
plot(t,a);
grid on;
title('Original Signal');
subplot(2,1,2);
plot(t2,grain)
grid on;
title('Grain');

figure(2);
subplot(1,2,1);
cfsplot=flip(cfs,1);
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
xticklabels = 0:1:5;
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
xticklabels = 0:2:10;
xticks = linspace(1, size(coef, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels, 'Ydir', 'normal' )
xlabel('Tiempo (s)')
ylabel('Escala')
title('Escalograma Señal Procesada')
hcol = colorbar;
set(hcol, 'FontName', 'Arial', 'FontSize', 14)
ylabel(hcol, 'Magnitud (db)')