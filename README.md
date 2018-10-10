
# some small examples
of InfraTrain 2018 using Julia's JuMP optimization framework with Complementarity package (https://github.com/chkwon/Complementarity.jl).
This examples are just meant to give a rough inside of how to use Julia's optimization and MCP framework.

software used:
* Atom IDE
* Julia 0.6.4
* PATH solver (http://pages.cs.wisc.edu/~ferris/path.html)

julia packages:
* Ipopt
* Gurobi
* JuMP
* Complementarity

packages can be installed via prompt in Julia's REPL 'Pkg.install("Packagename")'

```
julia> Pkg.installed("JuMP")
v"0.18.2"

julia> Pkg.installed("Complementarity")
v"0.4.0"

Pkg.installed("Ipopt")
v"0.4.1"

julia> Pkg.installed("Gurobi")
v"0.5.1"

julia> Pkg.installed("JuMP")
v"0.18.3"

julia> Pkg.installed("Complementarity")
v"0.4.0"

```
