#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4, PATH Solver

#first example from slide 46
using Complementarity
using JuMP

m=MCPModel()
#positive vars
X=@variable(m, X[1:2] >= 0 )
#free vars
Y=@variable(m, Y)
#concat vars for convenient access
xy=vcat(X,Y)
M = [
    1 1 0;
    1 0 -1;
    1 1 1;
    ]
q=[0 0 -2]

@mapping(m, map[i in 1:length(q)], sum(M[i,j]*xy[j] for j in 1:length(xy)) + q[i])
@complementarity(m, map, xy)

@show status = solveMCP(m)
@show getvalue(xy)
