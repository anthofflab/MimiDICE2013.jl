@defcomp co2cycle begin
    MAT     = Variable(index=[time])    # Carbon concentration increase in atmosphere (GtC from 1750)
    ML      = Variable(index=[time])    # Carbon concentration increase in lower oceans (GtC from 1750)
    MU      = Variable(index=[time])    # Carbon concentration increase in shallow oceans (GtC from 1750)

    E       = Parameter(index=[time])   # Total CO2 emissions (GtCO2 per year)
    mat0    = Parameter()               # Initial Concentration in atmosphere 2010 (GtC)
    ml0     = Parameter()               # Initial Concentration in lower strata 2010 (GtC)
    mu0     = Parameter()               # Initial Concentration in upper strata 2010 (GtC)

    # Parameters for long-run consistency of carbon cycle
    b11     = Parameter()               # Carbon cycle transition matrix atmosphere to atmosphere
    b12     = Parameter()               # Carbon cycle transition matrix atmosphere to shallow ocean
    b21     = Parameter()               # Carbon cycle transition matrix biosphere/shallow oceans to atmosphere
    b22     = Parameter()               # Carbon cycle transition matrix shallow ocean to shallow oceans
    b23     = Parameter()               # Carbon cycle transition matrix shallow to deep ocean
    b32     = Parameter()               # Carbon cycle transition matrix deep ocean to shallow ocean
    b33     = Parameter()               # Carbon cycle transition matrix deep ocean to deep oceans

    function run_timestep(p, v, d, t)
        # Define function for MAT
        if is_first(t)
            v.MAT[t] = p.mat0
        else
            v.MAT[t] = v.MAT[t - 1] * p.b11 + v.MU[t - 1] * p.b21 + (p.E[t - 1] * (5 / 3.666))
        end

        # Define function for MU
        if is_first(t)
            v.MU[t] = p.mu0
        else
            v.MU[t] = v.MAT[t - 1] * p.b12 + v.MU[t - 1] * p.b22 + v.ML[t - 1] * p.b32
        end

        # Define function for ML
        if is_first(t)
            v.ML[t] = p.ml0
        else
            v.ML[t] = v.ML[t - 1] * p.b33 + v.MU[t - 1] * p.b23
        end
    end
end
