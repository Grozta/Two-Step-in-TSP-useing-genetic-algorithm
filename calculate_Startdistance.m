function [Startdistance] = calculate_Startdistance(X,Y)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n=size(Y,1);
Startdistance=zeros(1,n);
for i=1:n
    Startdistance(i)=((X(1,1)-Y(i,1))^2+(X(1,2)-Y(i,2))^2)^0.5;
end
end

