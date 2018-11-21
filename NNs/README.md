# Tesis

Este proyecto hace uso de la librería pyWaveletes para el análisis de audio. La carpeta 'Wavelets' contiene archivos .npy cuyo contenido son arrays con los coeficientes wlt obtenidos por la función wavedec de dicha librería.
Los descriptores de los sonidos en la carpeta 'audios' fueron extraidos utilizando la librería pyAudioAnalysis https://github.com/tyiannak/pyAudioAnalysis
y con el siguiente comando: 
python audioAnalysis.py  featureExtractionDir -i data/ -mw 1.0 -ms 1.0 -sw 0.050 -ss 0.050
