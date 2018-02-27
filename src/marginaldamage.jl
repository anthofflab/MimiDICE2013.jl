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

function get_dice_scc(parameters; emissionyear=2010, discountrate=0.05)
    m1 = constructdice(parameters)
    m2 = constructdice(parameters)

    addcomponent(m2, adder, :marginalemission, before=:co2cycle)
    addem = zeros(60)
    addem[getindexfromyear_dice_2013(emissionyear)] = 1.0
    setparameter(m2, :marginalemission, :add, addem)
    connectparameter(m2, :marginalemission, :input, :emissions, :E)
    connectparameter(m2, :co2cycle, :E, :marginalemission, :output)

    run(m1)
    run(m2)

    scc = compute_scc(m1, m2, discountrate)

    return scc 
end

function compute_scc(m1, m2, discountrate)
    scc = 0
    
    # FRANK's SCC equation loop here:

    return scc
end 