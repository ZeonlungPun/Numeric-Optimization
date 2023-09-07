function cost=total_dist(index,coordinate)
%coordinate : n cities x 2 coordinates (x y)
dist_mat=pdist2(coordinate,coordinate);
cost=0;
for i=1:length(index)-1
    i1=index(i);
    i2=index(i+1);
    cost=cost+dist_mat(i1,i2);
end
cost=cost+dist_mat(index(1),index(end));

end