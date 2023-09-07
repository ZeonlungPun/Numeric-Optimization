function SelCh = Reverse(SelCh,coordinate)
% inverse sequence
%example : r1=3,r2=5   1 3 4 2 10  9 8 7 6 5 ---> 1 3 10 2 4  9 8 7 6 5
[row,col] = size(SelCh);
ObjV = PathLength(coordinate,SelCh);
SelCh1 = SelCh;
for i = 1:row
    r1 = randsrc(1,1,[1:col]);
    r2 = randsrc(1,1,[1:col]);
    mininverse = min([r1 r2]);
    maxinverse = max([r1 r2]);
    SelCh1(i,mininverse:maxinverse) = SelCh1(i,maxinverse:-1:mininverse);
end
ObjV1 = PathLength(coordinate,SelCh1);
index = ObjV1<ObjV;
SelCh(index,:)=SelCh1(index,:);