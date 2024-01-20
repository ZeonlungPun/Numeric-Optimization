function real_cost=only_obj(c)
c=roundn(c,-2);
c=reshape(c,2,6);
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
real_cost=Pdist+Qdist;
end