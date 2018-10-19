using Mimi

include("dice2013.jl")
using Dice2013

DICE = getdiceexcel()
run(DICE)

# Check model results
#getdataframe(DICE, :neteconomy, :DAMAGES)

explore(DICE)