include("dice2013.jl")

function getmarginal_dice_models(;emissionyear=2010)
    m1 = getdiceexcel()

    m2 = getdiceexcel()
    addcomponent(m2, adder, :marginalemission, before=:co2cycle)
    addem = zeros(60)
    addem[getindexfromyear_dice_2013(emissionyear)] = 1.0
    setparameter(m2, :marginalemission, :add, addem)
    connectparameter(m2, :marginalemission, :input, :emissions, :E)
    connectparameter(m2, :co2cycle, :E, :marginalemission, :output)

    run(m1)
    run(m2)

    return m1, m2
end
