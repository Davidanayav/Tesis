clear, clc, close all

[x, fs] = audioread('Multiphonic.wav');   % ler archivo de audio
x = x(1:44100, 1);                        % obtener el primer canal

% par�metros de an�lisis
wlen = 64;                        % window length (recomended to be power of 2)
hop = wlen/4;                       % hop size (recomended to be power of 2)
nfft = 4096;                        % number of fft points (recomended to be power of 2)

% STFT
win = blackman(wlen, 'periodic');
[spec, f, t] = stft(x, win, hop, nfft, fs);

%filter
freqs = (650:1301);
times = (550:688);
S = zeros(size(spec));
S(freqs, times) = spec(freqs, times);

%res�ntesis
synth_win = hamming(wlen, 'periodic');
[x_istft, t_istft] = istft(S, win, synth_win, hop, nfft, fs);
p = audioplayer(x_istft/max(x_istft), fs);   %Reproducir el grano
%audiowrite('GranoSFTF.wav',x_istft, fs);
play(p)

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

%gr�ficas
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