%运输水泥成本计算
%加选最优场地
narvs=16;
lb=zeros(1,16);
ub=20*ones(1,16);
obj_fun=@(c) cal_dist3(c);
options=optimoptions("ga","HybridFcn",@fmincon,"PopulationSize",200);
A=[ones(1,6),zeros(1,10) ;zeros(1,6),ones(1,6),zeros(1,4)];
supply=[20;20];
Aeq=[eye(6),eye(6),zeros(6,4)];
demand=[3 5 4 7 6 11]';
c_array1=[];

times=5;
cost_array1=zeros(times,16);

for i=1:times

    [c_min,fval]=ga(obj_fun,narvs,A,supply,Aeq,demand,lb,ub,[],[],options);
   
    c_array1(i)=fval;
    cost_array1(i,:)=c_min;
end
min(c_array1)

[min_num,min_index]=min(c_array1);
input=cost_array1(min_index,:);
input=roundn(input,-2);
loc=input(end-3:end);
loc=reshape(loc,2,2)';
c=input(1:end-4);
c=reshape(c,6,2)';
constrain1=sum(c,2)-supply;
constrain2=sum(c,1)-demand';
judge1=(constrain1<=20);
judge2=(constrain2==0);