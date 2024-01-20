function cost=cal_fee(store_index,data)
store_index=round(store_index);
book_price=data(:,1:end-1);
transportation=data(:,end);
book_cost=0;
for i=1:length(store_index)
    book_cost=book_cost+book_price(store_index(i),i);
end
store=unique(store_index);
transportation_cost=sum(transportation(store));
cost=book_cost+transportation_cost;
end