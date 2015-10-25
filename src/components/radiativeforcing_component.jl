using Mimi

@defcomp radiativeforcing begin
    FORC      = Variable(index=[time])   #Increase in radiative forcing (watts per m2 from 1900)

    forcoth   = Parameter(index=[time])  #Exogenous forcing for other greenhouse gases
    MAT       = Parameter(index=[time])  #Carbon concentration increase in atmosphere (GtC from 1750)
    eqmat     = Parameter()              #Equilibrium concentration of CO2 in atmosphere (GTC)
    fco22x    = Parameter()              #Forcings of equilibrium CO2 doubling (Wm-2)

end

function timestep(state::radiativeforcing, t::Int)
    v = state.Variables
    p = state.Parameters

    #Define function for FORC
    v.FORC[t] = p.fco22x * (log((p.MAT[t] / p.eqmat)) / log(2)) + p.forcoth[t]

end