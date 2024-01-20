#include <memory>
#include <vector>
#include <armadillo>
#include <iostream>
#include "ortools/base/logging.h"
#include "ortools/linear_solver/linear_solver.h"
using namespace operations_research;

arma::mat ReadCSVData(std::string csvpath)
{
  // 創建 Armadillo 矩陣來存儲數據
  arma::mat csv_data;

  // 使用 load() 函數從 CSV 文件中加載數據
  // 注意：CSV文件應該包含沒有列名的純數據
  csv_data.load(csvpath, arma::csv_ascii);
  csv_data=csv_data.submat(1,1,csv_data.n_rows-1,csv_data.n_cols-1);
  //std::cout<<csv_data<<std::endl;
  return csv_data;
}



int main()
{
  std::string csvpath="/home/punzeonlung/CPP/ortest/buying_books_opt.csv";
  arma::mat csv_data=ReadCSVData(csvpath);
  arma::mat BookFee=csv_data.submat(0,0,csv_data.n_rows-1,csv_data.n_cols-2);
  arma::vec DeliveryFee=csv_data.col(csv_data.n_cols - 1);
  int BookstoreNum=BookFee.n_rows;
  int BookNum=BookFee.n_cols;
  //std::cout<<BookstoreNum<<std::endl;
  //std::cout<<BookNum<<std::endl;

  // Create the mip solver with the SCIP backend.
  std::unique_ptr<MPSolver> solver(MPSolver::CreateSolver("SCIP"));

  std::vector<std::vector<MPVariable*>>VariableVectors;
  // add the variabels and set the coefficient of objective function
  MPObjective* const objective = solver->MutableObjective();
  for(int i=0;i<BookstoreNum;i++)
  {
    std::vector<MPVariable*>VariableVector;
    for (int j=0;j<BookNum;j++)
    {
      // 將數字轉換為字符串，然後拼接成所需的格式
      std::string xstr = "x_" + std::to_string(i) + "_" + std::to_string(j);
      MPVariable* const x_ =solver->MakeIntVar(0, 1, xstr);
      VariableVector.push_back(x_);
      
      double BookFee_= BookFee.at(i,j);
      double DeliveryFee_= DeliveryFee.at(i);
      objective->SetCoefficient(x_,BookFee_+DeliveryFee_);
    }
    VariableVectors.push_back(VariableVector);
  }
  LOG(INFO) << "Number of variables = " << solver->NumVariables();
  objective->SetMinimization();

  //add the constrains: each kind of books only bought once
  for (int j=0;j<BookNum;j++)
  {
    //upper bound and lower bound are both 1
    auto constraint = solver->MakeRowConstraint(1.0, 1.0);
    for (int i = 0; i < BookstoreNum; i++)
    {
      constraint->SetCoefficient(VariableVectors[i][j], 1.0);
    }
  }
  LOG(INFO) << "Number of constraints = " << solver->NumConstraints();

  const MPSolver::ResultStatus result_status = solver->Solve();
  // Check that the problem has an optimal solution.
  if (result_status != MPSolver::OPTIMAL) {
    LOG(FATAL) << "The problem does not have an optimal solution!";
  }

  LOG(INFO) << "Solution:";
  LOG(INFO) << "Objective value = " << objective->Value();

  for (int i=0;i<BookstoreNum;i++ )
  {
    for (int j=0;j<BookNum;j++)
    {
      if (VariableVectors[i][j]->solution_value()!=0)
      {
        std::string xxstr = "x_" + std::to_string(i) + "_" + std::to_string(j);
        std::cout<<xxstr+"=" << VariableVectors[i][j]->solution_value() <<std::endl;
      }
    
    }
  }



  return 0;
}