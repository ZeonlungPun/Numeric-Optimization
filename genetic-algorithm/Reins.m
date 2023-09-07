function Chrom = Reins(Chrom,SelCh,ObjV)
%update the population (insert the best next generation) 
%Chrom      parents
%SelCh      next 
%ObjV       fitness of parents
%Chrom      combine the parents and next generation
NIND = size(Chrom,1);
NSel = size(SelCh,1);
[TobjV,index] = sort(ObjV);
%only keep the best parents
Chrom =  [Chrom(index(1:NIND-NSel),:);SelCh];
end