
narvs=20;
lb=ones(1,20);
ub=15*ones(1,20);
data=xlsread("buying_books_opt.xlsx","B2:V16");
obj_fun=@(store_index) cal_fee(store_index,data);

options=optimoptions("particleswarm","HybridFcn",@fmincon);

obj_array1=[];
input_array1=[];
obj_array2=[];
input_array2=[];
obj_array3=[];
input_array3=[];
obj_array4=[];
input_array4=[];
times=300
for time=1:times
    %初始值
    if time==1
        x0=randi(20,[1,20]);
    else
        x0=index3;
    end
    %粒子群算法
    [index1,fval1]=particleswarm(obj_fun,narvs,lb,ub,options);
    %遗传算法
    [index2,fval2]=ga(obj_fun,narvs,[],[],[],[],lb,ub);
    %模拟退火
    [index3,fval3]=simulannealbnd(obj_fun,x0,lb,ub);
    %代理优化
    %[index4,fval4]=surrogateopt(obj_fun,lb,ub);
    input_array1(time,:)=index1;
    input_array2(time,:)=index2;
    obj_array1(time)=fval1;
    obj_array2(time)=fval2;
    input_array3(time,:)=index3;
    %input_array4(time,:)=index4;
    obj_array3(time)=fval3;
    %obj_array4(time)=fval4;
end
min(obj_array1)
min(obj_array2)
min(obj_array3)
%min(obj_array4)