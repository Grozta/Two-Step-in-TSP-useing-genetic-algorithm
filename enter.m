clc
clear
close all

Fixedcosts = 150;                   %�̶��ɱ�
nuitTransCost =2.4;                 %��λ����ɱ�
coldRate=1.3;                       %������
congesteRate=1.5;                   %ӵ����
goodLossRate = 0.39;                %������
openDoorCost = 30;                  %һ�ο��ŷ���
openDoorCostRate = 0.26;            %���ŷ���
MaxDistributeRidus = 15;            %�����Ͱ뾶
veichleSpeed = 60;                  %�����ٶ�
veichleMaxW = 200;                  %�������װ����
Popsize=500;                        %Ⱦɫ������
Iteration=100;                      %��������
Pc=0.75;                            %������ 0-1֮��
Pm=0.7;                             %������ 0-1֮��
step = 0;                           % ��ʼ���׶�
start = [40 50];                    %���ĵ�����
pos =load('����.txt');
demandArr = load('������.txt');
timeWindows = load('ʱ�䴰.txt');
server = load('ж��ʱ��.txt');
posInfo = [];
[totalIn,disTribtePoint] = gaMain(Fixedcosts,nuitTransCost,coldRate,congesteRate,goodLossRate,start,openDoorCost,openDoorCostRate,MaxDistributeRidus,veichleSpeed,veichleMaxW,Popsize,Iteration,Pc,Pm,pos,demandArr,timeWindows,server,step,posInfo);
[totalIn,~]=sortrows(totalIn,3);
op = 1;
    while totalIn(op,3)<0
        totalIn(op,3) = totalIn(op,3)*(-1);
        op = op +1;
    end
[totalIn,I]=sortrows(totalIn,3);
inPutNew = totalIn;
distributePos = [];
for n=1:max(inPutNew(:,3))
    distributePos = [distributePos ;inPutNew(find(inPutNew(:,3) == n,1),:)];
end
save('distributePos','distributePos');
[inSize,ii] = size(inPutNew);
jPos = 1;
save('jPos','jPos');
save('inSize','inSize');
save('inPutNew','inPutNew');
% for i =1:disTribtePoint -1
for i =1:disTribtePoint
    save('i','i');save('disTribtePoint','disTribtePoint');save('jPos','jPos');
    clear;
    load('jPos','jPos');load('inSize','inSize');load('inPutNew','inPutNew');load('i','i');load('disTribtePoint','disTribtePoint');
    step = i;
    ho = 0;
    for j = jPos:inSize
        if inPutNew(j,3) == i
            ho = ho +1;
        end
    end
    jPos = jPos + ho;
    realIn = inPutNew(jPos-ho:(jPos-1),:);
Fixedcosts = 80;                   %�̶��ɱ�
nuitTransCost =1;                  %��λ����ɱ�
coldRate=0;                        %������
congesteRate=0;                    %ӵ����
goodLossRate = 0.5;                %������
openDoorCost = 0;                  %һ�ο��ŷ���
openDoorCostRate = 0;              %���ŷ���
MaxDistributeRidus = 9999;         %������Ͱ뾶
veichleSpeed = 25;                 %�����ٶ�
veichleMaxW = 70;                  %�������װ����
Popsize=100;                       %Ⱦɫ������
Iteration=100;                     %��������
Pc=0.75;                           %������ 0-1֮��
Pm=0.7;                            %������ 0-1֮��
demandArr = load('������.txt');
timeWindows = load('ʱ�䴰.txt');
server = load('ж��ʱ��.txt');
[demandArr,timeWindows,server] = dealExat(demandArr,timeWindows,server,realIn);
[realInSize,~] =  size(realIn);
oneRowp = [1:realInSize-1]';
realInp = [realIn(2:end,:) oneRowp];
posInfo = realInp(:,4:5);

pos =realIn(:,1:2);
start = pos(1, :);
pos(1,:) = [];
gaMain(Fixedcosts,nuitTransCost,coldRate,congesteRate,goodLossRate,start,openDoorCost,openDoorCostRate,MaxDistributeRidus,veichleSpeed,veichleMaxW,Popsize,Iteration,Pc,Pm,pos,demandArr,timeWindows,server,step,posInfo);
end