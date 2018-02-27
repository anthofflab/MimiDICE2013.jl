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

function get_dice_scc(; discount_type=:Constant, emissionyear=2010, constant=0.03, eta=1.5, prtp=0.015, clim_sens=nothing, parameters=nothing)

    # Get base and marginal versions of dice
    if parameters==nothing # Default use of Excel parameters
        base = getdiceexcel()
        marginal = getdiceexcel()
    else
        base = constructdice(parameters)
        marginal = constructdice(parameters)
    end 

    # Override standard parameter settings with climate sensitivity, if provided
    if clim_sens!=nothing
        setparameter(base, :climatedynamics, :t2xco2, clim_sens)
        setparameter(marginal, :climatedynamics, :t2xco2, clim_sens)
    end 

    # Add the emissions pulse
    addcomponent(marginal, adder, :marginalemission, before=:co2cycle)
    addem = zeros(60)
    addem[getindexfromyear_dice_2013(emissionyear)] = 1.0
    setparameter(marginal, :marginalemission, :add, addem)
    connectparameter(marginal, :marginalemission, :input, :emissions, :E)
    connectparameter(marginal, :co2cycle, :E, :marginalemission, :output)

    # Run the models
    run(base)
    run(marginal)

    # Extract damages
    marginal_damages = marginal[:damages, :DAMAGES] - base[:damages, :DAMAGES]

    # Discounting set up
    if discount_type == :Constant
        # caculate constant discounting
    elseif discount_type == :Ramsey
        # calculate Ramsey discounting
    else
        error("Discount of type $discount_type not supported.")
    end 

    # Calculate SCC
    scc = sum(discounted_damages)

    return scc 
end
