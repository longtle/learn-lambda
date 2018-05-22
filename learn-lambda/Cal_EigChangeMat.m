function [lam, newLam, deltaLam] = Cal_EigChangeMat(A, ANew)

lam = eigs(A);

newLam = eigs(ANew);
deltaLam = abs(newLam(1)) - abs(lam(1));