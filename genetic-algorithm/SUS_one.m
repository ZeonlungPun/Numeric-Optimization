% SUS : select one based on the fitness of each individual
function select_one=SUS_one(fitness,r)
%fitness : n individual x 1
% r :a random number between [0,1]
p=fitness./sum(fitness);
m=0;

for i=1:length(fitness)
    m=m+p(i);
    if r<=m
        select_one=i;
        break;
    end
end

