function [demandArrRes,timeWindowsRes,serverRes] = dealExat(demandArr,timeWindows,server,realIn)
[row,m1] = size(realIn);
demandArrRes = [];
timeWindowsRes = [];
serverRes = [];
for i =1:row
    demandArrRes = [demandArrRes;demandArr(realIn(i,4),:)];
    timeWindowsRes = [timeWindowsRes;timeWindows(realIn(i,4),:)];
    serverRes = [serverRes;server(realIn(i,4),:)];
end 
end 