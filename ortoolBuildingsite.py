import numpy as np
import pandas as pd
import yaml
from ortools.linear_solver import pywraplp

solver = pywraplp.Solver('SolveStigler',
                         pywraplp.Solver.GLOP_LINEAR_PROGRAMMING)

coordinate=np.array([[1.25,8.75,0.5,5.75,3,7.25],[1.25,0.75,4.75,5,6.5,7.75]])

dest=np.array([[5,2],[1,7]])

dist_mat=np.zeros((2,6))
demand=[3,5,4,7,6,11]
supply=[20,20]

#question 1
x=[]
objective = solver.Objective()
for i in range(2):
    x_i = []
    source = dest[:, i]
    for j in range(6):
        point = coordinate[:, j]
        dist_mat[i, j] = np.sum((source - point) ** 2)
        x_= solver.NumVar(0.0, solver.infinity(),'x_{}_{}'.format(i,j))
        objective.SetCoefficient(x_, dist_mat[i,j])
        x_i.append(x_)
    x.append(x_i)
objective.SetMinimization()


#demand constrain
for j in range(6):
    exper=[]
    for i in range(2):
        exper.append(x[i][j])
    solver.Add(solver.Sum(exper) == demand[j])

#supply constrain
for i in range(2):
    exper=[]
    for xx in x[i]:
        exper.append(xx)
        solver.Add(solver.Sum(exper) <=supply[i])
        
#solve the proble
status = solver.Solve()
if status == solver.OPTIMAL:
    print('objective=', solver.Objective().Value())
    print('problem solved in %f ms' % solver.wall_time())
    print('problem solved in %d iterations' % solver.iterations())
    print('problem solved in %d branch-and-bound node' % solver.nodes())
    for i in range(2):
        for j in range(6):
            print(x[i][j].name(), '=', x[i][j].solution_value())
else:
    print('problem have no optimal solution')


#question 2
x=[]
y=[]
x.append(solver.NumVar(0.0, solver.infinity(), 'x_1'))
x.append(solver.NumVar(0.0, solver.infinity(), 'x_2'))
y.append(solver.NumVar(0,solver.infinity(),'y_1'))
y.append(solver.NumVar(0,solver.infinity(),'y_2'))
c=[]
for i in range(2):
    xx=x[i]
    yy=y[i]
    c_i = []
    source=np.array([xx,yy])
    for j in range(6):
        point = coordinate[:, j]
        c_ = solver.NumVar(0.0, solver.infinity(), 'c_{}_{}'.format(i, j))
        dist_ = (source-point)**2
        objective.SetCoefficient(c_, dist_)
        c_i.append(c_)
    c.append(c_i)
objective.SetMinimization()
# demand constrain
for j in range(6):
    exper = []
    for i in range(2):
        exper.append(c[i][j])
    solver.Add(solver.Sum(exper) == demand[j])

# supply constrain
for i in range(2):
    exper = []
    for cc in c[i]:
        exper.append(cc)
        solver.Add(solver.Sum(exper) <= supply[i])

# solve the proble
status = solver.Solve()
if status == solver.OPTIMAL:
    print('objective=', solver.Objective().Value())
    print('problem solved in %f ms' % solver.wall_time())
    print('problem solved in %d iterations' % solver.iterations())
    print('problem solved in %d branch-and-bound node' % solver.nodes())
    for i in range(2):
        for j in range(6):
            print(c[i][j].name(), '=', c[i][j].solution_value())
    print(x[0].name(),'=',x[0].solution_value())
    print(y[0].name(),'=',y[0].solution_value())
    print(x[1].name(), '=', x[1].solution_value())
    print(y[1].name(), '=', y[1].solution_value())
else:
    print('problem have no optimal solution')

