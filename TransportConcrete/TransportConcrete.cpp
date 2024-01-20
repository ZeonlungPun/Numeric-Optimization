#include <memory>
#include <vector>
#include <iostream>
#include "ortools/base/logging.h"
#include "ortools/linear_solver/linear_solver.h"
#include <armadillo>
using namespace operations_research;

arma::vec demand={3,5,4,7,6,11};
arma::vec supply={20,20};
arma::mat target_coordinates={{1.25,8.75,0.5,5.75,3,7.25},{1.25,0.75,4.75,5,6.5,7.75}};
arma::mat source_coordinates={{5,2},{1,7}};
int supplier_num=2;
int demander_num=6;

int main()
{
    std::unique_ptr<MPSolver> solver(MPSolver::CreateSolver("SCIP"));
    if (!solver) 
    {
        LOG(WARNING) << "SCIP solver unavailable.";
    }
    const double infinity = solver->infinity();
    std::vector<std::vector<MPVariable*>>VariableVectors;
    MPObjective* const objective = solver->MutableObjective();
    for (int i=0;i<supplier_num;i++)
    {   
        std::vector<MPVariable*>VariableVector;
        arma::vec source_coordinate=source_coordinates.col(i);
        for (int j=0;j<demander_num;j++)
        {
            std::string xstr = "x_" + std::to_string(i) + "_" + std::to_string(j);
            MPVariable* const x_ =solver->MakeNumVar(0, infinity, xstr);
            VariableVector.push_back(x_);
            arma::vec target_coordinate=target_coordinates.col(j);
            double distance = arma::norm(source_coordinate - target_coordinate);
            objective->SetCoefficient(x_,distance);
        }
        VariableVectors.push_back(VariableVector);
    }
    LOG(INFO) << "Number of variables = " << solver->NumVariables();
    objective->SetMinimization();

    //add demand constrain
   
    for (int i=0;i<supplier_num;i++)
    {
        double supply_=supply.at(i);
        auto constraint = solver->MakeRowConstraint(-infinity, supply_);
        for (int j=0;j<demander_num;j++)
        {
            constraint->SetCoefficient(VariableVectors[i][j], 1.0);
        }

    }

    //add supply constrain
    for (int j=0;j<demander_num;j++)
    {
        double demand_=demand.at(j);
        //equal constrain
        auto constraint_ = solver->MakeRowConstraint(demand_, demand_);
        for (int i = 0; i < supplier_num; i++)
        {
            constraint_->SetCoefficient(VariableVectors[i][j], 1.0);
        }
    }

    const MPSolver::ResultStatus result_status = solver->Solve();
    // Check that the problem has an optimal solution.
    if (result_status != MPSolver::OPTIMAL) {
    LOG(FATAL) << "The problem does not have an optimal solution!";
    }

    LOG(INFO) << "Solution:";
    LOG(INFO) << "Objective value = " << objective->Value();

    for (int i=0;i< supplier_num; i++ )
    {
        for (int j=0;j< demander_num; j++)
        {

            std::string xxstr = "x_" + std::to_string(i) + "_" + std::to_string(j);
            std::cout<<xxstr+"=" << VariableVectors[i][j]->solution_value() <<std::endl;
        }
    }
        
   
    return 0;

}



    