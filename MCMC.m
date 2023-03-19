%多参数模型的抽样：2008年美国总统大选
EV=[9,3,10,6,55,9,7,3,3,27,15,4,4,21,11,7,6,8,9,4,10,12,17,10,6,11,3,5,5,4,15,5,31,15,3,20,7,7,21,4,8,3,11,34,5,3,13,11,5,10,3]';%各州选举人票
ratio=[58,36;55,37;50,46;51,44;33,55;45,52;31,56;38,56;13,82;46,50;52,47;32,63;68,26;35,59;48,48;37,54;63,31;51,42;50,43;35,56;39,54;34,53;37,53;42,53;46,33;
 48,48;49,46;60,34;43,47;42,53;34,55;43,51;31,62;49,46;43,45;47,45;61,34;34,48;46,52;31,45;59,39;48,41;55,59;57,38;55,32;36,57;44,47;39,51;53,44;42,53;58,32]/100;
r=1-sum(ratio,2);
ratio=[ratio,r];
frequency=500*ratio;%各州支持人数
result=[];
for time=1:length(EV)
    w1=gamrnd(frequency(time,1),1,5000,1);
    w2=gamrnd(frequency(time,2),1,5000,1);
    w3=gamrnd(frequency(time,3),1,5000,1);
    t=w1+w2+w3;
    xita1=w1./t;
    xita2=w2./t;
    [N,edges] = histcounts(xita1-xita2);%对θ1-θ2的取值作分箱操作
    [~,index]=max(N);
    result=[result;edges(index)];
end
judge=(result<0);
evo=sum(judge.*EV);
%不写for循环的方法
result2=arrayfun(@(time)one_operation(frequency,sample_num,time),1:length(EV),'uni',1);

%吉布斯抽样
%成年人体温数据
beat=[96.3,96.7,96.9,97,97.1*ones(1,3),97.2*ones(1,3),97.3,97.4*ones(1,5),97.5,97.5,97.6*ones(1,4),97.7*ones(1,3),97.8*ones(1,7),97.9*ones(1,5),99.1,99.2,99.3,99.4,99.5,96.4,96.7,98*ones(1,6),98.1,98.1,98.2*ones(1,4),98.4*ones(1,9),98.5*ones(1,3),98.6*ones(1,10),98.7*ones(1,8),98.8*ones(1,10),98.9,99*ones(1,5),96.8,98*ones(1,5),98.1,98.2*ones(1,6),98.3*ones(1,5),98.9,99,99,99.1,99.1,99.2,99.2,99.3,99.4,99.9,100,100.8];
y_bar=mean(beat);
s_quare=var(beat);
n=length(beat);%样本容量
%给定先验值
mu0=98.6;
sigma0=100;
b0=0;
%给定初始值
mu=zeros(1501,1);
mu(1)=y_bar/2;
sigma=zeros(1501,1);
for i=2:1501
    t=chi2rnd(n);
    sigma(i)=((n-1)*s_quare+n*(mu(i-1)-y_bar).^2+b0)./t;
    A=1./(sigma(i)*sigma0*(sigma(i).^2+n*sigma0^2).^0.5);
    B=(y_bar*n*sigma0^2+sigma(i)^2*mu0)/(n*sigma0^2+sigma(i)^2);
    mu(i)=normrnd(B,A^2);
end

plot(1:length(mu),mu)
xlabel('epoch')
ylabel('\mu')
%去除预烧期后求均值
mu_bar=mean(mu(end-500:end));



%老年人智力测试
x=[9,13,6,8,10,4,14,8,11,7,9,7,5,14,13,16,10,12,11,14,15,18,7,16,9,9,11,13,15,13,10,11,6,17,14,19,9,11,14,10,16,10,16,14,13,13,9,15,10,11,12,4,14,20];
y=[ones(1,14),zeros(1,40)];
%吉布斯切片抽样
epochs=50000;
beta=zeros(epochs,2);
beta(1,1)=0.005;
beta(1,2)=0.005;
%记录路径信息
trace=zeros(2*epochs,2);
trace(1,1)=beta(1,1);
trace(1,2)=beta(1,2);
for epoch=2:epochs
    u=[];
    for i=1:length(y)
        u_upper=exp(beta(epoch-1,1)*y(i)+beta(epoch-1,2)*x(i)*y(i))./(1+exp(beta(epoch-1,1)+beta(epoch-1,2)*x(i)));
        u_i=unifrnd(0,u_upper);
        u=[u,u_i];
    end
    judge1=(u<(exp(beta(epoch-1,1).*y+beta(epoch-1,2).*x.*y)./(1+exp(beta(epoch-1,1)+beta(epoch-1,2).*x))));
    if sum(judge1)==length(judge1)
        beta(epoch,1)=normrnd(0,100);
    else 
        beta(epoch,1)=0;
    end
    judge2=(u<(exp(beta(epoch,1).*y+beta(epoch-1,2).*x.*y)./(1+exp(beta(epoch,1)+beta(epoch-1,2).*x))));
    if sum(judge2)==length(judge2)
        beta(epoch,2)=normrnd(0,100);
    else 
        beta(epoch,2)=0;
    end
    trace(2*epoch-2,1)=beta(epoch,1);
    trace(2*epoch-2,2)=beta(epoch-1,2);
    trace(2*epoch-1,1)=beta(epoch,1);
    trace(2*epoch-1,2)=beta(epoch,2);
end
beta0=beta(:,1);
beta1=beta(:,2);
figure(1);
subplot(2,1,1)
plot(1:length(beta0),beta0);
xlabel('epoch')
ylabel('\beta_0^{(t)}')
subplot(2,1,2)
plot(1:length(beta1),beta1);
xlabel('epoch')
ylabel('\beta_1^{(t)}')
title('一条链的样本路径图')
%final result
beta0_=mean(beta0(end-500:end));
beta1_=mean(beta1(end-500:end));

figure(2)
%轨迹图
plot(trace(:,1),trace(:,2),'r*-');
xlabel('\beta_o');
ylabel('\beta_1');
title('轨迹图')
%后验样本散点图
figure(3)
scatter(beta0(1500:end),beta1(1500:end))
xlabel('\beta_0')
ylabel('\beta_1')
title('后验样本散点图')
%遍历均值图
figure(4)
m_beta0=[];
m_beta1=[];
for i=1:length(beta1)
    m_beta0(i)=mean(beta0(1:i));
    m_beta1(i)=mean(beta1(1:i));
end
subplot(1,2,1)
plot(1:length(m_beta0),m_beta0)
xlabel('t')
ylabel('\beta_0^{(t)}')
subplot(1,2,2)
plot(1:length(m_beta1),m_beta1)
xlabel('t')
ylabel('\beta_1^{(t)}')
title('遍历均值图')

%训练集预测
p=exp(beta0_+beta1_*x)./(1+exp(beta0_+beta1_*x));
predict_class=(p>0.5);
accuracy=sum(y==predict_class)/length(y);
