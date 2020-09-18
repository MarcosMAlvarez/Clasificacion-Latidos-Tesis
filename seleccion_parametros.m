bestac = 0;
i=1;
j=1;
clear gm && ac && cdm && cv && best_nu && best_gama && map_ac
accuracy=0;

%data_train=load('123_200.txt');
%clas_train=ones(length(data_train(:,1)),1);
%data_test=load('123_dt.txt');
%clas_test=load('123_ct.txt');

%for nu = 0.001:0.5/100:0.5
%  for gama = 0.001:0.5/100:0.5
%    
%    cmd = ['-s 2 -t 2 -n ' num2str(nu) ' -g ' num2str(gama) ' -e 0.001'];
%    cv = svmtrain(clas_train,data_train, cmd);
%    [predict_label, accuracy, dec_values] = svmpredict(clas_train,data_train, cv);
%    
%   if (accuracy(1) >= bestac),
%     bestac = accuracy(1); 
%     best_nu = nu; 
%     best_gama = gama;
%   end
    
%    gm(j)=gama;
%    ac(i,j)=accuracy(1);
%    map_ac(i,j)=accuracy(1);
%    j=j+1;
%  end
   
%   i=i+1;
%   j=1;
%end

%fprintf('(best nu=%g, best gama=%g, accuracy=%g)\n', best_nu, best_gama, bestac);

    %cmd = ['-s 2 -t 2 -n ' num2str(best_nu) ' -g ' num2str(best_gama) ' -e 0.001'];
    cmd = ['-s 2 -t 2 -n 0.1 -g 0.3 -e 0.001'];
    cv = svmtrain(clas_train,data_train, cmd);
    [predict_label, accuracy, dec_values] = svmpredict(clas_test,data_test, cv);
    
    dlmwrite('100_pd.txt',predict_label,'delimiter', '\t');
    
    
    
    