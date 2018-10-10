#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4, PATH Solver

#MCP example of slide 56-57

using Complementarity
using JuMP

num_part = 2

alpha = 10
beta = 1
gamma = [1 1]
#init empty MCP model
m=MCPModel()

#adding variables to model
@variable(m, q[1:num_part] >=0)
# @variable(m, lambda[1:num_part] >=0)

@mapping(m, eq1[i in 1:num_part], gamma[i] - alpha + beta * sum(q[j] for j in 1:num_part) + beta * q[i])
@complementarity(m, eq1, q)

#solving model
@show status = solveMCP(m)

# accessing the solved model values
@show getvalue(q)
