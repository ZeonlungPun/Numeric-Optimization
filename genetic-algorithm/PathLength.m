function len = PathLength(coordinate,Chrom)
%calculate the distance of all indivisulas
NIND = size(Chrom,1);
len = zeros(NIND,1);
for i = 1:NIND
    dist=total_dist(Chrom(i,:),coordinate);
    len(i,1)=dist;
end