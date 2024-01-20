%c_ij i=1,2 j=1,2,^,6  从i料场向j工地运输c_ij吨水泥
%最后两个参数是供应商坐标
%var=[c11 c12 c13,^,c25,c26,x1,y1,x2,y2]
function cost=cal_dist3(var)
%保留三位小数，精确到KG
var=roundn(var,-2);
location2=var(end-3:end);
location2=reshape(location2,2,2);%注意reshape后形式的排布
location2=location2';
c=var(1:end-4);
c=reshape(c,6,2);
c=c';%(2,6)
location1=[1.25,1.25;8.75,0.75;0.5,4.75;5.75,5;3,6.5;7.25,7.75];

[minus1,minus2]=deal(location1-location2(1,:),location1-location2(2,:));
%到第一个料场的距离
dist1=bsxfun(@hypot,minus1(:,1),minus1(:,2));
%到第二个料场的距离
dist2=bsxfun(@hypot,minus2(:,1),minus2(:,2));
%从P运输水泥的总距离
Pdist=c(1,:)*dist1;
%从Q
Qdist=c(2,:)*dist2;
total_dist=Pdist+Qdist;
cost=total_dist;
end




