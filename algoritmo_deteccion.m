%
%Algoritmo de Pan-Tompkinson
%

%Toma los datos de la base de datos y lo trabaja para 
%mostrarlo correctamente
 x=val(1,:);
 x=x-1024;
 x=x./200;

 
 
%
Fs=360;
%
Y=zeros(1,length(x));
UMBRAL1=Y;
UMBRAL2=Y;
UMBRALR=Y;
PEAK=Y;
PEAKM=Y;
Ypb=Y;
Ypa=Y;
Yd=Y;
Ymw=Y;
W=Y;
nu_latidos=0;
r=0;
%filtro pasa-bajo
%aplicando el filtro en forma directa 2
%la frecuencia de cutoff es de aprox. 11 Hz y la ganancia 36. 
%retrasa 5 muestras
for i=15:length(x) 
    W(i)=x(i)+2*W(i-1)-W(i-2);
end
clear i
for i=15:length(x) 
    %Ypb(i)=(W(i)-2*W(i-6)+W(i-12))/32;
    Ypb(i)=(W(i)-2*W(i-7)+W(i-14))/49;
end
clear i


%filtro pasa-alto
%la frecuencia de cutoff es de aprox. 5 Hz y la ganancia 1.216 
%retrasa 15.5 muestras

%for i=49:length(x)
%    %Ypa(i)=Ypa(i-1)-Ypb(i)/32+Ypb(i-15)-Ypb(i-16)+Ypb(i-32)/32;
%    Ypa(i)=Ypa(i-1)-Ypb(i)/48+Ypb(i-24)-Ypb(i-25)+Ypb(i-48)/48;
%end

for i=15:length(x) 
    W(i)=Ypb(i)+W(i-1);
end
clear i
for i=49:length(x) 
    %Ypb(i)=(W(i)-2*W(i-6)+W(i-12))/32;
    Ypa(i)=(-W(i)+48*W(i-24)-48*W(i-25)+W(i-48))/48;
end
clear i

%ecuacion derivador de 5 puntos
%rta casi lineal entre dc y 30 Hz con retraso de 2 muestras
for i=5:length(x)
    Yd(i)=(2*Ypa(i)+Ypa(i-1)-Ypa(i-3)-2*Ypa(i-4))/8;
end
clear i

%funcion "cuadradora"
%se eleva la señal al cuadrado pto a pto
Yc=Yd.^2;

%Integracion moving-window
%N=64 -> 177ms para Fs=360Hz para dividir por una potencia de dos
%N=22 -> 177ms para Fs=128Hz para dividir por una potencia de dos
N=64;
for i=N:length(x)
    X=0;
    %Se resuelve el vector X=x(i-(N-1))+X(i-(N-2)+...+x(i))
    for m=(N-1):-1:0
        X=X+Yc(i-m);
    end
    %se divide por 1/N 
    Ymw(i)=X/N;
end
clear i & m 

%Deteccion del primer pico R
%se toma el primer segundo (360 muestras) y se busca el valor maximo
%se guarda en posicion la ubicacion de la muestra con el valor maximo
peak=0;
pos_peak=0;
for i=Fs:2*Fs
    if Ymw(i)>peak
        peak=Ymw(i);
    end
end
clear i & m

%Ajuste de los umbrales de deteccion
%SPKI es el estimado del pico de señal
%NPKI es el estimado del pico de ruido
%THRESHOLD1 es el primer umbral aplicado 
%THRESHOLD2 es el segundo umbral aplicado.
SPKI=peak/2;
SPKI=0.125*peak+0.875*SPKI;
NPKI=0;

THRESHOLD1=peak/4;
THRESHOLD2=0.5*THRESHOLD1;

