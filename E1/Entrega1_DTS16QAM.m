%% 
%% Sistema de telecomunicaciones digitales (16QAM Mod/Demod) - Laboratorio de sistemas de telecomunicaciones 2
% *Universidad del Cauca - 2022-2*
% 
% *Entrega 1*
% 
% *Grupo 6 - Nicolás Zambrano y Sandy Suarez*
%% Codificador

%------------------------------INICIO--------------------------------
clear;
tic;
for ind=1:1:100
%-------------------CONSTRUCCION DE MENSAJE------------------------
Ns=100000; %número de bits
M=16; %orden de la modulación
Es=1; %este valor depende de la constelación
%vector de símbolos que entra al filtro conformador
msg=randsrc(1,Ns,[0 1]); %genera los bits a transmitir
%--------CONSTRUCCION DE LOS SIMBOLOS------------
for i=1:4:length(msg)
    if msg(i)==0 && msg(i+1)==0 && msg(i+2)==0 && msg(i+3)==0
        simboloqam((i+3)/4)=0;
    elseif msg(i)==0 && msg(i+1)==0 && msg(i+2)==0 && msg(i+3)==1
        simboloqam((i+3)/4)=1;
    elseif msg(i)==0 && msg(i+1)==0 && msg(i+2)==1 && msg(i+3)==0
        simboloqam((i+3)/4)=2;
    elseif msg(i)==0 && msg(i+1)==0 && msg(i+2)==1 && msg(i+3)==1
        simboloqam((i+3)/4)=3;
    elseif msg(i)==0 && msg(i+1)==1 && msg(i+2)==0 && msg(i+3)==0
        simboloqam((i+3)/4)=4;
    elseif msg(i)==0 && msg(i+1)==1 && msg(i+2)==0 && msg(i+3)==1
        simboloqam((i+3)/4)=5;
    elseif msg(i)==0 && msg(i+1)==1 && msg(i+2)==1 && msg(i+3)==0
        simboloqam((i+3)/4)=6;
    elseif msg(i)==0 && msg(i+1)==1 && msg(i+2)==1 && msg(i+3)==1
        simboloqam((i+3)/4)=7;
    elseif msg(i)==1 && msg(i+1)==0 && msg(i+2)==0 && msg(i+3)==0
        simboloqam((i+3)/4)=8;
    elseif msg(i)==1 && msg(i+1)==0 && msg(i+2)==0 && msg(i+3)==1
        simboloqam((i+3)/4)=9;
    elseif msg(i)==1 && msg(i+1)==0 && msg(i+2)==1 && msg(i+3)==0
        simboloqam((i+3)/4)=10;
    elseif msg(i)==1 && msg(i+1)==0 && msg(i+2)==1 && msg(i+3)==1
        simboloqam((i+3)/4)=11;
    elseif msg(i)==1 && msg(i+1)==1 && msg(i+2)==0 && msg(i+3)==0
        simboloqam((i+3)/4)=12;
    elseif msg(i)==1 && msg(i+1)==1 && msg(i+2)==0 && msg(i+3)==1
        simboloqam((i+3)/4)=13;
    elseif msg(i)==1 && msg(i+1)==1 && msg(i+2)==1 && msg(i+3)==0
        simboloqam((i+3)/4)=14;
    elseif msg(i)==1 && msg(i+1)==1 && msg(i+2)==1 && msg(i+3)==1
        simboloqam((i+3)/4)=15;
    end
end
%-----------------MODULACION QAM----------------------
moduladaqam=[];
for i=1:1:length(simboloqam)
    switch simboloqam(i)
        case 0
            moduladaqam(i)=-3+3i;
        case 1
            moduladaqam(i)=-3+1i;
        case 2
            moduladaqam(i)=-3-3i;
        case 3
            moduladaqam(i)=-3-1i;
        case 4
            moduladaqam(i)=-1+3i;
        case 5
            moduladaqam(i)=-1+1i;
        case 6
            moduladaqam(i)=-1-3i;
        case 7
            moduladaqam(i)=-1-1i;
        case 8
            moduladaqam(i)=3+3i;
        case 9
            moduladaqam(i)=3+1i;
        case 10
            moduladaqam(i)=3-3i;
        case 11
            moduladaqam(i)=3-1i;
        case 12
            moduladaqam(i)=1+3i;
        case 13
            moduladaqam(i)=1+1i;
        case 14
            moduladaqam(i)=1-3i;
        case 15
            moduladaqam(i)=1-1i;
    end
