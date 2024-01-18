import numpy as np
import pandas as pd
import time
from ortools.linear_solver import pywraplp
ebv=np.array(pd.read_csv('/home/kingargroo/geneticalgroithm/ebvt.csv'))
ebv=ebv[0:2000,3]
sample_num=ebv.shape[0]
rel_mat=np.array(pd.read_csv('/home/kingargroo/geneticalgroithm/rel.csv'))
rel_mat=rel_mat[:,2::]
rel_mat[np.eye(rel_mat.shape[0],dtype=bool)]=0
rel_mat=rel_mat[0:2000,0:2000]
solution_num=10

#create solover for integer programming
solver = pywraplp.Solver.CreateSolver('SCIP')

lambd=0
R=[]
var_index=[]
index_count=0
expression = 0
#create decision variable and objective function
x=[]

for i in range(sample_num-1):
    x_i=[]
    R_i=[]
    for j in range(i+1,sample_num):
        x_=solver.IntVar(0,1,'x_{}_{}'.format(i,j) )
        x_i.append(x_)
        rij=(ebv[i]+ebv[j])/2 -lambd*rel_mat[i,j]
        R_i.append(rij)
        expression += rij * x_
  
    x.append(x_i)
    R.append(R_i)
print('number of variables=', solver.NumVariables())    
solver.Maximize(expression)

#constrain
exprx=[]
for xx in x:
    for xxx in xx:
        exprx.append(xxx)
solver.Add(solver.Sum(exprx) <=solution_num-1)


Ni=1
for i in range(len(x)):
    exprx=0
    for ii in x[i]:
        exprx+=ii
    solver.Add(exprx<=Ni)

init_i=len(x)
for j in range(sample_num):
    expry = []
    for i in range(init_i):
        expry.append(x[i][j])
    solver.Add(solver.Sum(expry) <=Ni)
    init_i-=1
        
        
    

#solve the proble
status = solver.Solve()
if status == solver.OPTIMAL:
    print('objective=', solver.Objective().Value())
    print('problem solved in %f ms' % solver.wall_time())
    print('problem solved in %d iterations' % solver.iterations())
    print('problem solved in %d branch-and-bound node' % solver.nodes())
else:
    print('problem have no optimal solution')

solution_index=[]
for x_ in x:
    for x__ in x_:
        if x__.solution_value()!=0:
            print(x__.name(), '=', x__.solution_value())
            x_str=x__.name()
            split_list=x_str.split('_')
            solution_index.append(int(split_list[1]))
            solution_index.append(int(split_list[2]))
solution_index=list(set(solution_index))
ebv_mean=np.mean(ebv[solution_index])