clear all;
%玉米高度之差
data=[49,-67,8,16,6,23,28,41,14,29,56,24,75,60,-48];
x_bar=mean(data);
s2=var(data);
n=length(data);
%假设数据来自正态均值为μ，方差为σ2，无信息先验
epochs=55500;
mu=zeros(epochs,1);
sigma2=zeros(epochs,1);
%初始值
mu(1)=0;
sigma2(1)=s2/4;
for epoch=2:epochs
    chi2=chi2rnd(n);
    sigma2(epoch)=((n-1)*s2+n*(x_bar-mu(epoch-1)).^2)/chi2;
    mu(epoch)=normrnd(x_bar,sqrt(sigma2(epoch)/n));
end

figure(1)
plot(1:epochs,mu);
title('\mu的后验概率图')
xlabel('t')
ylabel('\mu^{(t)}')
figure(2)
plot(1:epochs,sigma2);
title('\sigma^2的后验概率图')
xlabel('t')
ylabel('\sigma^2')
figure(3)
subplot(1,2,1)
hist(mu)
xlabel('\mu')
ylabel('frequency')
subplot(1,2,2)
hist(sigma2)
xlabel('\sigma^2')
ylabel('frequency')


