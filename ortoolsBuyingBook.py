import numpy as np
import pandas as pd
import time
from ortools.linear_solver import pywraplp

data=pd.read_csv('/home/kingargroo/geneticalgroithm/buying_books_opt.csv')
print(data)
trasport_fee=np.array(data.iloc[:,-1])
book_fee=np.array(data.iloc[:,1:-1])
solution_num=book_fee.shape[1]
bookstore_num=book_fee.shape[0]

#create solover for integer programming
solver = pywraplp.Solver.CreateSolver('SCIP')

# x_i stand for buying the ith book in the x_i store
x=[]
# optimization objective
expression = 0
fee=[]
for i in range(bookstore_num):
    x_i=[]
    for j in range(solution_num):
        x_=solver.IntVar(0,1,'x_{}_{}'.format(i,j) )
        fee_=book_fee[i,j]*x_+trasport_fee[i]*x_
        fee.append(fee_)
        x_i.append(x_)
    x.append(x_i)

for j in range(solution_num):
    expr=[]
    for x_ in x:
        expr.append(x_[j])
    solver.Add(solver.Sum(expr)==1)
    
# optimization objective
expression = solver.Sum(fee)
solver.Minimize(expression)



#solve the proble
status = solver.Solve()
if status == solver.OPTIMAL:
    print('objective=', solver.Objective().Value())
    print('problem solved in %f ms' % solver.wall_time())
    print('problem solved in %d iterations' % solver.iterations())
    print('problem solved in %d branch-and-bound node' % solver.nodes())
    for i in range(bookstore_num):
        for j in range(solution_num):
            if x[i][j].solution_value() ==1:
                print(x[i][j].name(), '=', x[i][j].solution_value())
else:
    print('problem have no optimal solution')


