#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4, PATH Solver

## multi objective problem with equilibrium constraints.
#upper level: max CO2 reductions AND max tot surplus
#lower level: max profit of different gas-producers  (natural and conventional)


## CAUTION: THIS STUFF IS NOT WORKING REASONABLE YET. Somebody has to fix it at some point :-)


using JuMP
using Ipopt
using Complementarity
using Parameters
using Plots
Pkg.add("PlotlyJS")
plotlyjs()

num_ng = 3
num_bg = 3
a = 10
n = 20
gamma = [-43.915*((i-1)/(n-1)) - 38*(1-((i-1)/(n-1))) for i in 1:n];
gamma2 = [3.5*((i-1)/(n-1)) - 0*(1-((i-1)/(n-1))) for i in 1:n]
@with_kw immutable bg
    name::String="test"
    c::Real = 1
    capacity :: Real = 100
    t::Real=0                       #tax
    EF::Real = 0                #emissionfactor

end
@with_kw immutable ng
    name::String="test"
    c::Real = 1
    capacity :: Real = 100
    t::Real=1
    EF::Real = 0.48
end

#create some powerplants with default params
ngs = [ng() for i in 1:num_ng]
bgs = [bg() for i in 1:num_bg]
g = vcat(ngs, bgs)
#weigthed sums method
weight = 0:0.001:1
##
prices = []
taxes = []
emissions = []
social_welfares = []
for iter in 1:n
    m= Model(solver=IpoptSolver())

    @variable(m, q[i in 1:length(g)] >= 0) #production bio
    @variable(m, t >= 0) #tax

    @NLexpression(m, emissionseq, sum(g[i].EF * q[i] for i in 1:length(g)))
    @NLexpression(m, tot_surpluseq, -(sum((a-sum(q[i] for i in length(q)))*q[i] - g[i].c*q[i] for i in length(g)) + 0.5 * sum(q[i] for i in length(q))^2))
    # @NLobjective(m, Min, w * emissionseq + (1-w) * tot_surpluseq)
    @NLobjective(m, Min, tot_surpluseq)
    @NLconstraint(m, emissionseq <= gamma2[iter])

    for j = 1:length(g)
        @complements(m, 0 <= g[j].c - a + sum(q[i] for i in 1:length(g)) + q[j] + t, q[j] >= 0)
    end
    solve(m)
    emission = getvalue(emissionseq)
    social_welfare = -getvalue(tot_surpluseq)
    price =  a - 1*(sum(getvalue(q)))
    tax = getvalue(t)
    push!(prices, price)
    push!(emissions, emission)
    push!(social_welfares, social_welfare);
    push!(taxes, tax)
end

gui()
# plot(emissions, social_welfares, xlabel = "emissions", ylabel = "social welfare" )
# plot(taxes, prices, xlabel = "Tax", ylabel = "Price" )
