#!/bin/sh

#Input: 2 graphs: ./data/network/1.csv & 2.csv
#Output:
    #./data./data/test-lambda-feat/2-from-1-topK.csv': feat-learn-lambda of graph 2 from graph 1
    #./data./data/test-lambda-role/2-from-1-topK.csv': role-learn-lambda of graph 2 from graph 1
    #NetMelt/NetMelt+ in ./data/eigenvalue-recompute

#Run NetMelt+/Rand on each graph
cd netmelt-plus
./run.sh
cd ..

#Run Refex, RolX, Role transfer
cd refex-role
./run.sh
cd ..

#Extract the 7 ego features
cd feat
./run.sh
cd ..

#Learn Lambda
cd learn-Lambda
./run_lambda_feat.sh
./run_lambda_role.sh
cd ..

#Summary the result
python Summary.py

