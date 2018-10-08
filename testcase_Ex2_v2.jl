#steffen.kaminski@kuleuven.be
#software used: Atom, Julia 0.6.4, PATH Solver

# example from slide 46 version 2 (defining equations line by line)

#including packages
using Complementarity
using JuMP

## Same model in a more readable representation
m2=MCPModel()

#adding variables
x1=@variable(m2,x1 >= 0)
x2=@variable(m2,x2 >= 0)
y1 =@variable(m2,y1)

#setting up camplementary equations
F1=@mapping(m2, map1, x1 + x2)
F2=@mapping(m2, map2, x1 - y1)
F3=@mapping(m2, map3, x1 + x2 + y1 - 2)
@complementarity(m2, map1, x1)
@complementarity(m2, map2, x2)
@complementarity(m2, map3, y1)

#soving model
@show status = solveMCP(m2)

#accessing solved model values
println("x1 is $(getvalue(x1))")
println("x2 is $(getvalue(x2))")
println("y1 is $(getvalue(y1))")
