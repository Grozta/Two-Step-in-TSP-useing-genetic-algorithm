clc
clear
close all

Fixedcosts = 150;                   %固定成本
nuitTransCost =2.4;                 %单位运输成本
coldRate=1.3;                       %制冷率
congesteRate=1.5;                   %拥堵率
goodLossRate = 0.39;                %货损率
openDoorCost = 30;                  %一次开门费用
openDoorCostRate = 0.26;            %开门费率
MaxDistributeRidus = 15;            %最大费送半径
veichleSpeed = 60;                  %车辆速度
veichleMaxW = 200;                  %车辆最大装载量
Popsize=500;                        %染色体数量
Iteration=100;                      %迭代次数
Pc=0.75;                            %交叉率 0-1之间
Pm=0.7;                             %变异率 0-1之间
step = 0;                           % 初始化阶段
start = [40 50];                    %中心点坐标
pos =load('坐标.txt');
demandArr = load('需求量.txt');
timeWindows = load('时间窗.txt');
server = load('卸货时间.txt');
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
Fixedcosts = 80;                   %固定成本
nuitTransCost =1;                  %单位运输成本
coldRate=0;                        %制冷率
congesteRate=0;                    %拥堵率
goodLossRate = 0.5;                %货损率
openDoorCost = 0;                  %一次开门费用
openDoorCostRate = 0;              %开门费率
MaxDistributeRidus = 9999;         %最大配送半径
veichleSpeed = 25;                 %车辆速度
veichleMaxW = 70;                  %车辆最大装载量
Popsize=100;                       %染色体数量
Iteration=100;                     %迭代次数
Pc=0.75;                           %交叉率 0-1之间
Pm=0.7;                            %变异率 0-1之间
demandArr = load('需求量.txt');
timeWindows = load('时间窗.txt');
server = load('卸货时间.txt');
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