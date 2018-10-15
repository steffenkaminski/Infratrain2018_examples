#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4

#EPEC example of slide 79-82 using loops for finding marked equilibrium
#for each iteration a MPEC is solved

#jacobian method is not working by some reason. Might be an starting value problem. 

using JuMP
using Complementarity
using Ipopt

#set param
num_leader = 2
num_follower = 1
num_producer = num_leader + num_follower
a = 10
c = ones(num_producer) * 1

#convergation options
abs_err = 0.0001
eta = 1 #used for weighting new leader quantites
use_jacobi_method = true

#init stuff
q_last = []
collection_profits = []
collection_q = []
err = 10 #just a initialization
i=1
q_last =  ones(num_producer) * 0.0 #just a initialization value

global q_last_jacobi
##
while err > abs_err
    err = 0
    for producer in 1:num_leader
        global m = Model(solver=IpoptSolver()) #using globals because of for-loop scope
        global q=@variable(m, q[1:num_producer] >= 0)

        #fixing profit of all other producers
        if i != 1
            println( "i is $(i)")
            println("q_last of this step $(q_last)")
            println("q_jacobi of this step $(q_last_jacobi)")
            for k in 1:num_leader #just fix quantities for leaders
                if k != producer
                    if use_jacobi_method
                        @constraint(m, q[k] == q_last_jacobi[k])
                    else
                        @constraint(m, q[k] == eta * q_last[k] + (1-eta) *q_last_last[k])
                    end
                end
            end
        end

        global profits = @NLexpression(m, profit[i in 1:num_producer], (a-sum(q[j] for j in 1:num_producer))*q[i] - c[i]*q[i])
        @NLobjective(m, Max, q[producer]*(a - (sum(q[i] for i in 1:num_producer)))-c[producer]*q[producer])
        for j = num_leader+1:num_producer
            @complements(m, 0 <= c[j] - a + sum(q[i] for i in 1:num_producer) + q[j], q[j] >= 0)
        end
        solve(m)

        #getting profit of all pruducers
        q_current = getvalue(q[:])
        err = err + abs( q_last[producer] -  q_current[producer]) ;
        global q_last_last = q_last
        global q_last = q_current
    end
    push!(collection_profits, getvalue(profits))
    push!(collection_q, getvalue(q))
    @show q_last_jacobi = getvalue(q)
    i+=1
end

#show iteration results
for i in 1:length(collection_q)
    println(" $(i) iteration. \t q: $(collection_q[i]) \t profit: $(collection_profits[i])")
end
