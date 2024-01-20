%c_ij i=1,2 j=1,2,^,6  从i料场向j工地运输c_ij吨水泥
%c=[c11,c12,^,c16,c21,^c26]
function cost=cal_dist1(c)
%保留三位小数，精确到KG
c=roundn(c,-2);
c=reshape(c,6,2)';
location1=[1.25,1.25;8.75,0.75;0.5,4.75;5.75,5;3,6.5;7.25,7.75];
location2=[5,1;2,7];
demand=[3 5 4 7 6 11];
supply=[20;20];
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
penalty=5000000;
%总供应约束
constrain1=sum(c,2)-supply;
%需求约束
constrain2=sum(c,1)-demand;
%目标函数
cost=total_dist+sum(penalty*(max(constrain1,0)))+sum(penalty*(1-(constrain2==0)));
end




