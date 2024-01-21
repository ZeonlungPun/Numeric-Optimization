from sko.GA import GA
import numpy as np
import pandas as pd
import time,optuna

ebv=np.array(pd.read_csv('/home/kingargroo/geneticalgroithm/ebvt.csv'))
sample_num=ebv.shape[0]
ebv=ebv[:,3]
rel_mat=np.array(pd.read_csv('/home/kingargroo/geneticalgroithm/rel.csv'))
rel_mat=rel_mat[:,2::]
rel_mat[np.eye(rel_mat.shape[0],dtype=bool)]=0
solution_num=150
#scikit-opt minimize
def objective_function(parameter):
    parameter_list=np.zeros((1,len(parameter)))

    for index,para in enumerate(parameter):
        para=int(para)
        parameter_list[0,index]=para
    parameter_list=np.array(parameter_list.ravel(),dtype=int)
    if len(np.unique(parameter_list)) <len(parameter):
        return 10000000000000000000
    else:
        return -np.mean(ebv[parameter_list])
from sko.DE import DE
from sko.PSO import PSO
from sko.SA import SA,SACauchy,SABoltzmann
from sko.AFSA import AFSA
to=time.time()
#ga=GA(func=objective_function,n_dim=solution_num,size_pop=250,max_iter=800,lb=[0]*solution_num,ub=[ebv.shape[0]]*solution_num,)
#ga=DE(func=objective_function,n_dim=solution_num,size_pop=250,max_iter=800,lb=[0]*solution_num,ub=[ebv.shape[0]]*solution_num,)
#ga=PSO(func=objective_function,n_dim=solution_num,max_iter=1800,lb=[0]*solution_num,ub=[ebv.shape[0]]*solution_num)
#ga=SABoltzmann(func=objective_function,n_dim=solution_num,max_iter=1800,lb=[0]*solution_num,ub=[ebv.shape[0]]*solution_num,x0=np.arange(0,solution_num))
ga=AFSA(func=objective_function,n_dim=solution_num,max_iter=1800,lb=[0]*solution_num,ub=[ebv.shape[0]]*solution_num)
best_x,best_y=ga.run()
t1=time.time()
print("run time{}".format(t1-to))
print(best_y)

# def objective_for_optuna(trial):
#     size_pop = trial.suggest_int("population",50,1500)
#     if size_pop%2!=0:
#         size_pop-=1
#     max_iter = trial.suggest_int("max_iter",100,2500)
#     mutation_rate=trial.suggest_float("prob_mut",0.001,0.5)
#     ga=GA(func=objective_function,n_dim=solution_num,size_pop=size_pop,max_iter=max_iter,lb=[0]*solution_num,ub=[ebv.shape[0]]*solution_num,prob_mut=mutation_rate)
#     best_x,best_y=ga.run()
#     return best_y
# to=time.time()
# study=optuna.create_study(direction='minimize')
# study.optimize(objective_for_optuna,n_trials=25)
# print(study.best_params)
# print(study.best_value)
# t1=time.time()
# print("run time{}".format(t1-to))
