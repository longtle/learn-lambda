function [A] = ReadGraph(filename)
%Given a list of edges, we read the graph
edges = csvread(filename);
A  = sparse(edges(:,1), edges(:,2), edges(:,3));
end