end
s=moduladaqam;
%-----------------------------------------------------
%-----------FILTRO CONFORMADOR DE PULSO---------------
Ro=0.35 ; U=16; L=8; Tf=1;
h1 = rcosfir(Ro, L, U, Tf,'sqrt') ; %Funcion de transferencia del filtro

% upsample 
su1=upsample(s,U);
%Agregacion de ceros al final del vector para evitar recorte por transiente
su=[su1 zeros(1,2*L*U)];
%Filtro de transmision
x1=filter(h1,1,su);
moduladaqam=x1;
%-----------------------------------------------------
%---------------------RUIDO---------------------------
%varianza=0;
ebno=1*ind; %EbNo en veces
Es=10; %Energia promedio de la constelacion
varianza=Es/(2*log2(M)*ebno);%determina la varianza de ruido
%Z=sigma*randn(1,length(S1)); %forma para dimensionar correctamente el ruido que se introduce al sistema 
ruidoqam=moduladaqam+((sqrt(varianza/2))*(randn(1,length(moduladaqam))+j*randn(1,length(moduladaqam))));
%snr=1.9;%Cambia la snr de la señal y el ruido (es funcion de la varianza)
%ruidoqam=awgn(moduladaqam,snr);
x1=ruidoqam;
%----------------------------------------
%------------FILTRO CONFORMADOR DE PULSO (RECONSTRUCCION)---------------
%Filtro de recepcion
x1=filter(h1,1,x1);
x1=x1(2*L*U+1:end);%Recorte del vector
s1=downsample(x1, U);
%s1=round(s1);
ruidoqam=s1;
%figure,
%plot(x1)
%-----------------------------------------------------
%-----------DEMODULACION QAM--------------
%demodqam=qamdemod(ruidoqam,16);%Desicion QAM
demodqam=ruidoqam;
for i=1:1:length(demodqam)
    if real(demodqam(i))<=-2
        if imag(demodqam(i))<=-2
            funsimb(i)=2;
        elseif imag(demodqam(i))<=0
            funsimb(i)=3;
        elseif imag(demodqam(i))<=2
            funsimb(i)=1;
        else
            funsimb(i)=0;
        end
    elseif real(demodqam(i))<=0
        if imag(demodqam(i))<=-2
            funsimb(i)=6;
        elseif imag(demodqam(i))<=0
            funsimb(i)=7;
        elseif imag(demodqam(i))<=2
            funsimb(i)=5;
        else
            funsimb(i)=4;
        end
    elseif real(demodqam(i))<=2
        if imag(demodqam(i))<=-2
            funsimb(i)=14;
        elseif imag(demodqam(i))<=0
            funsimb(i)=15;
        elseif imag(demodqam(i))<=2
            funsimb(i)=13;
        else
            funsimb(i)=12;
        end
    else
        if imag(demodqam(i))<=-2
            funsimb(i)=10;
        elseif imag(demodqam(i))<=0
            funsimb(i)=11;
        elseif imag(demodqam(i))<=2
            funsimb(i)=9;
        else
            funsimb(i)=8;
        end
    end
