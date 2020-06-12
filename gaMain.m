function [totalIn,disTribtePoint]=gaMain(Fixedcosts,nuitTransCost,coldRate,congesteRate,goodLossRate,start,openDoorCost,openDoorCostRate,MaxDistributeRidus,veichleSpeed,veichleMaxW,Popsize,Iteration,Pc,Pm,pos,demandArr,timeWindows,server,step,posInfo)
%% 实数编码遗传算法代码 

global  Startdistance D Demand Time ServiceTime v DemandMax Matrix Cost
%% 算法参数设置


v= veichleSpeed;

DemandMax = veichleMaxW;

X = pos;

Xstart = start;

Demand = demandArr;

Time = timeWindows;


ServiceTime = server;

endDist = MaxDistributeRidus;

if step == 0
    [X,q,outPutNew,totalIn] = selectRealPoint(X ,endDist);  %选出初次经过的点
    [disTribtePoint,~] = size(q);
    [Demand,Time,ServiceTime] = dealAdd(Demand,Time,ServiceTime,q,outPutNew);
    oneRow = [1:disTribtePoint]';
    posInfo = [q oneRow];
else
    [disTribtePoint,~] = size(X);
    totalIn = [];
    
    
end



% 
Startdistance=calculate_Startdistance(Xstart,X);    %计算出发点到各个点之间的距离
D=calculateD(X);                                    %计算各个目的地之间的距离

%% 染色体种群初始化 

Dimension=size(D,1);
Solution=zeros(Popsize,Dimension);                  %Solution存储染色体种群的所有信息
for i=1:Popsize
    Solution(i,:)=randperm(Dimension);
end

%------------更新每个染色体的函数值------------
FitnessValue=zeros(Popsize,1);
for i=1:Popsize
    FitnessValue(i,1)=Fitness(Solution(i,:),Fixedcosts,nuitTransCost,coldRate,congesteRate,goodLossRate,openDoorCost,openDoorCostRate,step,0);
end

%------------找出染色体种群最优染色体的位置以及具体值------------
[Gbest,column]=min(FitnessValue);
% rr=find(FitnessValue==Gbest);                        %找到FitnessValue==Gbest所在矩阵中的位置
BestChrom=Solution(column,:);

%% 迭代更新
MaxIterFuncValue=zeros(1,Iteration);
Solution_sel=zeros(Popsize,Dimension);
for k=1:Iteration
    
%     %显示算法迭代进程
%     disp('----------------------------------------------------------')
%     TempStr=sprintf('第 %g 次迭代',k);                                  
%     disp(TempStr);
%     disp('----------------------------------------------------------')
%     
%     %------------使用锦标赛法进行选择操作------------
    for i=1:Popsize
        nn=randperm(Popsize,2);
        n1=nn(1);n2=nn(2);
        if FitnessValue(n1)>FitnessValue(n2)
            Solution_sel(i,:)=Solution(n2,:);
        else
            Solution_sel(i,:)=Solution(n1,:);
        end
    end
    
    %------------执行交叉操作------------
    % 从在锦标赛中胜出的染色体中选择待交叉染色体
    nnper=randperm(Popsize);
    A=Solution_sel(nnper(1),:);
    B=Solution_sel(nnper(2),:);
    for i=1:nn*Pc
        [A,B]=intercross(A,B);
        Solution_sel(nnper(1),:)=A;
        Solution_sel(nnper(2),:)=B;
    end
    %%%变异操作%%%
    for i=1:nn
        pick=rand;
        while pick==0
            pick=rand;
        end
        if pick<=Pm
            Solution_sel(i,:)=Mutation(Solution_sel(i,:));
        end
    end
    %%%求适应度函数%%%
    
    Solution=Solution_sel;
    
    for i=1:Popsize
        FitnessValue(i,1)=Fitness(Solution(i,:),Fixedcosts,nuitTransCost,coldRate,congesteRate,goodLossRate,openDoorCost,openDoorCostRate,step,1);
    end
    
    [IterValue,column]=min(FitnessValue);
    if IterValue<= Gbest
        BestChrom=Solution(column,:);
        Gbest=IterValue;
    end
    MaxIterFuncValue(1,k)=Gbest;
end

%% 结果输出
disp('----------------------------------------------------------')
TempStr=sprintf('第 %d 阶段',step);                                  
disp(TempStr);
% disp('最短配送路径：');
% disp(BestChrom);
fprintf('最低成本：%0.2f\n', Gbest);
[fitness] = Fitness(BestChrom,Fixedcosts,nuitTransCost,coldRate,congesteRate,goodLossRate,openDoorCost,openDoorCostRate,step, 1);
fprintf('车辆固定成本：%.2f\n运输成本：%.2f\n货损成本：%.2f\n制冷成本：%.2f\n惩罚成本：%.2f\n', Cost(1),Cost(2),Cost(3),Cost(4),Cost(5))
if step == 0
    disp(['起点坐标是[',num2str(Xstart(1)),',',num2str(Xstart(2)),']，标记为0']);
else
    load('distributePos','distributePos');
    disp(['起点坐标是[',num2str(distributePos(step,1)),',',num2str(distributePos(step,2)),']，标记为0','；在全部坐标中，标号为->',num2str(distributePos(step,4))]);
end    
disp('最短配送路径：');
figure(step+1);
plot(MaxIterFuncValue);
xlabel('迭代次数'); ylabel('目标函数值');title('最优解收敛曲线图');

%% 绘图
 Num=max(Matrix(2,:));
XX=BestChrom+1;
way=[1];
DDDD=cell(Num,1);
for i=1:Num
    A=find(Matrix(2,:)==i);
    way=[way  XX(A) 1];
    DDDD{i,1}=[0 BestChrom(A) 0];
    manzailv(1,i)=Matrix(3,A(end))/DemandMax;
end

% X=[Xstart;X];
DrawPath(way,X,Xstart,step,posInfo);
for i=1:Num
    p=OutputPath(DDDD{i,1},posInfo,Xstart);
end

disp('每辆车的满载率为')
disp(manzailv)

end