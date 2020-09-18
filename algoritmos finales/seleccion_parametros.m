bestac = 0;
i=1;
j=8;

k=10;

clear gm && ac && cdm && cv && best_nu && best_gama && data_t && clas_t
clear prediccion
accuracy=0;

%% Se busca el valor de nu y gamma optimos a traves de un barrido

%data_train=load('118_200.txt');
%clas_train=ones(length(data_train(:,1)),1);

%data_t=data_train(1:135,:);
%clas_t=ones(length(data_t(:,1)),1);

%data_test=load('118_dt.txt');
%clas_test=load('118_ct.txt');

%for nu = 0.001:0.5/20:0.5
  %for gama = 0.001:0.5/100:0.5
%    
%    cmd = ['-s 2 -t 2 -n ' num2str(nu) ' -g 0.3 -e 0.001'];
%    cv = svmtrain(clas_train,data_train, cmd);
%    [predict_label, accuracy, dec_values] = svmpredict(clas_train,data_train, cv);
%    
%   if (accuracy(1) >= bestac),
%     bestac = accuracy(1); 
%     best_nu = nu; 
%     best_gama = gama;
%   end
%   
%    gm(j)=gama;
%    ac(i,j)=accuracy(1);
%    map_ac(j,i)=accuracy(1);
%    %j=j+1;
%  %end
%   
%  prediccion(i,:)=predict_label;
%  lugar(i)=nu;
%   i=i+1;
%   %j=1;
%end

%for i=1:1:200
%    data_t=data_train(1:i,:);
%    clas_t=ones(length(data_t(:,1)),1);
%    
%    cmd = ['-s 2 -t 2 -n 0.1 -g 0.3 -e 0.001'];
%    cv = svmtrain(clas_t,data_t, cmd);
%    [predict_label, accuracy, dec_values] = svmpredict(clas_test,data_test, cv);
%    
%    preci(k,j)=accuracy(1);
%    j=j+1;
%    
%end

%fprintf('(best nu=%g, best gama=%g, accuracy=%g)\n', best_nu, best_gama, bestac);


%% Se corre la libreria SVM

%se utilizan los siguientes parametros
%tipo de svm (-s) - SVM de una clase(2)
%tipo de nucleo (-t) - RBF
%nu=0.1, gamma=0.3, epsilon=0.001
    cmd = ['-s 2 -t 2 -n 0.1 -g 0.3 -e 0.001'];
 
%se entrena la red y se extrae el modelo
    modelo = svmtrain(clas_train,data_train, cmd);
    
%Se clasifican los valores
    [predict_label, accuracy, dec_values] = svmpredict(clas_test,data_test, modelo);
    
    dlmwrite('118_pd.txt',predict_label,'delimiter', '\t');
    
    
    
    