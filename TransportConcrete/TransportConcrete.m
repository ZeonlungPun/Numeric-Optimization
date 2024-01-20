%运输水泥成本计算
narvs=12;
lb=zeros(1,12);
ub=20*ones(1,12);
obj_fun=@(c) cal_dist(c);
options=optimoptions("particleswarm","HybridFcn",@fmincon);
options2=optimoptions("ga","HybridFcn",@fmincon,"PopulationSize",200);
obj_fun1=@(c) cal_dist1(c);
A=[ones(1,6),zeros(1,6);zeros(1,6),ones(1,6)];
supply=[20;20];
Aeq=[eye(6),eye(6)];
demand=[3 5 4 7 6 11]';
c_array1=[];
c_array2=[];
times=10;
cost_array1=zeros(times,12);
cost_array2=zeros(times,12);

for i=1:times

    [c_min,fval]=ga(obj_fun,narvs,A,supply,Aeq,demand,lb,ub,[],[],options2);
    [c_min1,fval1]=particleswarm(obj_fun1,narvs,lb,ub,options);
    fval_real=cal_dist(c_min1);
    c_array1(i)=fval;
    c_array2(i)=fval_real;
    cost_array1(i,:)=c_min;
    cost_array2(i,:)=c_min1;
end
min(c_array1)
min(c_array2)

[min_num,min_index]=min(c_array2);
input=cost_array2(min_index,:);
c=reshape(input,6,2)';
c=roundn(c,-2);
constrain1=sum(c,2)-supply;
constrain2=sum(c,1)-demand';
judge1=(constrain1<=20)
judge2=(constrain2==0)