data= load('descriptors.txt');
[Y,Xf,Af] = NNDescriptoresFourier(data(1:68),1,22050); %No sé qué poner como tercer argumento(Timesteps)
wf = ifft(Y); %Esperaba que la transformada inversa me arrojara valores de amplitud y no complejos como si fuese un espectro