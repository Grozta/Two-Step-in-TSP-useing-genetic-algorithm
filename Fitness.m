function [Fitness]=Fitness(x,Fixedcosts,nuitTransCost,coldRate,congesteRate,goodLossRate,openDoorCost,openDoorCostRate,step,flag)

global D Startdistance Time Demand DemandMax v Matrix ServiceTime Cost

if nargin<2
    flag = 0;
end
%% ��Ϣ����Matrix

n=size(D,1);
Matrix=zeros(13,n);
Matrix(1,:)=x;
% n=length(x);
for i=1:n
    Matrix(6,i)=Time(x(i),1);%�����ж�ӦĿǰ����ɽ���Ӧ�õ���ʱ��
    Matrix(7,i)=Time(x(i),2);%�����ж�ӦĿǰ����ɽ��ܵ���ʱ��
    Matrix(8,i)=ServiceTime(x(i));%��ʮ�д洢����ʱ��
end
for i=1:n
    %��һ���ص��ɵ�һ��������Ȼ��ʼ��1�ų������������
    if i==1
        Matrix(2,i)=1;%�ڶ��д洢��ӦĿǰ���ͳ���
        Matrix(3,i)=Demand(x(i));%�����д洢��ӦĿǰ�ػ���
        Matrix(4,i)=Matrix(6,i)-Startdistance(x(i))/v;%�����ж�ӦĿǰ��������ʱ��
        Matrix(5,i)=Matrix(6,i);%�����ж�ӦĿǰ����ʱ��
        Matrix(9,i)=0;%��9�д洢�絽ʱ�䡣
        Matrix(10,i)=0;%��10�д洢��ʱ�䡣
        Matrix(11,i)=Matrix(5,i)+ Matrix(8,i);%��11�д洢����ʱ��
        Matrix(12,i)=Startdistance(x(i));%��12�г�������·�̡�
        Matrix(13,i)=Startdistance(x(i))/v;%��13�г������˶�ʱ��
    else
        if Matrix(3,i-1)+Demand(x(i))<=DemandMax   %�ж�����
            %���㣬������ʹ�øó�������
            Matrix(2,i)=Matrix(2,i-1);%�ڶ��д洢��ӦĿǰ���ͳ���
            Matrix(3,i)=Matrix(3,i-1)+Demand(x(i));%�����д洢��ӦĿǰ�ػ���
            Matrix(4,i)=Matrix(11,i-1);%�����ж�ӦĿǰ��������ʱ��
            Matrix(5,i)=Matrix(4,i)+D(x(i-1),x(i))/v;%�����ж�ӦĿǰ����ʱ��
            Matrix(9,i)=max(0,Matrix(6,i)-Matrix(5,i));%��9�д洢�絽ʱ��
            Matrix(10,i)=max(0,Matrix(5,i)-Matrix(7,i));%��10�д洢��ʱ��
            Matrix(11,i)=Matrix(5,i)+ Matrix(8,i);%��11�д洢����ʱ��
            Matrix(12,i)=Matrix(12,i-1)+D(x(i-1),x(i));%��12�г�������·�̡�
            Matrix(13,i)=Matrix(13,i-1)+Matrix(5,i)-Matrix(4,i);%��13�г������˶�ʱ��
        else
            %�����㣬�����³�
            Matrix(2,i)=Matrix(2,i-1)+1;%�ڶ��д洢��ӦĿǰ���ͳ���
            Matrix(3,i)=Demand(x(i));%�����д洢��ӦĿǰ�ػ���
            Matrix(4,i)=Matrix(8,i)-Startdistance(x(i))/v;%�����ж�ӦĿǰ��������ʱ��
            Matrix(5,i)=Matrix(8,i);%�����ж�ӦĿǰ����ʱ��
            Matrix(9,i)=0;%��9�д洢�絽ʱ�䡣
            Matrix(10,i)=0;%��10�д洢��ʱ�䡣
            Matrix(11,i)=Matrix(5,i)+ Matrix(8,i);%��11�д洢����ʱ��
            Matrix(12,i)=Startdistance(x(i));%��12�г�������·�̡�
            Matrix(13,i)=Startdistance(x(i))/v;%��13�г������˶�ʱ��
        end
    end
end
%% Ŀ�꺯��
% ��1�������̶��ɱ�
% �̶��ɱ�150Ԫ
f=Fixedcosts;
S=max(Matrix(2,:));
Fguding=f*S;
%��2������ɱ�

% e=100;  % ����豸ƽ�����ʣ�100kw
% Cf=1.2;%Cf:��λ�����ܺĳɱ�5Ԫÿ����
h=nuitTransCost;% ��λ����ɱ���15Ԫ/����
Dist=0;
Q=zeros(1,n);
for i=1:S
    A=find(Matrix(2,:)==i);
    Dist=Dist+Startdistance(x(A(end)))+Matrix(12,A(end));
    Q(A)=Matrix(3,A(end));
end
Fyunshu=h*Dist;

%��3������ɱ�
b=coldRate;%��������ϵ��

% Fzhileng=e*Cf*Dist/v;
% Lij:·�εľ���
% rij ӵ��ϵ��
Fzhileng=0;
rij=congesteRate;
if step == 0
    for i=1:n
        if i==1
            Fzhileng=Fzhileng+b*Startdistance(x(i))/(v*(rij-1));
        else
            Fzhileng=Fzhileng+b*D(x(i-1),x(i))/(v*(rij-1));
        end
    end
else
    Fzhileng = 5*(n-1);
end
for i=1:n
    if i==1
        Fzhileng=Fzhileng+b*Startdistance(x(i))/(v*(rij-1));
    else
        Fzhileng=Fzhileng+b*D(x(i-1),x(i))/(v*(rij-1));
    end
end
% ��4������ɱ�
q=goodLossRate; %����ɱ�ϵ��
Fhuosun=0;
for i=1:n
    if i==1
        Fhuosun=Fhuosun+q*Startdistance(x(i))/(v*(rij-1));
    else
        Fhuosun=Fhuosun+q*D(x(i-1),x(i))/(v*(rij-1));
    end
end
% ��5���ͷ��ɱ�
[xl,si] =size(x); 
n=si;%��ʾ�Ӳ�������
w1=20;%�絽�ĳͷ��ɱ� 10Ԫ/Сʱ
w2=30;%���ĳͷ��ɱ� 12Ԫ/Сʱ
% �����ͷ�����FF
FF=zeros(2,n);
FF(1,:)=w1*Matrix(9,:);
FF(2,:)=w2*Matrix(10,:);
Fchengfa=sum(sum(FF))/60;
a=openDoorCost;%һ�δ򿪳����ź�ж������������ɱ�
p=openDoorCostRate;%��ʾ�����ſ�����ж����ɵĻ�����
Fitness=Fguding+Fyunshu+Fhuosun+Fzhileng+Fchengfa+a*n+p*n;
if flag
    Cost = [Fguding,Fyunshu,Fhuosun+p*n,Fzhileng+a*n,Fchengfa];
end
end


