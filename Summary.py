'''
Created on Mar 25, 2014

@author: longtle
'''
import numpy as np

def summary(listOfFiles, listOfAlgos):
    eigenChange = []
    finalChange = []
    for fileName in listOfFiles:
            
        mat = np.loadtxt(fileName, delimiter = ',', skiprows = 1)
        origHighestLambda = abs(mat[0, 4].astype(float))
        newLambdaOne = abs(mat[:, 10].astype(float))
        percentChange = [100.0 * (origHighestLambda - p)/origHighestLambda for p in newLambdaOne]
        eigenChange.append(percentChange)
        finalChange.append(percentChange[-1])
    return finalChange

if __name__ == '__main__':
    trainNet= 1
    testNet = 2
    listOfFiles = ['./data/eigenvalue-recompute/' + str(testNet) + '_del_1000.csv',
                   './data/eigenvalue-recompute/' + str(testNet) + '_del_1000_recompute.csv',
                   './data/test-lambda-feat/' + str(testNet) + '-from-' + str(trainNet) + '-topK.csv',
                   './data/test-lambda-role/' + str(testNet) + '-from-' + str(trainNet) + '-topK.csv']
    print 'listOfFile: ', listOfFiles
    
    listOfAlgos = ['NetMelt', 'NetMelt+', 'FeatLearn', 'RoleLearn']
    
    finalChange = summary(listOfFiles, listOfAlgos)
    print "When deleting 1000 edges, % drop of leading eigenvalue are:"
    for i in range (0, len(finalChange)):
        print listOfAlgos[i], ": ", finalChange[i],'(%)'
    pass