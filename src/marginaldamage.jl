include("dice2013.jl")
using dice2013

function getmarginal_dice_models(;emissionyear=2010)
    mm = MarginalModel(DICE)
    m1 = mm.base
    m2 = mm.marginal

    addcomponent(m2, adder, :marginalemission, before=:co2cycle)

    time = dimension(m1, :time)
    addem = zeros(length(time))
    addem[time[emissionyear]] = 1.0

    set_parameter!(m2, :marginalemission, :add, addem)
    connect_parameter(m2, :marginalemission, :input, :emissions, :E)
    connect_parameter(m2, :co2cycle, :E, :marginalemission, :output)

    run(m1)
    run(m2)

    return m1, m2
end

#
# Old way
#

# function getmarginal_dice_models(;emissionyear=2010)
#     m1 = getdiceexcel()

#     m2 = getdiceexcel()
#     addcomponent(m2, adder, :marginalemission, before=:co2cycle)
#     addem = zeros(60)
#     addem[getindexfromyear_dice_2013(emissionyear)] = 1.0
#     setparameter(m2, :marginalemission, :add, addem)
#     connectparameter(m2, :marginalemission, :input, :emissions, :E)
#     connectparameter(m2, :co2cycle, :E, :marginalemission, :output)

#     run(m1)
#     run(m2)

#     return m1, m2
# end
