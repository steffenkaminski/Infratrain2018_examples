#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4

#example of slide 56-57 using loops for finding marked equilibrium

using JuMP
using Ipopt

abs_err = 0.0001
num_producer = 3
a = 10
c = ones(num_producer) * 1

q_last = []
collection_profits = []
collection_q = []
err = 10 #just a initialization
i=1
q_last =  ones(num_producer) * 0.0 #just a initialization value
while err > abs_err
    err = 0
    for producer in 1:num_producer
        global m = Model(solver=IpoptSolver())
        global q=@variable(m, q[1:num_producer] >= 0)

        #fixing profit of all other producers
        if i != 1
            println( "i is $(i)")
            println(q_last)
            for k in 1:num_producer
                if k != producer
                    #fix profits of other producers
                    @constraint(m, q[k] == q_last[k])
                end
            end
        end
        #@constraint(m, q2val, q[2] == 2.5)

        global profits = @NLexpression(m, profit[i in 1:num_producer], (a-sum(q[j] for j in 1:num_producer))*q[i] - c[i]*q[i])
        @NLobjective(m, Max, profit[producer])
        solve(m)
        #println("Profit is $(getvalue(profit))" )

        #getting profit of all pruducers
        @show q_current = getvalue(q[:])
        @show err = err + abs( q_last[producer] -  q_current[producer]) ;
        q_last = getvalue(q)
    end
    push!(collection_profits, getvalue(profits))
    push!(collection_q, getvalue(q))
    i+=1
end

# println(collection_q)
# println(collection_profits)

for i in 1:length(collection_q)
    println(" $(i) iteration. q: $(collection_q[i]), profit: $(collection_profits[i])")
end
