function [A,B]=intercross(A,B)
%% ִ�е��㽻�����
L=length(A);
if L<10 %ͨ��Wz�ж�����ĸ���
    W=L;
elseif ((L/10)-floor(L/10))>=rand&&L>10
    W=ceil(L/10)+8;%��ʾ���ڻ����ʵ��x����С���� ��shangȡ��
else
    W=floor(L/10)+8;%��ʾС�ڻ����ʵ��x��������� ��xiaȡ��
end

p=unidrnd(L-W+1);%��֤������ ͨ��p��ȷ�����Ŀ�ʼ����

for i=1:W
    x=find(A==B(1,p+i-1));
    y=find(B==A(1,p+i-1));
    [A(1,p+i-1),B(1,p+i-1)]=exchange(A(1,p+i-1),B(1,p+i-1));%��A,B������p+i-1λ���ϵ���ֵ���н���
    [A(1,x),B(1,y)]=exchange(A(1,x),B(1,y));%Ϊ�˷�ֹһ��Ⱦɫ�����������ظ���������
end

end