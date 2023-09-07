function Chrom = InitPop(NIND,N)%innitialize the populations
%NIND： population size
%N: the length of chrome (city number or solution number)
Chrom = zeros(NIND,N);  
for i = 1:NIND
    Chrom(i,:) = randperm(N);
end
end