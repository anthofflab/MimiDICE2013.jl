@defcomp welfare begin
    CEMUTOTPER      = Variable(index=[time])    #Period utility
    CUMCEMUTOTPER   = Variable(index=[time])    #Cumulative period utility
    PERIODU         = Variable(index=[time])    #One period utility function
    RR              = Variable(index=[time])    #Social Time Preference Factor
    UTILITY         = Variable()                #Welfare Function

    CPC             = Parameter(index=[time])   #Per capita consumption (thousands 2005 USD per year)
    L               = Parameter(index=[time])   #Level of population and labor
    rr0             = Parameter()               #Average utility social discount rate
    prtp            = Parameter()               #Rate of social time preference (% py)
    elasmu          = Parameter()               #Elasticity of marginal utility of consumption
    scale1          = Parameter()               #Multiplicative scaling coefficient
    scale2          = Parameter()               #Additive scaling coefficient

    function run_timestep(p, v, d, t)

        #define function for RR
        if is_first(t)
            v.RR[t] = 1
        else
            v.RR[t] = v.RR[t - 1] / (1 + p.prtp)^(gettime(t) - gettime(t - 1))
        end 

        # Define function for PERIODU
        v.PERIODU[t] = (p.CPC[t] ^ (1 - p.elasmu) - 1) / (1 - p.elasmu) - 1

        # Define function for CEMUTOTPER
        v.CEMUTOTPER[t] = v.PERIODU[t] * p.L[t] * v.RR[t]

        # Define function for CUMCEMUTOTPER
        v.CUMCEMUTOTPER[t] = v.CEMUTOTPER[t] + (!is_first(t) ? v.CUMCEMUTOTPER[t-1] : 0)

        # Define function for UTILITY
        if t.t == 60
            v.UTILITY = 5 * p.scale1 * v.CUMCEMUTOTPER[t] + p.scale2

            utility = 5 * p.scale1 * v.CUMCEMUTOTPER[t] + p.scale2
        end
    end
end
