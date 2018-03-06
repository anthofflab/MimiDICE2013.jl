using Mimi

include("dice2013.jl")
using dice2013

m = dice2013.DICE

run(m)

# Check model results
getdataframe(m, :neteconomy, :DAMAGES)
