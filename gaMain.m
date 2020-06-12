function [totalIn,disTribtePoint]=gaMain(Fixedcosts,nuitTransCost,coldRate,congesteRate,goodLossRate,start,openDoorCost,openDoorCostRate,MaxDistributeRidus,veichleSpeed,veichleMaxW,Popsize,Iteration,Pc,Pm,pos,demandArr,timeWindows,server,step,posInfo)
%% ʵ�������Ŵ��㷨���� 

global  Startdistance D Demand Time ServiceTime v DemandMax Matrix Cost
%% �㷨��������


v= veichleSpeed;

DemandMax = veichleMaxW;

X = pos;

Xstart = start;

Demand = demandArr;

Time = timeWindows;


ServiceTime = server;

endDist = MaxDistributeRidus;

if step == 0
    [X,q,outPutNew,totalIn] = selectRealPoint(X ,endDist);  %ѡ�����ξ����ĵ�
    [disTribtePoint,~] = size(q);
    [Demand,Time,ServiceTime] = dealAdd(Demand,Time,ServiceTime,q,outPutNew);
    oneRow = [1:disTribtePoint]';
    posInfo = [q oneRow];
else
    [disTribtePoint,~] = size(X);
    totalIn = [];
    
    
end



% 
Startdistance=calculate_Startdistance(Xstart,X);    %��������㵽������֮��ľ���
D=calculateD(X);                                    %�������Ŀ�ĵ�֮��ľ���

%% Ⱦɫ����Ⱥ��ʼ�� 

Dimension=size(D,1);
Solution=zeros(Popsize,Dimension);                  %Solution�洢Ⱦɫ����Ⱥ��������Ϣ
for i=1:Popsize
    Solution(i,:)=randperm(Dimension);
end

%------------����ÿ��Ⱦɫ��ĺ���ֵ------------
FitnessValue=zeros(Popsize,1);
for i=1:Popsize
    FitnessValue(i,1)=Fitness(Solution(i,:),Fixedcosts,nuitTransCost,coldRate,congesteRate,goodLossRate,openDoorCost,openDoorCostRate,step,0);
end

%------------�ҳ�Ⱦɫ����Ⱥ����Ⱦɫ���λ���Լ�����ֵ------------
[Gbest,column]=min(FitnessValue);
% rr=find(FitnessValue==Gbest);                        %�ҵ�FitnessValue==Gbest���ھ����е�λ��
BestChrom=Solution(column,:);

%% ��������
MaxIterFuncValue=zeros(1,Iteration);
Solution_sel=zeros(Popsize,Dimension);
for k=1:Iteration
    
%     %��ʾ�㷨��������
%     disp('----------------------------------------------------------')
%     TempStr=sprintf('�� %g �ε���',k);                                  
%     disp(TempStr);
%     disp('----------------------------------------------------------')
%     
%     %------------ʹ�ý�����������ѡ�����------------
    for i=1:Popsize
        nn=randperm(Popsize,2);
        n1=nn(1);n2=nn(2);
        if FitnessValue(n1)>FitnessValue(n2)
            Solution_sel(i,:)=Solution(n2,:);
        else
            Solution_sel(i,:)=Solution(n1,:);
        end
    end
    
    %------------ִ�н������------------
    % ���ڽ�������ʤ����Ⱦɫ����ѡ�������Ⱦɫ��
    nnper=randperm(Popsize);
    A=Solution_sel(nnper(1),:);
    B=Solution_sel(nnper(2),:);
    for i=1:nn*Pc
        [A,B]=intercross(A,B);
        Solution_sel(nnper(1),:)=A;
        Solution_sel(nnper(2),:)=B;
    end
    %%%�������%%%
    for i=1:nn
        pick=rand;
        while pick==0
            pick=rand;
        end
        if pick<=Pm
            Solution_sel(i,:)=Mutation(Solution_sel(i,:));
        end
    end
    %%%����Ӧ�Ⱥ���%%%
    
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

%% ������
disp('----------------------------------------------------------')
TempStr=sprintf('�� %d �׶�',step);                                  
disp(TempStr);
% disp('�������·����');
% disp(BestChrom);
fprintf('��ͳɱ���%0.2f\n', Gbest);
[fitness] = Fitness(BestChrom,Fixedcosts,nuitTransCost,coldRate,congesteRate,goodLossRate,openDoorCost,openDoorCostRate,step, 1);
fprintf('�����̶��ɱ���%.2f\n����ɱ���%.2f\n����ɱ���%.2f\n����ɱ���%.2f\n�ͷ��ɱ���%.2f\n', Cost(1),Cost(2),Cost(3),Cost(4),Cost(5))
if step == 0
    disp(['���������[',num2str(Xstart(1)),',',num2str(Xstart(2)),']�����Ϊ0']);
else
    load('distributePos','distributePos');
    disp(['���������[',num2str(distributePos(step,1)),',',num2str(distributePos(step,2)),']�����Ϊ0','����ȫ�������У����Ϊ->',num2str(distributePos(step,4))]);
end    
disp('�������·����');
figure(step+1);
plot(MaxIterFuncValue);
xlabel('��������'); ylabel('Ŀ�꺯��ֵ');title('���Ž���������ͼ');

%% ��ͼ
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

disp('ÿ������������Ϊ')
disp(manzailv)

end