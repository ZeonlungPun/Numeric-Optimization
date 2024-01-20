%利用三种方式，根据当前解随机生成新解
function new_solution=GenerateNewSolution(old_solution,stores_num,books_num)
new_solution=old_solution;
%生成一个随机数决定用哪种生成方式
choose_way=unifrnd(0,1);
%生成一些随机数
index=randperm(books_num);
if choose_way<= 1/15
    index=sort(index(1:2));
    %随机选择两个点交换位置
    [location1,location2]=deal(index(1),index(2));
    temp=new_solution(location1);
    new_solution(location1)=new_solution(location2);
    new_solution(location2)=temp;
elseif choose_way >(2/15) && choose_way <=(8/15)
    index=sort(index(1:2));
    %随机选择两个点,将这两点之间的顺序颠倒
    [location1,location2]=deal(index(1),index(2));
    slice=old_solution(location1:location2);
    slice_back=slice(end:-1:1);
    new_solution(location1:location2)=slice_back;
else
    index=sort(index(1:3));
    %随机选三个点，将前两个点之间的点移动到第三个点后
    [location1,location2,location3]=deal(index(1),index(2),index(3));
    slice=old_solution(location1:location2);
    if location3 ~= books_num
        slice2=old_solution(location3+1:end);
        %删除
        new_solution([location1:location2,location3+1:books_num])=[];
        %重新拼接
        new_solution=[new_solution,slice,slice2];
    else
        %删除
        new_solution(location1:location2)=[];
        %重新拼接
        new_solution=[new_solution,slice];
    end
end
end


