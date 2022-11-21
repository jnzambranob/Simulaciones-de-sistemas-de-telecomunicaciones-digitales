%% 
%% Sistema de telecomunicaciones digitales (16QAM Mod/Demod) - Laboratorio de sistemas de telecomunicaciones 2
% *Universidad del Cauca - 2022-2*
% 
% *Entrega 2*
% 
% *Grupo 6 - Nicolás Zambrano y Sandy Suarez*
%% Codificador

%------------------------------INICIO--------------------------------
clear;
tic;
Ro=0.35 ; U=4; L=8; Tf=1;
h1 = rcosfir(Ro, L, U, Tf,'sqrt') ; %Funcion de transferencia del filtro conformador de pulsos
%-------------------CONSTRUCCION DE MENSAJE------------------------
Nb=100000; %número de bits
M=2; %orden de la modulación
Es=8*8; %Energia promedio de la constelacion
wal=8;
Ns=Nb/log2(M);
R=4
%vector de símbolos que entra al filtro conformador
msg=randsrc(1,Nb,[0 1]); %genera los bits a transmitir
for ind=1:1:11 %Ciclo iterativo para construir grafica de rendimiento

%--------CONSTRUCCION DE LOS SIMBOLOS------------
simbolopsk=msg;
%-----------------MODULACION QAM----------------------
moduladapsk=pskmod(simbolopsk,M);
so=real(moduladapsk);
%-----------------------------------------------------
%---------------------CDMA-----------------------
%%Codificacion de vectores CDMA
s=cdmamod(so);
%tests=cdmademod(s);
%-----------------------------------------------------
%-----------FILTRO CONFORMADOR DE PULSO---------------
% upsample 
su1=upsample(s,U);
%Agregacion de ceros al final del vector para evitar recorte por transiente
su=[su1 zeros(1,2*L*U)];
%Filtro de transmision
x1=filter(h1,1,su);
%x1bkp=x1;
%-----------------------------------------------------
%---------------------MODULACION EN PORTADORA---------------------------
fs = U*R;
T = 1/R;
ts = 1/fs;
fc=(1/4)*(fs); %Para cumplir nyquist
t = 0 : ts : (Ns*T-ts)+R;
tc = t./wal;
portadorapsk = sqrt(2)*(x1.*cos(2*pi*fc.*t)-imag(x1).*sin(2*pi*fc.*t)); % Traslacion en frecuencia
ppsk = portadorapsk;
%-----------------------------------------------------
%---------------------RUIDO---------------------------
%varianza=0;
ebno=1*ind; %EbNo en veces
varianza=Es/(2*log2(M)*ebno);%determina la varianza de ruido
%Z=sigma*randn(1,length(S1)); %forma para dimensionar correctamente el ruido que se introduce al sistema 
ruidopsk=portadorapsk+sqrt(varianza)*randn(1,length(portadorapsk));
%snr=1.9;%Cambia la snr de la señal y el ruido (es funcion de la varianza)
%ruidoqam=awgn(moduladaqam,snr);
x1=ruidopsk;
x=x1;
xc=x1;
%x1bkp2=x;
%----------------------------------------
%-----------DEMODULACION EN PORTADORA----------------
Ts = 1/fs;
Y=x;
%t = 0 : Ts : Ts*(Ns-1);  
Y_real = sqrt(2)*Y.*cos(2*pi*fc.*t);    
Y_imag = -sqrt(2)*Y.*sin(2*pi*fc.*t);
%y = (Y_real + 1i*Y_imag);
y=real(Y_real);
x1=y;
%----------------------------------------
%------------FILTRO CONFORMADOR DE PULSO (FILTRO ACOPLADO)---------------
%Filtro de recepcion
x1=filter(h1,1,x1);
x1=x1(2*L*U+1:end);%Recorte del vector
s1=downsample(x1, U);
%s1=round(s1);
ruidopsk=s1;
%figure,
%plot(x1)
%-----------------------------------------------------

%------------------DECODIFICACION CDMA-----------------------
%%Deodificacion de vectores CDMA
ruidopsk=cdmademod(ruidopsk);
%-----------------------------------------------------
%-----------DEMODULACION QAM--------------
%demodqam=qamdemod(ruidoqam,16);%Desicion QAM
senalentrada=ruidopsk;
for i=1:1:length(senalentrada)
    if real(senalentrada(i))<=0
        funsimb(i)=1;
    elseif real(senalentrada(i))>0
        funsimb(i)=-1;
    end
end
demodpsk=funsimb;
%-----------------------------------------------------
%-----------DECODIFICACION DE SIMBOLOS--------------
for i=1:1:length(demodpsk)%Decodificacion Simbolos Gray
    if demodpsk(i)==-1
        bitpsk(i)=0;
    elseif demodpsk(i)==1
        bitpsk(i)=1;
    end
end
%------------------DETECCION DE ERRORES DE TRANSMISION----------------------
ser=nnz(~(bitpsk == simbolopsk));
vser(ind)=ser;
%teober(ind)=((3/8)*erfc(sqrt((4/10)*ebno)));
teober(ind)=((1/2)*erfc(sqrt(ebno)));
ebnodb(ind)=10*log10(ebno);
end
tiemposimulacion=toc
vber=(vser./(Ns))*(1/log2(M));%BER(casi igual a)SER debido a codificacion gray
%-----------------------GRAFICA DE RENDIMIENTO-----------------------
semilogy(ebnodb,vber)
close all; figure
semilogy(ebnodb,teober,'bs-','LineWidth',1);
hold on
semilogy(ebnodb,vber,'mx-','LineWidth',1);
axis([0 15 10^-6 1])
grid off
legend('Teorica', 'Simulada');
xlabel('Eb/No, dB')
ylabel('Tasa de error de BIT')
title('Curvas de rendimiento para el DTS asignado')
%--------------------------------FIN----------------------------------