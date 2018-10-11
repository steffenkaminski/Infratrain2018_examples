# INFRATRAIN 2018 EXCERCISES DAY 1
# Date: 08.10.2018
# Author: Claudia Guenther

# ------------------------------------------------------------------------------
# load neceassry Julia packages (or add via Pkg.add())
# ------------------------------------------------------------------------------
#using Complementarity
#using JuMP
using PATHSolver

#### Pure Complementary Problem #####
#F1 = -x1 + x2 >= 0
#F2 = x2 - 3   >= 0

# Reformulate Problem to standard set up of PATHSolver package
# https://github.com/chkwon/PATHSolver.jl


M = [-1 1; 0 1]
q = [0.0;-3.0]

myfunc(x) = M*x + q

n = size(q)
lb = zeros(n)
ub = 10000*ones(n)
status, value1 = solveMCP(myfunc, lb, ub)

# Change initial values
x0 = [0.0, 3.0] # [x1, x2]

status, xinit, value2 = solveMCP(myfunc, lb, ub) # Careful: This does not seem to work

#### Mixed Complementary Problem #####
#F1.. x1 + x2 >= 0;
#F2.. x1 - y1 >= 0;
#F3.. x1 + x2 + y1 - 2 >= 0; y free

M = [1  1  0;
     1  0 -1;
     1  1  1]
q = [0;0;-2]

myfunc(x) = M*x + q

n = size(q)
lb = [0.0, 0, -100]
ub = 100*ones(n)
status, value3 = solveMCP(myfunc, lb, ub)

# Change initial values
x0 = [5.0,5.0,5.0] # [x1, x2,y]

status, xinit, value4 = solveMCP(myfunc, lb, ub, x0) # Careful: This does not seem to work
