function [A,B]=intercross(A,B)
%% 执行单点交叉策略
L=length(A);
if L<10 %通过Wz判定交叉的个数
    W=L;
elseif ((L/10)-floor(L/10))>=rand&&L>10
    W=ceil(L/10)+8;%表示大于或等于实数x的最小整数 向shang取整
else
    W=floor(L/10)+8;%表示小于或等于实数x的最大整数 向xia取整
end

p=unidrnd(L-W+1);%保证是正的 通过p来确定从哪开始交叉

for i=1:W
    x=find(A==B(1,p+i-1));
    y=find(B==A(1,p+i-1));
    [A(1,p+i-1),B(1,p+i-1)]=exchange(A(1,p+i-1),B(1,p+i-1));%将A,B矩阵中p+i-1位置上的数值进行交换
    [A(1,x),B(1,y)]=exchange(A(1,x),B(1,y));%为了防止一个染色体序列中有重复的数出现
end

end