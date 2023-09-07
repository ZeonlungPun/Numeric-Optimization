% select some indiviuals for next generation 
function SelCh = Select(Chrom,FitnV,GGAP)
%Chrom population
%FitnV fitness value
%GGAP selection probability
NIND = size(Chrom,1);%population size
NSel = max(floor(NIND * GGAP+.5),2); % calculate seletion number
% save seletion index 
ChrIx=[]; 
for i =1:NSel
    % get a random number between [0,1]
    r=rand();
    select_id=SUS_one(FitnV,r);
    ChrIx=[ChrIx;select_id]; 
    SelCh = Chrom(ChrIx,:);
end
end