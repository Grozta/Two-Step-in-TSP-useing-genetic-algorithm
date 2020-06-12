%% 输出路径函数
%输入：R 路径
function p=OutputPath(R,posInfo,Xstart)
% R=[0 R 0];

N=length(R);
for j=1:N
    if R(j) == 0
        R(j) = 0;
    else
        R(j) = posInfo(R(j),1);
    end
end
p=num2str(R(1));
for i=2:N
    p=[p,'—>',num2str(R(i))];
end
disp(p)