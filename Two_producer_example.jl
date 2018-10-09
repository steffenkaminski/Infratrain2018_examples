using JuMP
using Gurobi
m= Model(solver=GurobiSolver())

@variable(m, q[1:2] >= 0)
a = 10
c = [1 1]

@expression(m, profit1, (a-sum(q))*q[1] - c[1]*q[1])
@expression(m, profit2, (a-sum(q))*q[2] - c[2]*q[2])

@objective(m, :Max, profit1 + profit2)

solve(m)
@show getvalue(q)
println("Price is $(a-sum(getvalue(q)))" )
println("Profit 1 is $(getvalue(profit1))" )
println("Profit 2 is $(getvalue(profit2))" )
println("Price is $(a-sum(getvalue(q)))" )
