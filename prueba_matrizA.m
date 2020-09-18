clear A_actual && A_norm && invIC

%obtengo la invIC para poder calcular A 
invIC=transpose(IC_fastica)*inv(IC_fastica*transpose(IC_fastica));

nm=10;
nic=5;
%saco la A media y el desvio std de los primeros 100 latidos
matrizA=zeros(nm,nic);
A_media=zeros(1,nic);
A_std=zeros(1,nic);
lsup=zeros(1,nic);
linf=zeros(1,nic);

 

for i=1:nm
    matrizA(i,:)=xica(i,:)*invIC;
end
for i=1:nic
    A_media(i)=mean(matrizA(:,i));
    A_std(i)=std(matrizA(:,i));
    %calculo los limites superior e inferior
    lsup(i)=A_media(i)+A_std(i);
    linf(i)=A_media(i)-A_std(i);
end


for i=1:length(cont)
    lat_cen=lat_f(i,:)-mean(lat_f(i,:));
    A_actual(i,:)=lat_f(i,:)*invIC;
    %for j=1:nic
    A_norm(i,1:nic)=A_actual(i,:)./A_media;
    %A_norm(i,j)=(A_actual(i,j)-A_media(j));
    %A_norm(i,j)=(A_actual(i,j)-A_media(j))^2;
    %end
end    


data_train=[A_norm(10:209,:) Raa(10:209)' Racp(10:209)' Ranp(10:209)'];
clas_train=ones(length(data_train(:,1)),1);
%115..
%data_test=[A_norm(10:1951,:) Raa(10:1951)' Racp(10:1951)' Ranp(10:1951)'];
%101.. 
%data_test=[A_norm(10:1858,:) Raa(10:1858)' Racp(10:1858)' Ranp(10:1858)'];
%205.. 
%data_test=[A_norm(10:2642,:) Raa(10:2642)' Racp(10:2642)' Ranp(10:2642)'];
%123.. 
data_test=[A_norm(10:1505,:) Raa(10:1505)' Racp(10:1505)' Ranp(10:1505)'];
clas_test=ones(length(data_test(:,1)),1);

seleccion_parametros

dlmwrite('data_test.txt',[A_norm Raa' Racp' Ranp'],'delimiter', '\t');


