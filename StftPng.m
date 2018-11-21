clear, clc, close all

[x, fs] = audioread('Multiphonic.wav');   % abrir archivo de audio
x = x(:, 1);                        % obtener primer canal

% parámetros de análisis
wlen = 64;                        % window length (recomended to be power of 2)
hop = wlen/4;                       % hop size (recomended to be power of 2)
nfft = 4096;                        % number of fft points (recomended to be power of 2)

%STFT
win = blackman(wlen, 'periodic');
[spec, f, t] = stft(x, win, hop, nfft, fs);

img = imread('circle.png');
img = im2double( img );
img = imresize(img, [size(spec, 1), size(spec, 2)] );

sizex = size(spec,1);
sizey = size(spec,2);
x = 1:sizex; 
y = 1:sizey;
nx = sizex; 
ny = sizey; 
xi = logspace(log10(1),log10(nx),nx); 
yi = linspace(1,ny,ny);
[X,Y] = ndgrid(x,y);
F = griddedInterpolant(X,Y,img,'cubic');
[XI,YI] = ndgrid(xi,yi);
img2 = F(XI,YI);
img2 = flip(img2,1);
S = img2.*spec;

%resynthesis
synth_win = hamming(wlen, 'periodic');
[x_istft, t_istft] = istft(S, win, synth_win, hop, nfft, fs);
p = audioplayer(x_istft/max(x_istft), fs);   %Reproducir el grano
audiowrite('MandelbrotSTFT.wav',x_istft,fs);
play(p)
%audiowrite('FlechaSTFT.wav',x_istft,fs);

% calculate the coherent amplification of the window
C = sum(win)/wlen;

% take the amplitude of fft(x) and scale it, so not to be a
% function of the length of the window and its coherent amplification
S = abs(S)/wlen/C;

spec = abs(spec)/wlen/C;

% correction of the DC & Nyquist component
if rem(nfft, 2)                     % odd nfft excludes Nyquist point
    S(2:end, :) = S(2:end, :).*2;
else                                % even nfft includes Nyquist point
    S(2:end-1, :) = S(2:end-1, :).*2;
end

if rem(nfft, 2)                     % odd nfft excludes Nyquist point
    spec(2:end, :) = spec(2:end, :).*2;
else                                % even nfft includes Nyquist point
    spec(2:end-1, :) = spec(2:end-1, :).*2;
end

% convert amplitude spectrum to dB (min = -120 dB)
S = 20*log10(S + 1e-6);

spec = 20*log10(spec + 1e-6);

% plot the spectrogram
% figure(1)
% surf(t, f, S)
% shading interp
% axis tight
% view(0, 90)
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
% xlabel('Time, s')
% ylabel('Frequency, Hz')
% title('Amplitude spectrogram of the signal')
% 
% hcol = colorbar;
% set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
% ylabel(hcol, 'Magnitude, dB')

%gráficas
figure(2);
subplot(1,2,1);
%cfsplot=flip(spec,1);
surf(t,f,spec);
shading interp
axis tight
view(0, 90)
x0=10;
y0=10;
width=900;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])
set(gca, 'FontName', 'Arial', 'FontSize', 13)
xlabel('Tiempo (s)')
ylabel('Frecuencia (Hz)')
title('Espectrograma Original')
hcol = colorbar;
set(hcol, 'FontName', 'Arial', 'FontSize', 14)
ylabel(hcol, 'Magnitud (db)')


subplot(1,2,2);
% coefplot=flip(coef,1);
t2=linspace(1, size(S,2), size(S,2)); 
surf(t, f ,S);
shading interp
axis tight
view(0, 90)
x0=10;
y0=10;
width=900;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])
set(gca, 'FontName', 'Arial', 'FontSize', 12)
xlabel('Tiempo (s)')
ylabel('Frecuencia (Hz)')
title('Espectrograma Resultante')
hcol = colorbar;
set(hcol, 'FontName', 'Arial', 'FontSize', 14)
ylabel(hcol, 'Magnitud (db)')