%DETECCION DE R
regRv=zeros(1,200000);      %%hay que optimizar estos vectores
regRp=regRv;                %%
pulsos=regRv;               %este es solo de prueba    
RR=regRv;                   %%
bkRR=zeros(1,3);
bkpR=zeros(1,3);
i=Fs;
k=1;
z=1;
salto=0;
guardar=0;
l=8;
rrav1=zeros(1,8);
lat_x=zeros(3010,201);
lat_f=zeros(3010,201);
while i < length(x) 
        %busco la primer loma
         if z==1;   
            while Ymw(i) <= Ymw(i-1)
                  i=i+1;
                  UMBRAL1(i)=THRESHOLD1;
                  UMBRAL2(i)=THRESHOLD2;
                  if i==length(x)
                      break
                  end
            end
            peak=Ymw(i);
            pos_peak=i;
            z=0;
         end
                                                                               
                                              
    %Busqueda hacia adelante
    %tiene que superar el umbral en la señal filtrada como en la derivada
    if Ymw(i)<(peak/2) 
        
       if (peak>THRESHOLD1) 
             
                                                                            PEAK(pos_peak)=1;
            %actualiacion del umbral adaptativo (debido a la señal)
            SPKI=0.125*peak+0.875*SPKI;
            
            %guardamos la ubicacion de Ymw(i) para la busqueda hacia atras
            %bk vector(1,2) donde los valores son (muestra actual, m anterior)
            bkRR(3)=bkRR(2);
            bkRR(2)=bkRR(1);
            bkRR(1)=pos_peak;
            
            %Buscamos el pico en la señal original  
            %(ventana de N m con delay de 25m)
            regRv(k)=-128;
            for j=(pos_peak-77):1:(pos_peak-13) 
                bus(j)=2;
                if (x(j)>regRv(k))
                    %guardamos en dos vectores la posicion y el valor del pico

                    regRp(k)=j;
                    regRv(k)=x(j);
                end
            end

                bkpR(3)=bkpR(2);
                bkpR(2)=bkpR(1);
                bkpR(1)=regRp(k);
                
            %Analizamos el intervalo RR
            %Se saca el promedio de los ultimos 8 intervalos (rrav1)
            %y el promedio de los ultimos 8 intervalos normales (rrav2)

            %se guarda el intervalo
            if k>1
                RR(k-1)=regRp(k)-regRp(k-1);
            end
            %se saca el primer promedio
            if (k>8)
                rrav1=[RR(k-1) RR(k-2) RR(k-3) RR(k-4),...
                      RR(k-5) RR(k-6) RR(k-7) RR(k-8)]; 
                RRav1=(sum(rrav1))/8;
            end
            %se saca el segundo promedio
            if (k==9)
                RRn=RR;
                RRav2=RRav1;
            elseif (k>9 && RR(k-1)>(0.92*RRav1) && RR(k-1)<(1.16*RRav1))
                RRn(l)=RR(k-1);
                rrav2=[RRn(l) RRn(l-1) RRn(l-2) RRn(l-3),...
                      RRn(l-4) RRn(l-5) RRn(l-6) RRn(l-7)];
                RRav2=(sum(rrav2))/8;
                l=l+1;
            end
            
            pulsos(regRp(k))=1;
            clear j
            
                                                                            
            salto=1;
            guardar=1;
            z=1;
            nu_latidos=nu_latidos+1;
            
       else
            
            %actualiacion del umbral adaptativo (debido al ruido)
            NPKI=0.125*peak+0.875*NPKI;
            z=1; 
                                                                            UMBRAL1(i)=THRESHOLD1;
                                                                            UMBRAL2(i)=THRESHOLD2;
        
       end
           
            %actualiacion del umbral adaptativo
            THRESHOLD1=NPKI+0.21*(SPKI-NPKI);
            THRESHOLD2=0.5*THRESHOLD1;

                        
            %se verifica si el pico se encontro entre el RR permitido
            %que es 1.66*RRav2
            if (k>9)
                if (RR(k-1)>(1.66*RRav2))
            %cuenta_sb=cuenta_sb+1;
           %%% se inicia la busqueda hacia atras %%%
            m=bkRR(2)+72+N/2;
            z=1;
            
                    while m<bkRR(1)-N
                        
                        %busco la primer loma
                                 if z==1;   
                                    while Ymw(m) <= Ymw(m-1)
                                          m=m+1;
                                          UMBRAL1(m)=THRESHOLD1;
                                          UMBRAL2(m)=THRESHOLD2;
                                          if m>=length(x)
                                              break
                                          end
                                    end
                                    peak=Ymw(m);
                                    pos_peak=m;
                                    z=0;
                                 end
                                 
                       if Ymw(m)<(peak/2)
                            
                            if (peak>THRESHOLD2)
                                
                                                                            PEAK(pos_peak)=1;
                                %actualiacion del umbral adaptativo (debido a la señal)
                                SPKI=0.25*peak+0.75*SPKI;
                                bkRR(1)=pos_peak;

                                %Buscamos el pico en la señal original  
                                %(ventana de 41m con delay de 25m)
                                regRv(k)=-128;
                                    for j=(pos_peak-77):1:(pos_peak-13)
                                        if (x(j)>regRv(k))
                                            %guardamos en dos vectores la posicion y el valor del pico
                                            regRp(k)=j;
                                            regRv(k)=x(j);

                                        end
                                    end

                                bkpR(1)=regRp(k);
                                
                                %acomodo i para el nuevo pico encontrado
                                %fuerzo el final de la busqueda ya que encontre
                                %i=m+72+N;
                                i=m;
                                salto=1;
                                guardar=1;
                                z=1;
                                
                                %k=k+1;
                                nu_latidos=nu_latidos+1;
                                
                                pulsos(regRp(k))=1;
                                clear j

                                                                
                                break
                                
                            else 
                                
                                %actualiacion del umbral adaptativo (debido al ruido)
                                NPKI=0.25*peak+0.75*NPKI;
                                z=1;
                                                                
                                
                            end
                            
                                %actualiacion del umbral adaptativo 
                                %dandole mas peso al ultimo pico

                                THRESHOLD1=NPKI+0.25*(SPKI-NPKI);
                                THRESHOLD2=0.5*THRESHOLD1;

                       elseif Ymw(m)>peak
        
                            peak=Ymw(m);
                            pos_peak=m;
                            
                       end
                       m=m+1; 
                    end
                    %%% fin busqueda hacia atras %%%

                end
            end

            
            
    elseif Ymw(i)>peak
        
        peak=Ymw(i);
        pos_peak=i;
    
    end
    
    %guardo el latido (int RR corrido 200ms(72muestras))
    if guardar==1 && bkRR(2)>73
        o=1;
        for j=bkpR(2)-100:1:bkpR(2)+100
            lat_x(k,o)=x(j);
            lat_f(k,o)=Ypa(j);
            o=o+1;
        end
        
        guardar=0;
        clear o
        
        %guardo los intervalos RR actual y anterior y promedio
        %y las relaciones act/ant, act/prom y ant/prom
        RRactual(k)=bkpR(1)-bkpR(2);
        RRanterior(k)=bkpR(2)-bkpR(3);
        if k>9
            RRpromedio(k)=RRav1;
                
        Raa(k)=RRactual(k)/RRanterior(k);
        Racp(k)=RRactual(k)/RRpromedio(k);
        Ranp(k)=RRanterior(k)/RRpromedio(k);
        
        end
        ubicacion(k)=bkpR(2);
        cont(k)=k;
    end
    
    %Salta 200ms donde no es posible encontrar QRS
    if salto==1
        k=k+1;
        i=i+72;
        salto=0;
    end
    
    i=i+1;

   UMBRAL1(i)=THRESHOLD1;
   UMBRAL2(i)=THRESHOLD2;
   UMBRALR(i)=NPKI;
   
    
   
end

dlmwrite('ubicacion.txt',[ubicacion' cont'],'delimiter', '\t');