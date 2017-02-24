using Mimi


@defcomp welfare begin
    CEMUTOTPER      = Variable(index=[time])    #Period utility
    CUMCEMUTOTPER   = Variable(index=[time])    #Cumulative period utility
    PERIODU         = Variable(index=[time])    #One period utility function
    UTILITY         = Variable()                #Welfare Function

    CPC             = Parameter(index=[time])   #Per capita consumption (thousands 2005 USD per year)
    l               = Parameter(index=[time])   #Level of population and labor
    rr              = Parameter(index=[time])   #Average utility social discount rate
    elasmu          = Parameter()               #Elasticity of marginal utility of consumption
    scale1          = Parameter()               #Multiplicative scaling coefficient
    scale2          = Parameter()               #Additive scaling coefficient
end


function run_timestep(state::welfare, t::Int)
    v = state.Variables
    p = state.Parameters

    #Define function for PERIODU
    v.PERIODU[t] = (p.CPC[t] ^ (1 - p.elasmu) - 1) / (1 - p.elasmu) - 1

    #Define function for CEMUTOTPER
    v.CEMUTOTPER[t] = v.PERIODU[t] * p.l[t] * p.rr[t]

    #Define function for CUMCEMUTOTPER
    if t ==1
        v.CUMCEMUTOTPER[t] = v.CEMUTOTPER[t]
    else
        v.CUMCEMUTOTPER[t] = v.CUMCEMUTOTPER[t-1] + v.CEMUTOTPER[t]
    end

    #Define function for UTILITY
    v.UTILITY = 5 * p.scale1 * v.CUMCEMUTOTPER[60] + p.scale2

end