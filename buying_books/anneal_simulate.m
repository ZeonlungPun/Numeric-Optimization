%模拟退火寻找最优买书方案
clear all;
data=xlsread("buying_books_opt.xlsx","B2:V16");
books_price=data(:,1:end-1);
transportation=data(:,end);
[stores_num,books_num]=size(books_price);

%参数初始化
T0=2500;%初始温度
max_iter=8000;%最大迭代次数
T=T0;%迭代时的温度
alpha=0.9;%温度衰减系数
T_iter=1800;%每个温度下的迭代次数

%随机生成一个初始解
solution0=randi(stores_num,[1,books_num]);
cost0=Caculate_Fee(solution0,books_price,transportation);

%保存中间过程的变量
min_cost=cost0;%当前最小值
cost_result=zeros(max_iter,1);%记录外层循环找到的Min_cost
solution_result=zeros(max_iter,books_num);
best_solution=solution0;

%模拟退火主过程
for iter=1:max_iter
    for t=1:T_iter
        NewSolution=GenerateNewSolution(solution0,stores_num,books_num);
        NewCost=Caculate_Fee(NewSolution,books_price,transportation);
        %如果新的花费更低，则更新；否则以一定概率更新
        if NewCost < cost0
            solution0=NewSolution;
            cost0=NewCost;
        else
            p=exp(-(NewCost-cost0)/T);
            if rand(1)<p
                solution0=NewSolution;
                cost0=NewCost;
            end
        end
        %判断是否更新找到的最优解
        if cost0< min_cost
            min_cost=cost0;
            best_solution=solution0;
        end
    end
    cost_result(iter,1)=min_cost;
    solution_result(iter,:)=best_solution;
    T=alpha*T;
end

disp("最佳方案是去以下书店依次购买对应书籍：");disp(best_solution)
disp("花费最少：");disp(min_cost)