end
demodqam=funsimb;
%-----------------------------------------------------
%-----------DECODIFICACION DE SIMBOLOS--------------
for i=1:1:length(demodqam)%Decodificacion Simbolos
    if demodqam(i)==0
        bitqam((4*i)-3)=0;
        bitqam((4*i)-2)=0;
        bitqam((4*i)-1)=0;
        bitqam(4*i)=0;
    elseif demodqam(i)==1
        bitqam((4*i)-3)=0;
        bitqam((4*i)-2)=0;
        bitqam((4*i)-1)=0;
        bitqam(4*i)=1;
    elseif demodqam(i)==2
        bitqam((4*i)-3)=0;
        bitqam((4*i)-2)=0;
        bitqam((4*i)-1)=1;
        bitqam(4*i)=0;
    elseif demodqam(i)==3
        bitqam((4*i)-3)=0;
        bitqam((4*i)-2)=0;
        bitqam((4*i)-1)=1;
        bitqam(4*i)=1;
    elseif demodqam(i)==4
        bitqam((4*i)-3)=0;
        bitqam((4*i)-2)=1;
        bitqam((4*i)-1)=0;
        bitqam(4*i)=0;
    elseif demodqam(i)==5
        bitqam((4*i)-3)=0;
        bitqam((4*i)-2)=1;
        bitqam((4*i)-1)=0;
        bitqam(4*i)=1;
    elseif demodqam(i)==6
        bitqam((4*i)-3)=0;
        bitqam((4*i)-2)=1;
        bitqam((4*i)-1)=1;
        bitqam(4*i)=0;
    elseif demodqam(i)==7
        bitqam((4*i)-3)=0;
        bitqam((4*i)-2)=1;
        bitqam((4*i)-1)=1;
        bitqam(4*i)=1;
    elseif demodqam(i)==8
        bitqam((4*i)-3)=1;
        bitqam((4*i)-2)=0;
        bitqam((4*i)-1)=0;
        bitqam(4*i)=0;
    elseif demodqam(i)==9
        bitqam((4*i)-3)=1;
        bitqam((4*i)-2)=0;
        bitqam((4*i)-1)=0;
        bitqam(4*i)=1;
    elseif demodqam(i)==10
        bitqam((4*i)-3)=1;
        bitqam((4*i)-2)=0;
        bitqam((4*i)-1)=1;
        bitqam(4*i)=0;
    elseif demodqam(i)==11
        bitqam((4*i)-3)=1;
        bitqam((4*i)-2)=0;
        bitqam((4*i)-1)=1;
        bitqam(4*i)=1;
    elseif demodqam(i)==12
        bitqam((4*i)-3)=1;
        bitqam((4*i)-2)=1;
        bitqam((4*i)-1)=0;
        bitqam(4*i)=0;
    elseif demodqam(i)==13
        bitqam((4*i)-3)=1;
        bitqam((4*i)-2)=1;
        bitqam((4*i)-1)=0;
        bitqam(4*i)=1;
    elseif demodqam(i)==14
        bitqam((4*i)-3)=1;
        bitqam((4*i)-2)=1;
        bitqam((4*i)-1)=1;
        bitqam(4*i)=0;
    elseif demodqam(i)==15
        bitqam((4*i)-3)=1;
        bitqam((4*i)-2)=1;
        bitqam((4*i)-1)=1;
        bitqam(4*i)=1;
    end
end



%bitqam(226)=[];%Remuevo el cero agregado para evitar considerar el ultimo digito como ruido o error
%bitqam=reshape(bitqam,[15 15]);%Ordeno el vector recibido (Ajustado para un mensaje de 15 caracteres)
%--------DECODIFICACION METODO BCH GF(2)--------------
%bitqamgf=gf(bitqam);
%[dec, errordec]=bchdec(bitqamgf,15,7);
%dec=dec.x %Extraigo la matriz mensaje del campo de Galois;
%--------DECODIFICACION METODO BCH PRIMITIVO (CICLICO)--------------
%tablasindrome=syndtable(matparidadbch); %Tabla de sindromes
%CIdec=decode(bitqam,15,7,'cyclic/binary',genpoly,tablasindrome); %Decodificacion
%--------RECONSTRUCCION DE MENSAJE-------
%dec=bi2de(CIdec,'left-msb');
%msgsalida=num2str(dec','%s')
%toc
%------------------GRAFICA DE ANALISIS---------------------
% tic;
% simboloerrado=0;
% for i=1:1:length(demodqam)
%     if demodqam(i)==simboloqam(i)
%         plot(real(ruidoqam(i)),imag(ruidoqam(i)),'b.');
%         hold on
%     else
%         plot(real(ruidoqam(i)),imag(ruidoqam(i)),'r*');
%         hold on
%         simboloerrado=simboloerrado+1;
%     end
% end
% hold off
% xlim([-5 5]),ylim([-5 5]),
% xlabel 'Fase', ylabel Cuadratura; %Graficacion de Resultados
% title('\bf Diagrama de Constelacion de la Transmision en 16-QAM');
% toc
%----------------DISTANCIA HAMMING CODIGO BCH---------------------
%tic;
ser=nnz(~(demodqam == simboloqam));
vser(ind)=ser;
ebnodb(ind)=10*log(ebno);
end


t=toc
vser=vser./(Ns.*log2(M))
semilogy(ebnodb,vser)

% Grafica de simbolos transmitidos (con ruido)
