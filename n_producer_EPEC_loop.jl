#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4

#EPEC example of slide 79-82 using loops for finding marked equilibrium
#for each iteration a MPEC is solved

using JuMP
using Complementarity
using Ipopt

abs_err = 0.001
num_leader = 4
num_follower = 1
num_producer = num_leader + num_follower
a = 10
c = ones(num_producer) * 1

q_last = []
collection_profits = []
collection_q = []
err = 10 #just a initialization
i=1
q_last =  ones(num_producer) * 0.0 #just a initialization value

##
while err > abs_err
    err = 0
    for producer in 1:num_producer
        global m = Model(solver=IpoptSolver()) #using globals because of for-loop scope
        global q=@variable(m, q[1:num_producer] >= 0)

        #fixing profit of all other producers
        if i != 1
            println( "i is $(i)")
            println(q_last)
            for k in 1:num_leader #just fix quantities for leaders
                if k != producer
                    @constraint(m, q[k] == q_last[k])
                end
            end
        end
        #@constraint(m, q2val, q[2] == 2.5)

        global profits = @NLexpression(m, profit[i in 1:num_producer], (a-sum(q[j] for j in 1:num_producer))*q[i] - c[i]*q[i])
        @NLobjective(m, Max, q[producer]*(a - (sum(q[i] for i in 1:num_producer)))-c[producer]*q[producer])
        for j = num_leader+1:num_producer
            @complements(m, 0 <= c[j] - a + sum(q[i] for i in 1:num_producer) + q[j], q[j] >= 0)
            # c(i) - a + b*(sum(j,q(j))-q(i)) + b*Q_L + 2*b*q(i) #GAMS
        end
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

#show iteration results
for i in 1:length(collection_q)
    println(" $(i) iteration. \t q: $(collection_q[i]) \t profit: $(collection_profits[i])")
end
