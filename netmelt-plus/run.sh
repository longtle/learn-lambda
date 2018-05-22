#!/bin/sh

#Find a set of edges selected by NetMelt+ and Random

MATLAB=matlab

#Call NetMelt/NetMelt+: Change the parameter i in MainRecompute.m to select input graph
${MATLAB} -nodisplay -r "MainRecompute; quit"

#Find the list of random edges: Change the parameter i in MainRecomputeRandom.m to select input graph
${MATLAB} -nodisplay -r "MainRandom; quit"

#Find the list of random edges: Change the parameter i in MainRecomputeRandom.m to select input graph.
#The eigenscore is for reference(ie, we don't use eigenscore as predictor). But we use the edges list.
${MATLAB} -nodisplay -r "MainEigenscore; quit"