#!/bin/sh

for trainNet in 1 2
do
    echo "Training Network" ${trainNet}

    rolxCMD="./run_rolx.sh ${trainNet}"
    echo $rolxCMD
    $rolxCMD

    for learnNet in 1 2
    do
        if [ ${trainNet} -eq ${learnNet} ]; then
            echo "Same graph"
        else
            echo "Transfer to: " ${learnNet} "from traning network" ${trainNet}
            roletransferCMD="./run_transfer.sh ${learnNet} ${trainNet}"
            echo $roletransferCMD
            $roletransferCMD
        fi
    done
done