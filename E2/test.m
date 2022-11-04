clear;
tic;
%-------------------CONSTRUCCION DE MENSAJE------------------------
Ns=1000000; %número de bits
msg=randsrc(1,Ns,[0 1]); %genera los bits a transmitir
salida=cdmamod(msg);
