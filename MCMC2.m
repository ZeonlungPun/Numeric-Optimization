%老年人智力测试
clear all;
x=[9,13,6,8,10,4,14,8,11,7,9,7,5,14,13,16,10,12,11,14,15,18,7,16,9,9,11,13,15,13,10,11,6,17,14,19,9,11,14,10,16,10,16,14,13,13,9,15,10,11,12,4,14,20];
y=[ones(1,14),zeros(1,40)];
%随机游动
epochs=50000;
beta=zeros(epochs,2);
beta(1,1)=0;
beta(1,2)=0;
%记录拒绝次数
reject_num=0;
%建议分布方差
tao0=0.05;
tao1=0.05;
%记录路径信息
trace=zeros(2*epochs,2);
trace(1,1)=beta(1,1);
trace(1,2)=beta(1,2);
for epoch=2:epochs
    candidate=mvnrnd(beta(epoch-1,:),[tao0^2,0;0,tao1^2]);%从建议分布中抽样
    beta0_new=candidate(1);%新产生的候选点
    beta1_new=candidate(2);
    post_new1=logistic_p_y_beta(beta0_new,beta1_new,x,y);
    post_new2=normcdf(beta0_new,0,100)*normcdf(beta1_new,0,100);
    post_new_beta=post_new1*post_new2;%beta'的后验分布
    post_old1=logistic_p_y_beta(beta(epoch-1,1),beta(epoch-1,2),x,y);
    post_old2=normcdf(beta(epoch-1,1),0,100)*normcdf(beta(epoch-1,2),0,100);
    post_old_beta=post_old1*post_old2;%beta的后验分布
    alpha=min(1,post_new_beta/post_old_beta);%接受概率
    judge_u=unifrnd(0,1);%判别数，看本次值是否发生变化
    if judge_u<=alpha
        beta(epoch,:)=candidate;
    else
        beta(epoch,:)=beta(epoch-1,:);
        reject_num=reject_num+1;
    end
end






%逐分量MH抽样
%随机游动
epochs=55000;
beta=zeros(epochs,2);
beta(1,1)=0;
beta(1,2)=0;
%记录拒绝次数
reject_num1=0;
reject_num2=0;
%建议分布方差
tao0=0.005;
tao1=0.005;
%记录路径信息
trace=zeros(2*epochs,2);
trace(1,1)=beta(1,1);
trace(1,2)=beta(1,2);
for epoch=2:epochs
    %抽取β0
    beta0_new=normrnd(beta(epoch-1,1),tao0);%从建议分布产生候选点
    post_new1=logistic_p_y_beta(beta0_new,beta(epoch-1,2),x,y);
    post_new2=normcdf(beta0_new,0,100);
    post_new_beta=post_new1*post_new2;%beta'的后验分布
    post_old1=logistic_p_y_beta(beta(epoch-1,1),beta(epoch-1,2),x,y);
    post_old2=normcdf(beta(epoch-1,1),0,100);
    post_old_beta=post_old1*post_old2;%beta的后验分布
    alpha1=min(1,post_new_beta/post_old_beta);
    judge_u1=unifrnd(0,1);%判别数，看本次值是否发生变化
    if judge_u1<=alpha1
        beta(epoch,1)=beta0_new;
    else
        beta(epoch,1)=beta(epoch-1,1);
        reject_num1=reject_num1+1;
    end
    %抽取β1
    beta1_new=normrnd(beta(epoch-1,2),tao1);%从建议分布产生候选点
    post_new1=logistic_p_y_beta(beta(epoch,1),beta1_new,x,y);
    post_new2=normcdf(beta1_new,0,100);
    post_new_beta=post_new1*post_new2;%beta'的后验分布
    post_old1=logistic_p_y_beta(beta(epoch,1),beta(epoch-1,2),x,y);
    post_old2=normcdf(beta(epoch-1,2),0,100);
    post_old_beta=post_old1*post_old2;%beta的后验分布
    alpha2=min(1,post_new_beta/post_old_beta);
    judge_u2=unifrnd(0,1);%判别数，看本次值是否发生变化
    if judge_u2<=alpha2
        beta(epoch,2)=beta1_new;
    else
        beta(epoch,2)=beta(epoch-1,2);
        reject_num2=reject_num2+1;
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
beta0_=mean(beta0(15000:end));
beta1_=mean(beta1(15000:end));

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
reject_ratio1=reject_num1/epochs
reject_ratio2=reject_num2/epochs

