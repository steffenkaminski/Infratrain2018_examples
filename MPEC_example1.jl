#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4, PATH Solver

using JuMP
using Ipopt
using Complementarity

## might need some doublechecking regarding KKTs

number_part = 3 #here leader is already included
m= Model(solver=IpoptSolver())

a = 10
b = 1
c = [1 for i in 1:number_part]

#first producer is leader, others are followers

@variable(m, q[1:length(c)])
@variable(m, cap[1:length(c)])

@NLobjective(m, Max, q[1]*(a - b*(sum(q[i] for i in 1:number_part)))-c[1]*q[1])

for j = 2:number_part
    @complements(m, 0 <= c[j] - a + b*sum(q[i] for i in 1:number_part) + b * q[j], q[j] >= 0)
    # c(i) - a + b*(sum(j,q(j))-q(i)) + b*Q_L + 2*b*q(i) #GAMS
end

solve(m)

@show Price = a - b*(sum(getvalue(q)));
@show Profit = Price*getvalue(q)- c.*getvalue(q);
@show getvalue(q)
