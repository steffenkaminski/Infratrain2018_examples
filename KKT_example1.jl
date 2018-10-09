using Complementarity
using JuMP

#MCP example of slide 26
# here a tricky formulation is necessary as Complementarity package just takes:
# 0 <= a perpendicular b => 0 

#init empty MCP model
m=MCPModel()

#adding variables to model
X_p=@variable(m, X_p[1:2] >=0)
X_n=@variable(m, X_n[1:2] >=0)
X1 = @NLexpression(m, X1, X_p[1] - X_n[1])
X2 = @NLexpression(m, X2, X_p[2] - X_n[2])
#X= @variable(m, X[i in 1:2])

# init positive vars
U=@variable(m, U[1:2] >= 0 )

#stat
@mapping(m, stat1_p, -1 + U[1])
@mapping(m, stat1_n, 1 - U[1])
@mapping(m, stat2_p, - U[2] + U[1])
@mapping(m, stat2_n, U[2] - U[1])

@mapping(m, g1, -X1 - X2 + 1)
@mapping(m, g2, X2)


@complementarity(m, stat1_p, X_p[1])
@complementarity(m, stat1_n, X_n[1])
@complementarity(m, stat2_p, X_p[2])
@complementarity(m, stat2_n, X_n[2])

@complementarity(m, g1, U[1])
@complementarity(m, g2, U[2])

#solving model
@show status = solveMCP(m)

# accessing the solved model values
@show getvalue(X1)
@show getvalue(X2)
@show getvalue(U[1])
@show getvalue(U[2])
