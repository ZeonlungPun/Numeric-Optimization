#include <memory>
#include <vector>
#include <iostream>
#include "ortools/base/logging.h"
#include "ortools/linear_solver/linear_solver.h"
#include <armadillo>

using namespace operations_research;


void ReadCSVData(arma::mat&rel_mat,arma::vec& group_num,arma::vec& ebv_vector)
{
    arma::mat csvdata;
    csvdata.load("/home/punzeonlung/CPP/EBV/GP22L.csv", arma::csv_ascii);
    csvdata=csvdata.submat(1,0,csvdata.n_rows-1,csvdata.n_cols-1);
    ebv_vector=csvdata.col(2);
    group_num=csvdata.col(1);
    rel_mat.load("/home/punzeonlung/CPP/EBV/REL.csv",arma::csv_ascii);
    rel_mat=rel_mat.submat(1,1,rel_mat.n_rows-1,rel_mat.n_cols-1);
    
    arma::mat eyeMat = arma::eye<arma::mat>(rel_mat.n_rows, rel_mat.n_cols);
    rel_mat.elem(find(eyeMat == 1)).fill(0);
    
    //std::cout<<group_num<<std::endl;
  
}


void OneTrial(float lambda, float& mean_ebv,float& mean_rel)
{
    arma::mat rel_mat;
    arma::vec group_num,ebv_vector;
    ReadCSVData(rel_mat,group_num,ebv_vector);
    int sample_num=rel_mat.n_rows;
    int solution_num=2000;
    std::unique_ptr<MPSolver> solver(MPSolver::CreateSolver("SCIP"));
    
    std::vector<std::vector<MPVariable*>>VariableVectors;
    MPObjective* const objective = solver->MutableObjective();

    //set objective function
    for (int i=0;i<sample_num;i++)
    {
        std::vector<MPVariable*>VariableVector;
        for (int j=i+1;j< sample_num;j ++)
        {
            std::string xstr = "x_" + std::to_string(i) + "_" + std::to_string(j);
            MPVariable* const x_ =solver->MakeIntVar(0, 1, xstr);
            VariableVector.push_back(x_);
            double ebv_= ebv_vector.at(i)+ebv_vector.at(j);
            double rel_= rel_mat.at(i,j);
            double rij=ebv_-lambda*rel_;
            objective->SetCoefficient(x_,rij);

        }
        VariableVectors.push_back(VariableVector);
    }

    LOG(INFO) << "Number of variables = " << solver->NumVariables();
    objective->SetMaximization();
    const double infinity = solver->infinity();

    //add constrain : \sigma_i x_ij<= g 
    for (int i=0;i<sample_num;i++)
    {
        // i th row
        double upper_bound=group_num.at(i);
        auto constraint1 = solver->MakeRowConstraint(-infinity,upper_bound);
        for (int j=0;j<VariableVectors[i].size();j++)
        {
            constraint1->SetCoefficient(VariableVectors[i][j], 1.0);
        }

    }

    //add constrain : \sigma_j x_ij<= g
    int init_col_num=VariableVectors.size();
    for (int j=0;j<sample_num;j++)
    {
        //j th column
        double upper_bound_=group_num.at(j);
        auto constraint2 = solver->MakeRowConstraint(-infinity,upper_bound_);
        for (int i=0;i<sample_num-j-1 ;i++)
        {
            constraint2->SetCoefficient(VariableVectors[i][j], 1.0);
        }
        init_col_num=init_col_num-1;

    }
    
    //add constrain : \sigma_i_\sigma_j x_ij<= solution_num-1
    MPConstraint* constraint = solver->MakeRowConstraint(-infinity, solution_num - 1);
    for (const std::vector<MPVariable*>& VariableVector : VariableVectors) {
        for (MPVariable* xij : VariableVector) {
            constraint->SetCoefficient(xij, 1);
        }
    }


    const MPSolver::ResultStatus result_status = solver->Solve();
    // Check that the problem has an optimal solution.
    if (result_status != MPSolver::OPTIMAL) {
    LOG(FATAL) << "The problem does not have an optimal solution!";
    }

    LOG(INFO) << "Solution:";
    LOG(INFO) << "Objective value = " << objective->Value();


    //get the final solution plan
   
    float total_count=0;
    for (int i=0;i<VariableVectors.size();i++)
    {
        
        for (int j=0;j<VariableVectors[i].size();j++)
        {
            double x_ = VariableVectors[i][j]->solution_value();
            if (x_!=0)
            {
                mean_ebv+=ebv_vector.at(i)+ebv_vector.at(j);
                mean_rel+=rel_mat.at(i,j);
                total_count+=1;

            }
            
        }
    }

    mean_ebv=mean_ebv/ (solution_num);
    //mean_rel=mean_rel/ (solution_num);

}


int main()
{
    std::vector<int> lambda_list = {0,  50, 100, 150, 200, 250};
    std::vector<double> ebv_list;
    std::vector<double> rel_list;

    for (const int lambd : lambda_list)
    {
        float mean_ebv=0;
        float mean_rel=0;
        OneTrial(lambd, mean_ebv,mean_rel);
        ebv_list.push_back(mean_ebv);
        rel_list.push_back(mean_rel);
        std::cout<<"lambda:"<<lambd<<std::endl;
        std::cout<<"1:"<<mean_ebv<<std::endl;
        std::cout<<"2:"<<mean_rel<<std::endl;

    }
  

    
    



    return 0;
}
