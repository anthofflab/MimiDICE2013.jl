@defcomp radiativeforcing begin
    FORC      = Variable(index=[time])   #Increase in radiative forcing (watts per m2 from 1900)
    FORCOTH   = Variable(index=[time])  #Exogenous forcing for other greenhouse gases

    fex0      = Parameter()              #Estimate of 2000 forcings of non-CO2 GHG
    fex1      = Parameter()              #Estimate of 2100 forcings of non-CO2 GHG
    MAT       = Parameter(index=[time])  #Carbon concentration increase in atmosphere (GtC from 1750)
    tsteps    = Parameter(index=[time])  #t
    eqmat     = Parameter()              #Equilibrium concentration of CO2 in atmosphere (GTC)
    fco22x    = Parameter()              #Forcings of equilibrium CO2 doubling (Wm-2)

    function run_timestep(p, v, d, t)
        #Define function for FORCOTH
        if gettime(t) <= 2100
            v.FORCOTH[t] = p.fex0 + 0.05 * (p.fex1 - p.fex0) * (2 + p.tsteps[t] -1)
        else
            v.FORCOTH[t] = v.FORCOTH[t - 1]
        end

        #Define function for FORC
        v.FORC[t] = p.fco22x * (log((p.MAT[t] / p.eqmat)) / log(2)) + v.FORCOTH[t]
    end
end

