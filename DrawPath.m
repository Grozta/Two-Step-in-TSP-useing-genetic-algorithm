%% ��·������
%����
% Chrom  ����·��   
% X      ����������λ��
function DrawPath(Chrom,X,Xstart,step,posInfo)
% R=[Chrom(1,:) Chrom(1,1)]; %һ�������(����)
X=[Xstart; X];
R=Chrom(1,:) ; %һ�������(����)
figure(step +100);
hold on
plot(X(:,1),X(:,2),'x','color',[0.5,0.5,0.5])
plot(X(Chrom(1,1),1),X(Chrom(1,1),2),'rv','MarkerSize',6)
if step
    om = 0;
end
for i=1:size(X,1)
    if i == 1
        posReal = 0;
    else
        posReal =  posInfo(i-1,1);
    end
    text(X(i,1)-0.005,X(i,2)-0.005,num2str(posReal),'color',[1,0,0]);
end
A=X(R,:);
row=size(A,1);
for i=2:row
    [arrowx,arrowy] = dsxy2figxy(gca,A(i-1:i,1),A(i-1:i,2));%����ת��
    annotation('textarrow',arrowx,arrowy,'HeadWidth',5,'color',[0,0,1]);
end
hold off
xlabel('������')
ylabel('������')
title('�켣ͼ')
box on