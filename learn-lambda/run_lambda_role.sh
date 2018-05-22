#!/bin/sh

#This file contains steps in LearnLambda: build the training set, and regression and evaluate the list of edge that we pick. Change input graph by modifying TRAIN and TEST variable

JAVA=java

MATLAB=matlab
WEKA=weka.jar

TRAIN=(1 2) #List of training network
TEST=(1 2)  #List of testing network (program evaluates all pair train-test or (n,2) pairs)

DIR="../data"


EIGEN_TRAIN=${DIR}/eigenvalue-recompute/
ROLE_DIR=${DIR}/role/
ROLE_TL_DIR=${DIR}/role-tl/
NET_DIR=${DIR}/network/

k=1000
nTrains=1000
ADD_DEL="del"

ROLEFEAT=0 #0 is Role, 1 is features generated by RefeX (different from 7 ego features). Role performs better
EgOrEv=1 # 0s is eigenScore, 1 is eigendrop. Eigen-drop performs better than eigen-score


#According to our experiment, a training set with edges selected by NetMelt+ and random performs best
selectMeltRe=1 #Whether we build training from NetMelt+
selectRand=1 #Whether we build training from random selected edges


TRAIN_DIR=${DIR}/train-lambda-role/
echo "TRAIN_DIR " ${TRAIN_DIR}
TEST_DIR=${DIR}/test-lambda-role/

echo "Test Dir: " ${TEST_DIR}


###############
#Build training
###############
for trainNet in "${TRAIN[@]}"
do
    #echo "Training Network" ${trainNet}

    meltFileRe=${EIGEN_TRAIN}${trainNet}_${ADD_DEL}_1000_recompute.csv
    #echo "MeltRe File:" ${meltFileRe}

	randFile=${EIGEN_TRAIN}${trainNet}_${ADD_DEL}_1000_recompute_random.csv
	#echo "Random File:" ${randFile}

	idFile=${ROLE_DIR}${trainNet}-out-ids.txt
    echo "ID File:" ${idFile}

    roleFile=${ROLE_DIR}${trainNet}-out-nodeRoles.txt
    nRole=$(awk '{print NF}' ${roleFile} | sort -nu | head -n 1)
    echo "nRole: " ${nRole}

    fullHeader=''
    for i in $(seq 1 ${nRole});do fullHeader+=srcRole${i},; done; for i in $(seq 1 ${nRole});do fullHeader+=dstRole${i},; done; fullHeader+=predictor_eigendrop;
    echo "Header: " ${fullHeader}

    echo "Role File: " ${roleFile}
    echo "Full Header " ${fullHeader}



    trainFile=${TRAIN_DIR}${trainNet}-train.csv #store training of eigendrop
    arrfTrain=${TRAIN_DIR}${trainNet}-train.arff
    echo "Train File: " ${trainFile}


	#Build the training set:
    ${MATLAB} -nodisplay -r "fn = cell(2,1); fn{1}= '${meltFileRe}'; fn{2} = '${randFile}'; fn; sl = [${selectMeltRe}, ${selectRand}]; sl ;[ETrain, XTrain, YTrain] = BuildTrain2('${idFile}', '${roleFile}', ${ROLEFEAT}, fn, sl, ${EgOrEv}, ${nTrains}); matTrain = [XTrain, YTrain]; SaveData('${trainFile}', matTrain, '${fullHeader}');quit;"

	#Convert to .csv file
    java -Xmx4G -cp ${WEKA} weka.core.converters.CSVLoader ${trainFile} > ${arrfTrain} 2>&1
done

###############


###############
#Lambda Transfer learning
###############

for trainNet in "${TRAIN[@]}"
do
    echo "Training Network" ${trainNet}
    arrfTrain=${TRAIN_DIR}${trainNet}-train.arff
	echo 'arrfTrain' ${arrfTrain}

    nRole=$(awk '{print NF}' ${roleFile} | sort -nu | head -n 1)

    fullHeader=''
    for i in $(seq 1 ${nRole});do fullHeader+=srcRole${i},; done; for i in $(seq 1 ${nRole});do fullHeader+=dstRole${i},; done; fullHeader+=predictor_eigendrop;

    for testNet in "${TEST[@]}"
    do
        if [ ${trainNet} -eq ${testNet} ]; then
            echo "Same graph"
            continue
        fi

        echo "Test on: " ${testNet} "from traning network" ${trainNet}
        edgeFile=${EIGEN_TRAIN}${testNet}_eigenScore.csv
        #echo "Edge file " ${edgeFile}
        idTestFile=${ROLE_DIR}${testNet}-out-ids.txt
        #echo "idTestFile " ${idTestFile}
        if [ ${ROLEFEAT} -eq 0 ]; then
            roleTestFile=${ROLE_TL_DIR}${testNet}-from-${trainNet}-out-nodeRoles.txt
            #echo "Role of Test File" ${roleTestFile}
        else
            roleTestFile=${ROLE_TL_DIR}${testNet}-from-${trainNet}-out-featureValues.csv
            #echo "Role of Test File" ${roleTestFile}

        fi
        testFile=${TEST_DIR}${testNet}-from-${trainNet}-test.csv

        #Build the testing set
        ${MATLAB} -nodisplay -r "[ETest, XTest, YTest] = BuildTest2('${edgeFile}', '${idTestFile}', '${roleTestFile}', ${ROLEFEAT}); matTest = [XTest, YTest]; SaveData('${testFile}', matTest, '${fullHeader}');quit;"

        #Convert to arrf file
        arrfTest=${TEST_DIR}${testNet}-from-${trainNet}-test.arff
        #echo 'arrfTest' ${arrfTest}
        java -Xmx4G -cp ${WEKA} weka.core.converters.CSVLoader ${testFile} > ${arrfTest} 2>&1
		

        #Use bag of REP Trees
        csvReg=${TEST_DIR}${testNet}-from-${trainNet}-pred.csv
        echo 'reg file' ${csvReg3}
        java -Xmx4G -cp weka.jar weka.classifiers.meta.Bagging -P 100 -S 1 -num-slots 1 -I 100 -W weka.classifiers.trees.REPTree -t ${arrfTrain} -T ${arrfTest} -classifications "weka.classifiers.evaluation.output.prediction.CSV -p first-last -decimals 10 -file ${csvReg}"

        #find the list of edge to delete and compute leading eigenscore
        graphFile=${NET_DIR}${testNet}.csv
        echo "Graph file " ${graphFile}

        egChangeFile=${TEST_DIR}${testNet}-from-${trainNet}-topK.csv
        echo "Eigenvalue change file " ${egChangeFile}

        #We can save time by changing: IE_DeltaLam_GivenT(A, T , 1, 0, 0) ---> IE_DeltaLam_GivenT(A, T , 10, 0, 0)
        ${MATLAB} -nodisplay -r "T = PickEdge('${edgeFile}', '${csvReg}', ${k}); A = ReadGraph('${graphFile}'); [eigenScore, eigenGap]=IE_DeltaLam_GivenT(A, T , 1, 0, 0); SaveData('${egChangeFile}', [T, eigenScore, eigenGap], 'src, dst, eigenScore, eigenValueDrop,lambda1, lambda2, lambda3, lambda4, lambda5, lambda6, nlambda1, nlambda2,nlambda3,nlambda4, nlambda5, nlambda6'); quit";

    done #for testNet
done #for trainNet
################
