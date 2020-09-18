%% toma las primeras 200 muestras para el entrenamiento

clear xica

%eliminamos los elementos NaN
simout(isnan(simout))=[];
RRaa(isnan(RRaa))=[];

%separamos los latidos
k=1;
pico=-10;
muestras=zeros(200,201);

for j=1:200
    for i=k:k+200
        if simout(i)>pico
        pico=simout(i);
        pos=i;
        end
    end
    muestras(j,:)=simout(pos-100:pos+100);
    k=k+200;
    pico=-10;
end

xica=muestras(2:136,:);
Raa=RRaa(1:200);

for i=1:135, plot(xica(i,:)), hold on, end

%% aplicacion de ICA 

%numeros de IC a considerar
nic=5;

%corre la libreria fastica reduciendo la dimensión de xica a 5 (lasEig)
%y tomando nic componentes independientes
[IC_fastica] = fastica(xica(1:135,:), 'lastEig', 5, 'numOfIC', nic);


clear A_actual && A_norm && invIC && data_train && clas_train


%obtengo la invIC para poder calcular A 
invIC=transpose(IC_fastica)*inv(IC_fastica*transpose(IC_fastica));


%saco la matriz A media 
nm=10;

matrizA=zeros(nm,nic);
A_media=zeros(1,nic);


for i=1:nm
    matrizA(i,:)=xica(i,:)*invIC;
end
for i=1:nic
    A_media(i)=mean(matrizA(:,i));
end


%Se extrae los pesos de A para cada latido nuevo luego de centrar la señal
%dsp se dividen los pesos por A media para tener las caracteristicas
A_actual=zeros(200,5);
A_norm=zeros(200,5);

for i=1:length(muestras(:,1))
    lat_cen=muestras(i,:)-mean(muestras(i,:));
    
    A_actual(i,:)=muestras(i,:)*invIC;
   
    A_norm(i,1:nic)=A_actual(i,:)./A_media;
end    

%creo las matrices de entrenamiento de SVM
data_train=[A_norm Raa]; % Racp(10:209)' Ranp(10:209)'];
clas_train=ones(length(data_train(:,1)),1);

%% entrenamiento SVM

%se utilizan los siguientes parametros
%tipo de svm (-s) - SVM de una clase(2)
%tipo de nucleo (-t) - RBF
%nu=0.1, gamma=0.3, epsilon=0.001
    cmd = ['-s 2 -t 2 -n 0.1 -g 0.3 -e 0.001'];
 
%se entrena la red y se extrae el modelo
    modelo = svmtrain(clas_train,data_train, cmd);
    
%extraemos los vectores de soporte para la clasificacion    
    sv=full(modelo.SVs);
    sv_coef = modelo.sv_coef; 
    rho=modelo.rho;
    










