%英国矿难数据，寻找变点年份
coal_num=xlsread("coal.xlsx")';
n=length(coal_num);
epochs=3000;
%给定先验
alpha1=0.5;%Γ分布参数
alpha2=0.5;
beta1=1;
beta2=1;
%起始年份
a=1850;
%给定初始值
lamda=zeros(epochs,2);%泊松分布参数
tau=zeros(epochs,1);%变点
lamda(1,:)=[1,1];
tau(1)=a+randperm(112,1);%任意选择一个年份作为初始变点

%抽样
for epoch=2:epochs
    lamda(epoch,1)=gamrnd(alpha1+sum(coal_num(1:(tau(epoch-1)-a))),1./(beta1+tau(epoch-1)-a));
    lamda(epoch,2)=gamrnd(alpha2+sum(coal_num(tau(epoch-1)-a+1:end)),1./(beta2+a+n-tau(epoch-1)));

    %算出此时变点τ的概率分布
    tau_pdist=[];
    for j=1:n%计算分布的核
        tau_pdist(j)=exp((lamda(epoch,2)-lamda(epoch,1))*j)*(lamda(epoch,1)/lamda(epoch,2)).^(sum(coal_num(1:j)));
    end
    %归一化才是真正的概率分布
    tau_pdist=tau_pdist./sum(tau_pdist);
    %依据该概率分布采样τ
    tau(epoch)=randsrc(1,1,[1851:1962; tau_pdist]);
end

%最终结果
lamda1=mean(lamda(2000:end,1));
lamda2=mean(lamda(2000:end,2));
tau_=mean(tau(2000:end));

figure(1)
subplot(3,1,1)
plot(1:length(tau),tau);
xlabel('epoch')
ylabel('\tau')
title('时间节点估计值\tau随着迭代次数的变化示意图')
subplot(3,1,2)
plot(1:length(lamda(:,1)),lamda(:,1))
xlabel('epoch')
ylabel('\lambda_1')
title('参数\lambda_1随着迭代次数的变化示意图')
subplot(3,1,3)
plot(1:length(lamda(:,2)),lamda(:,2))
xlabel('epoch')
ylabel('\lambda_2')
title('参数\lambda_2随着迭代次数的变化示意图')

figure(2)
%遍历均值图
m_lamda1=[];
m_lamda2=[];
for i=1:length(lamda)
    m_lamda1(i)=mean(lamda(1:i,1));
    m_lamda2(i)=mean(lamda(1:i,2));
end
subplot(1,2,1)
plot(1:epochs,m_lamda1)
xlabel('t')
ylabel('\lambda_1^{(t)}')
subplot(1,2,2)
plot(1:epochs,m_lamda2)
xlabel('t')
ylabel('\lambda_2^{(t)}')
title('参数\lambda的遍历均值图')