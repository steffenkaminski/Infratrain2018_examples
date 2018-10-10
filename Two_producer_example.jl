#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4, PATH Solver
#slide 51 optimizing sum of profits 

using JuMP
using Ipopt
m= Model(solver=IpoptSolver())


@variable(m, q[1:2] >= 0)
a = 10
c = [1 1]
# @constraint(m, q2val, q[2] == 2.25) example for fixing quantity of producer 2

@NLexpression(m, profit1, (a-sum(q[i] for i in 1:2))*q[1] - c[1]*q[1])
@NLexpression(m, profit2, (a-sum(q[i] for i in 1:2))*q[2] - c[2]*q[2])

@NLobjective(m, Max, profit1 + profit2)

solve(m)
@show getvalue(q)
println("Price is $(a-sum(getvalue(q)))" )
println("Profit 1 is $(getvalue(profit1))" )
println("Profit 2 is $(getvalue(profit2))" )
println("Price is $(a-sum(getvalue(q)))" )
