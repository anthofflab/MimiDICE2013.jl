using Mimi

@defcomp climatedynamics begin
    TATM    = Variable(index=[time])    # Increase in temperature of atmosphere (degrees C from 1900)
    TOCEAN  = Variable(index=[time])    # Increase in temperature of lower oceans (degrees C from 1900)

    FORC    = Parameter(index=[time])   # Increase in radiative forcing (watts per m2 from 1900)
    fco22x  = Parameter()               # Forcings of equilibrium CO2 doubling (Wm-2)
    t2xco2  = Parameter()               # Equilibrium temp impact (oC per doubling CO2)
    tatm0   = Parameter()               # Initial atmospheric temp change (C from 1900)
    tocean0 = Parameter()               # Initial lower stratum temp change (C from 1900)

    # Transient TSC Correction ("Speed of Adjustment Parameter")
    c1 = Parameter()                    # Speed of adjustment parameter for atmospheric temperature
    c3 = Parameter()                    # Coefficient of heat loss from atmosphere to oceans
    c4 = Parameter()                    # Coefficient of heat gain by deep oceans.


    function init(p, v, d)
        t = 1
        v.TATM[t] = p.tatm0
        v.TOCEAN[t] = p.tocean0
    end

    function run_timestep(p, v, d, t)
        if t > 1
            # values from prior timestep
            tatm = v.TATM[t - 1]
            tocean = v.TOCEAN[t - 1]
            
            # Define function for TATM
            v.TATM[t] = tatm + p.c1 * ((p.FORC[t] - (p.fco22x / p.t2xco2) * tatm) - (p.c3 * (tatm - tocean)))

            # Define function for TOCEAN
            v.TOCEAN[t] = tocean + p.c4 * (tatm - tocean)
        end
    end
end