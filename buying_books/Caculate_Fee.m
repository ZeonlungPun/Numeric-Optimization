function fee=Caculate_Fee(solution,book_price,transportation)
%book_price :15 stores x  20 books
store_index=unique(solution);
transportation_fee=sum(transportation(store_index));
book_fee=0;
for j=1:size(book_price,2)
    book_fee=book_fee+book_price(solution(j),j);
end
fee=book_fee+transportation_fee;
end


