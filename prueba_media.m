 
clas=zeros(2000,1);
w=zeros(1,5);
figure
clear i
for i=1:5
    w(i)=mean(W_fastica(i,:));
end
clear data && i
for i=2:100
    s=transpose(w)*lat_f(i,:);
    for j=1:5
        data(i,j)=mean(s(j,:));
        data(i,j+5)=median(s(j,:));
    end
end
clear i
for i=1:10
    media(i)=mean(data(:,i));
    desv(i)=std(data(:,i));
end
for i=2:2000
    s=transpose(w)*lat_f(i,:);
    data=mean(s(3,:));
    plot(data), hold on, plot(media(3),'o')
    plot(media(3)-desv(3),'.'), plot(media(3)+desv(3),'.')
    if (data < media(3)-desv(3)) || (data > media(3)+desv(3))
        clas(i,1)=1;
    end
end
dlmwrite('clas.txt',clas,'delimiter', '\t');
    