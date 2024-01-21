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
    csvdata.load("/home/kingargroo/geneticalgroithm/breedingValueOptimization/GP22L.csv", arma::csv_ascii);
    csvdata=csvdata.submat(1,0,csvdata.n_rows-1,csvdata.n_cols-1);
    ebv_vector=csvdata.col(2);
    group_num=csvdata.col(1);
    rel_mat.load("/home/kingargroo/geneticalgroithm/breedingValueOptimization/REL.csv",arma::csv_ascii);
    rel_mat=rel_mat.submat(1,1,rel_mat.n_rows-1,rel_mat.n_cols-1);
    
    std::cout<<group_num<<std::endl;
  
}


int main()
{
    arma::mat rel_mat;
    arma::vec group_num,ebv_vector;
    ReadCSVData(rel_mat,group_num,ebv_vector);




    return 0;
}
