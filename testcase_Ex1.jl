#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4, PATH Solver

#first example from slide 45
using Complementarity
using JuMP

m=MCPModel()
@variable(m, X[1:2] >= 0 )

M = [-1 1; 0 1]
q = [0; -3]

@mapping(m, map[i in 1:2], sum(M[i,j]*X[j] for j in 1:2) + q[i])
@complementarity(m, map, X)

@show status = solveMCP(m)
@show getvalue(X)
