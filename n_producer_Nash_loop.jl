using JuMP
using Ipopt
using Gurobi

#!!!!not done jet!

abs_err = 0.0001
num_producer = 3
a = 10
c = ones(num_producer) * 1

##


#conloop
q_last = []
collection_profits = []
collection_q = []
# for i in 1:10
err = 10
i=1
q_last =  ones(num_producer) * 0.0
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
