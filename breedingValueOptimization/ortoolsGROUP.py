import numpy as np
import pandas as pd
import time
from ortools.linear_solver import pywraplp

ebv = np.array(pd.read_csv('/home/kingargroo/geneticalgroithm/GP22L.csv'))
group_num=ebv[:,1]
ebv = ebv[:,2]
sample_num = ebv.shape[0]
rel_mat = np.array(pd.read_csv('/home/kingargroo/geneticalgroithm/REL.csv'))
rel_mat = rel_mat[:, 1::]
rel_mat[np.eye(rel_mat.shape[0], dtype=bool)] = 0
solution_num = 2000

# create solover for integer programming
solver = pywraplp.Solver.CreateSolver('SCIP')
lambda_list=[0,15,35,60,90,100,150,200,250]
ebv_list,rel_list=[],[]
for lambd in lambda_list:
    R = []
    var_index = []
    index_count = 0
    expression = 0
    # create decision variable and objective function
    x = []

    for i in range(sample_num - 1):
        x_i = []
        R_i = []
        for j in range(i + 1, sample_num):
            x_ = solver.IntVar(0, 1, 'x_{}_{}'.format(i, j))
            x_i.append(x_)
            rij = (ebv[i] + ebv[j]) / 2 - lambd * rel_mat[i, j]
            R_i.append(rij)
            expression += rij * x_

        x.append(x_i)
        R.append(R_i)
    print('number of variables=', solver.NumVariables())
    solver.Maximize(expression)

    # constrain
    exprx = []
    for xx in x:
        for xxx in xx:
            exprx.append(xxx)
    solver.Add(solver.Sum(exprx) <= solution_num - 1)


    for i in range(len(x)):
        exprx = 0
        for ii in x[i]:
            exprx += ii
        lower_bound=min(group_num[i],5)
        upper_bound=group_num[i]
        solver.Add(exprx <= upper_bound)
        #solver.Add(exprx>=lower_bound)

    init_i = len(x)
    for j in range(sample_num):
        expry = []
        for i in range(init_i):
            expry.append(x[i][j])
        lower_bound = min(group_num[j], 5)
        upper_bound = group_num[j]
        solver.Add(solver.Sum(expry) <= upper_bound)
        #solver.Add(solver.Sum(expry) >= lower_bound)
        init_i -= 1

    # solve the proble
    status = solver.Solve()
    if status == solver.OPTIMAL:
        print('objective=', solver.Objective().Value())
        print('problem solved in %f ms' % solver.wall_time())
        print('problem solved in %d iterations' % solver.iterations())
        print('problem solved in %d branch-and-bound node' % solver.nodes())
    else:
        print('problem have no optimal solution')

    solution_index = []
    rel_total=0
    ebv_total=0
    for x_ in x:
        for x__ in x_:
            if x__.solution_value() != 0:
                print(x__.name(), '=', x__.solution_value())
                x_str = x__.name()
                split_list = x_str.split('_')
                i,j=int(split_list[1]),int(split_list[2])
                solution_index.append(i)
                solution_index.append(j)
                rel_total+=rel_mat[i,j]
                ebv_total+=(ebv[i]+ebv[j])/2
    from collections import Counter
    element_counts = dict(Counter(solution_index))
    print(element_counts)
    rel_list.append(rel_total/(sample_num**2-sample_num))
    ebv_list.append(ebv_total/sample_num)

import matplotlib.pyplot as plt
fig = plt.figure()
ax1 = fig.add_subplot(111)
ax1.plot(lambda_list, ebv_list)
ax1.set_ylabel(' EBV value')
ax1.set_xlabel('lambda')
ax1.set_title("EBV AND RELATIONSHIP selection")
#ax1.legend(['ebv'])
ax2 = ax1.twinx()  # this is the important function
ax2.plot(lambda_list, rel_list, 'r')
ax2.set_ylabel('RELATIONSHIP VALUE')
ax2.set_xlabel('lambda')
#fig.legend(['ebv','rel'])
plt.show()