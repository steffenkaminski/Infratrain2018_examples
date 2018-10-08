#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4, PATH Solver
#first example from slide 46 version 1 (using matrix)

#including packages
using Complementarity
using JuMP

#init empty MCP model
m=MCPModel()

# init positive vars
X=@variable(m, X[1:2] >= 0 )
#init free vars
Y=@variable(m, Y)
#concat vars for convenient access
xy=vcat(X,Y)

M = [
    1 1 0;
    1 0 -1;
    1 1 1;
    ]
q=[0 0 -2]

#setting cemplementary equations
@mapping(m, map[i in 1:length(q)], sum(M[i,j]*xy[j] for j in 1:length(xy)) + q[i])
@complementarity(m, map, xy)

#Solving model
@show status = solveMCP(m)
# accessing the solved model values
@show getvalue(xy)
