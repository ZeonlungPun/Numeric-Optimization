import numpy as np
import pandas as pd
import geatpy as ea
import time

to=time.time()
ebv=np.array(pd.read_csv('/home/kingargroo/geneticalgroithm/ebvt.csv'))
sample_num=ebv.shape[0]
ebv=ebv[:,3]
rel_mat=np.array(pd.read_csv('/home/kingargroo/geneticalgroithm/rel.csv'))
rel_mat=rel_mat[:,2::]
rel_mat[np.eye(rel_mat.shape[0],dtype=bool)]=0
solution_num=150

class MyProblem(ea.Problem):  # 继承Problem父类
    def __init__(self,lambd):
        name = 'MyProblem'  # 初始化name（函数名称，可以随意设置）
        M = 1  # 初始化M（目标维数）
        maxormins = [-1]  # 初始化maxormins（目标最小最大化标记列表，1：最小化该目标；-1：最大化该目标）
        Dim = solution_num  # 初始化Dim（决策变量维数）
        varTypes = [1] * Dim  # 初始化varTypes（决策变量的类型，元素为0表示对应的变量是连续的；1表示是离散的）
        lb = [0]*Dim  # 决策变量下界
        ub = [sample_num-1]*Dim  # 决策变量上界
        lbin = [1] * Dim  # 决策变量下边界
        ubin = [1] * Dim  # 决策变量上边界
        self.lambd=lambd
        # 调用父类构造方法完成实例化
        ea.Problem.__init__(self, name, M, maxormins, Dim, varTypes, lb, ub, lbin, ubin)

    def aimFunc(self, pop):  # 目标函数
        total=np.zeros((pop.Phen.shape[0],1))
        for i in range(pop.Phen.shape[0]):
            individual=pop.Phen[i,:]
            if len(np.unique(individual)) < solution_num:
                total[i]=-10000
            else:
                sub_mat=rel_mat[individual][:,individual]
                total[i]=np.mean(ebv[individual])-self.lambd*(np.sum(sub_mat)/(sub_mat.shape[0]**2-sub_mat.shape[0]))
        pop.ObjV = total  # 计算目标函数值，赋值给pop种群对象的ObjV属性


populationsize=150
Chrome=np.zeros((populationsize,solution_num))
for i in range(populationsize):
    Chrome[i]=np.random.permutation(sample_num)[:solution_num]
lamda_list=[0]
solutions=[]
objs=[]
for lambd in lamda_list:
    problem = MyProblem(lambd=lambd)
    # 构建算法
    # algorithm = ea.soea_EGA_templet(problem,
    #                                 ea.Population(Encoding='RI', NIND=populationsize),
    #                                 MAXGEN=1000,  # 最大进化代数
    #                                 logTras=10)  # 表示每隔多少代记录一次日志信息
    # # 求解
    # res = ea.optimize(algorithm, verbose=True, drawing=1, outputMsg=True, drawLog=False, saveFlag=True, dirname='result')

    algorithm = ea.soea_DE_currentToBest_1_bin_templet(
        problem,
        ea.Population(Encoding='RI', NIND=populationsize, Chrom=Chrome),
        MAXGEN=1500,  # 最大进化代数。
        logTras=10)  # 表示每隔多少代记录一次日志信息，0表示不记录。
    algorithm.mutOper.F = 0.7  # 差分进化中的参数F。
    algorithm.recOper.XOVR = 0.7  # 交叉概率。

    res = ea.optimize(algorithm,
                      verbose=True,
                      drawing=0,
                      outputMsg=True,
                      drawLog=True,
                      saveFlag=True)

    objs.append(res['ObjV'])
    solutions.append(res['Vars'])

ebv_values=[]
rel_values=[]

for solution in solutions:
    ebv_value=np.mean(ebv[solution])
    solution=solution.ravel()
    sub_mat = rel_mat[solution][:, solution]
    rel_value=np.sum(sub_mat)/(sub_mat.shape[0]**2-sub_mat.shape[0])
    ebv_values.append(ebv_value)
    rel_values.append(rel_value)

t1=time.time()
run_time=t1-to
print(run_time)
print(ebv_value)

# import matplotlib.pyplot as plt
# fig,ax1=plt.subplots()
# plt.plot(lamda_list,ebv_values)
# ax1.set_xlabel('lambda')
# ax1.set_ylabel('ebv')
# ax2=ax1.twinx()
#
#
# ax2.plot(lamda_list,rel_values,'*--')
# ax2.set_ylabel('relationship')
# #ax2.ylim((min(rel_values),max(rel_values)))
# plt.legend(['EBV','relation'])
# plt.show()
