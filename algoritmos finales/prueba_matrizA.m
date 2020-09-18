

%numeros de IC a considerar
nic=5;

%corre la libreria fastica reduciendo la dimensión de xica a 5 (lasEig)
%y tomando nic componentes independientes
[IC_fastica] = fastica(xica, 'lastEig', 5, 'numOfIC', nic);


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
for i=1:length(cont)
    lat_cen=lat_f(i,:)-mean(lat_f(i,:));
    
    A_actual(i,:)=lat_f(i,:)*invIC;
   
    A_norm(i,1:nic)=A_actual(i,:)./A_media;
end    


data_train=[A_norm(10:209,:) Raa(10:209)' Racp(10:209)' Ranp(10:209)'];
%data_train=[A_norm(10:144,:) Raa(10:144)' Racp(10:144)' Ranp(10:144)'];
clas_train=ones(length(data_train(:,1)),1);
%115..
%data_test=[A_norm(10:1951,:) Raa(10:1951)' Racp(10:1951)' Ranp(10:1951)'];
%101.. 
%data_test=[A_norm(10:1858,:) Raa(10:1858)' Racp(10:1858)' Ranp(10:1858)'];
%205.. 
%data_test=[A_norm(10:2642,:) Raa(10:2642)' Racp(10:2642)' Ranp(10:2642)'];
%123.. 
data_test=[A_norm(10:1514,:) Raa(10:1514)' Racp(10:1514)' Ranp(10:1514)'];
clas_test=ones(length(data_test(:,1)),1);

seleccion_parametros

%dlmwrite('data_test.txt',[A_norm Raa' Racp' Ranp' ubicacion' cont'],'delimiter', '\t');


