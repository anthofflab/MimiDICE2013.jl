using Mimi
include("dice2013.jl")
using dice2013

run(DICE)

# Check model results
#getdataframe(DICE, :neteconomy, :DAMAGES)

explore(DICE)