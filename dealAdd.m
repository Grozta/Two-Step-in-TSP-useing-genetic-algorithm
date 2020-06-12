function[DemandRes,TimeRes,ServiceTimeRes] = dealAdd(Demand,Time,ServiceTime,q,outPutNew)
[count,m] = size(q);
[row,m1] = size(outPutNew);

DemandRes = [];
TimeRes = [];
ServiceTimeRes = [];

for i = 1:count
    totalDemand = 0;
    for tk =q(i):row
        if outPutNew(tk,3) == outPutNew(q(i),3)
            totalDemand =totalDemand + Demand(tk);
        end
    end
    DemandRes =[DemandRes;totalDemand];
    TimeRes =[TimeRes;Time(q(i),:)];
    ServiceTimeRes =[ServiceTimeRes;ServiceTime(q(i),:)];
end
end