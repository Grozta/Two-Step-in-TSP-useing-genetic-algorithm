function [u,q,outPutNew,totalInNew] = selectRealPoint(inPut,endDist)
    
    [row ,~] = size(inPut);
    oneCol = zeros(row,1);
    inPutNew = [inPut oneCol];
    count = 0;
    for i=1:row
        if (inPutNew(i,3)==0)
            count = count + 1;
            [inPutNew,count] = mark(i,count,row,inPutNew,endDist);
        end
    end
    outPutNew = inPutNew;
    op = 1;
    for i=1:row 
        if inPutNew(i,3) == op
            inPutNew(i,3) = op*(-1);
            op = op +1;     
        end
    end
    [ki,~] = size(inPutNew);
    oneRow = [1:ki]';
    inPutNew = [inPutNew oneRow]; % ---->
    totalInNew = inPutNew;
    [inPutNew,~]=sortrows(inPutNew,3);
    op = 1;
    while inPutNew(op,3)<0
        op = op+1;
    end
    op = op -1;
    inPutNew = inPutNew(1:op,:);
    [inPutNew,~]=sortrows(inPutNew,-3);
    q = inPutNew(:,end);
    inPutNew(:,end)=[];inPutNew(:,end)=[];
    u=inPutNew;
    
end

function [inPutNew1,count1] = mark(num,count,row,inPutNew,endDist)
    for k = num:row
        if inPutNew(k,3) == 0
            oRes = ((inPutNew(num,1)-inPutNew(k,1))^2+(inPutNew(num,2)-inPutNew(k,2))^2)^0.5;  
            if oRes< endDist      %%%%%%%%%%%%%%%%%%%%%
                inPutNew(k,3) = count;
            end
        end
%         oRes = ((inPutNew(num,1)-inPutNew(k,1))^2+(inPutNew(num,2)-inPutNew(k,2))^2)^0.5;  
%         if oRes< endDist      %%%%%%%%%%%%%%%%%%%%%
%             inPutNew(k,3) = count;
%         end
    end
    markCol = find(inPutNew(:,3) == count);
    [rowRes,~] = size(markCol);
    if rowRes <= 3
        count = count -1;
        for o =1:size(markCol)
            inPutNew(markCol(o),3) = count;
        end
    end
    count1 = count;
    inPutNew1 = inPutNew;
end
