# learn-lambda
============================================================================
Filename: Readme.txt
Author: Long T. Le
Scribes: Long Le and Tina Eliassi-Rad, Rutgers University
Contact: {longtle, eliassi}@cs.rutgers.edu
Content: How to run LearnLambda
Disclaimer:  This is research prototype code.  It does not have the niceties of a properly engineered code.
============================================================================

***** Preliminaries *****

System requirement:
	* Matlab: 2013b 
	* Java/Javac: 1.6
	* Python: 2.7.5
	* Numpy: 1.7.1 (build on Python 2.7)
	* Weka: 3.7.10 (weka.jar is included in this release)

Before running the code, please make sure that the paths for matlab, java, and python are set properly. Otherwise, you have to modify the paths for them in the following files:

	(1) ./run.sh
	(2) ./feat/run.sh                      
	(3) ./learn-lambda/run_lambda_role.sh  
	(4) ./refex-role/run_rolx.sh  
	(5) ./refex-role/run_transfer.sh
	(6) ./learn-lambda/run_lambda_feat.sh  
	(7) ./netmelt-plus/run.sh              
	(8) ./refex-role/run.sh

The ./run.sh file calls multiple scripts in the subfolders sequentially.  Its last call is to the file ./Summary.py, which summarizes the outputs of the different algorithms.  

Note: The LearnLambda code was tested on Mac OS only.

***** Sample Data ****

The ./data/network/ folder has four sample graph files from the Oregon Autonomous Systems data set:

	* 1.csv: undirected graph with 2,172 edges
	* 2.csv: undirected graph with 5,620 edges
	* 1-large.csv: undirected graph with 46,818 edges
	* 2-large.csv: undirected graph with 61,168 edges
	
The format for these files is as follows:

	source_node_id, destination_node_id, edge_weight
	
In all four of the aforementioned data files, the edge weights are set to 1.

To run experiments with your graphs, we strongly recommend that you copy them to the ./data/network/ folder and rename them to 1.csv and 2.csv.  Alternatively, you can put your graphs in the ./data/network/ folder and modify the appropriate parameters in the code.

***** LearnLambda Framework *****
We describe LearnLambda's three steps below.  Our description includes where to modify the hard-coded parameters.

__ Step I. Extracting roles (uses the code in the ./refex-role/ folder) and social-theory based structural features (uses the code in the ./feat/ folder)

Step I.1. Run ./refex-role/run.sh.

Given two graphs, this step runs ReFeX [Henderson et al. KDD 2011] and RolX [Henderson et al. KDD 2012] on the input graphs and makes sure the two graphs are mapped into the same role space.

This step reads the graphs ./data/1.csv and ./data/2.csv; and outputs these files:

	* Refex features and RolX roles in the ./data/role/ folder 
	* Role transfer files (such as 2-from-1-out-nodeRoles.txt) in the ./data/role-tl/ folder

You can change the input graphs by modifying trainNet (line 3) & learnNet (line 11) in run.sh 
 
Step I.2. Run ./feat/run.sh. 

For a given graph, this script extracts these seven local- and egonet-based structural features [Berlingerio et al. ASONAM 2013]:

	* # of neighbors 
	* clustering coefficient
	* avg. # of neighbors’ neighbors
	* avg. clustering coeff. of neighbors
	* edges in egonet
	* outgoing edges from egonet
	* # of neighbors of egonet

This step reads the graphs ./data/1.csv and ./data/2.csv; and outputs four output files in the ./data/net-simile/ folder:

	* 1_vals: contains feature values for the aforementioned structural features
	* 1_ids: IDs of nodes in the ./data/1.csv graph
	* 2_vals: contains feature values for the aforementioned structural features
	* 2_ids: IDs of nodes in the ./data/2.csv graph
	
You can change the names of the input graphs by modifying line 10 in the file ./feat/GetNetSimileValues.py.

__Step II. NetMelt+ (uses the code in the ./netmelt-plus/ folder)

Run ./netmelt-plus/run.sh. 

This step reads the input graph ./data/1.csv and produces four files in folder /data/eigenvalue-recompute/: 

	* 1_del_1000.csv: the list of 1000 edges selected by NetMelt (for comparison purposes)
	* 1_del_1000_recompute.csv: the list of 1000 edges selected by NetMelt+
	* 1_del_1000_recompute_random.csv: the list of 1000 edges selected randomly
	* 1_eigenscore.csv: the eigenscores of all edges (we don't use eigenscore in regression)
	
You can change the names of the input graphs by modifying parameter “i” in ./netmelt-plus/MainRecompute.m, ./netmelt-plus/MainRandom.m, and ./netmelt-plus/MainEigenscore.m.

__Step III. learn-lambda (uses the code in the ./learn-lambda/ folder)

Run ./learn-lambda/run_lambda_role.sh and ./learn-lambda/run_lambda_feat.sh scripts.

These two scripts in ./learn-lambda/ build the training set (based on roles or features), run regression, pick the top-K edges, and compute the eigen-drop resulting from deleting these top-K edges.

There are multiple output files in this step; but the final output files are:

	* ./data/test-lambda-role/x-from-y-topK.csv
	* ./data/test-lambda-feat/x-from-y-topK.csv 
	
where x is the test graph, and y is train graph. These two CSV files list the top-K edges selected by LearnLambda algorithms. The format for these CSV files is as follows: 

	source_node_id, destination_node_id, netmelt_edge_eigenscore, edge_eigendrop, etc
	
The etc above refers to other columns such as the top-6 eigenvalues of the graph before and after removing the edge.  We imagine that most users will be interested only in the aforementioned four columns.  The x-from-y-topK.csv output files include headers.

You can change the names of the input graphs by modifying the parameters TRAIN and TEST in lines 10 and 11 of ./learn-lambda/run_lambda_role.sh and ./learn-lambda/run_lambda_feat.sh scripts.
