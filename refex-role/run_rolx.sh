#!/bin/sh

k_AS=$1

JAVA=java
JAVAC=javac
MATLAB=matlab

MEM_IN_MEGS=500

#input file
INFILE=../data/network/${k_AS}.csv #csv file with source,dest,weight records
OUTPUTDIR=../data/role

#parameter values
CORR_THRESH=0 #usually 0 -- this is the initial lattice error threshold
BIN_SIZE=0.5 #usually 0.5 -- this is the fraction in each bin

#output files
NODEFILE=${OUTPUTDIR}/${k_AS}-out-nodeRoles.txt #which node belongs to which role
ROLEFILE=${OUTPUTDIR}/${k_AS}-out-roleFeatures.txt #which features influenced each role

#feature files are prefixed with this
FEATFILE=${OUTPUTDIR}/${k_AS}-out
IDFILE=${OUTPUTDIR}/${k_AS}-out-ids.txt

${JAVA} -Xmx${MEM_IN_MEGS}M -jar ReFex.jar ${INFILE} ${CORR_THRESH} ${BIN_SIZE} ${FEATFILE}

${JAVAC} HuffmanComparator.java

echo Start matlab
date

${MATLAB} -nodisplay -r "javaaddpath('.'); W=load('${FEATFILE}-featureValues.csv'); IDs=W(:,1); save('${IDFILE}', 'IDs', '-ASCII'); [n,m] = size(W); V=W(1:n,2:m); [F,G]=NMF_MDL_Quantized(V); save('${NODEFILE}', 'G', '-ASCII'); save('${ROLEFILE}', 'F', '-ASCII'); quit;"

echo Done with matlab
date

echo Finished analysis
date