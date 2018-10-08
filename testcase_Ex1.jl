#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4, PATH Solver
#this file shows first example from slide 45

#including packages
using Complementarity
using JuMP

#init empty MCP model
m=MCPModel()

#adding variables to model
@variable(m, X[1:2] >= 0 )

M = [-1 1; 0 1]
q = [0; -3]

#setting up 2 complementary equation using matrix
@mapping(m, map[i in 1:2], sum(M[i,j]*X[j] for j in 1:2) + q[i])
@complementarity(m, map, X)

#solving model
@show status = solveMCP(m)

# accessing the solved model values
@show getvalue(X)
