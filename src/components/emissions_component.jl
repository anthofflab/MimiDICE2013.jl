@defcomp emissions begin
    CCA     = Variable(index=[time])    #Cumulative indiustrial emissions
    E       = Variable(index=[time])    #Total CO2 emissions (GtCO2 per year)
    EIND    = Variable(index=[time])    #Industrial emissions (GtCO2 per year)
    SIGMA   = Variable(index=[time])    #CO2-equivalent-emissions output ratio
    GSIGMA  = Variable(index=[time])    #growth of sigma per period
    ETREE   = Variable(index=[time])    #Emissions from deforestation

    sigma0     = Parameter()                #Initial sigma (tC per $1000 GDP US $, 2005 prices) 2005
    gsigma0    = Parameter()                #Initial growth of sigma per decade
    dersig     = Parameter()                #Decline rate of sigma (per year)
    eland0     = Parameter()                #Carbon emissions from land 2005(GtC per decade)
    deland     = Parameter()                #Decline rate of land emissions per decade
    expcost2   = Parameter()                #Exponent of control cost function
    cca0       = Parameter()                #Initial cumulative industrial emissions
    partfract  = Parameter(index=[time])    #Fraction of emissions in control regime
    pbacktime0 = Parameter()                #initial Backstop price
    MIU        = Parameter(index=[time])    #Emission control rate GHGs
    CPRICE     = Parameter(index=[time])    #Carbon price (2005$ per ton of CO2)
    PBACKTIME  = Parameter(index=[time])    #Backstop price
    YGROSS     = Parameter(index=[time])    #Gross world product GROSS of abatement and damages (trillions 2005 USD per year)


    function run_timestep(p, v, d, t)

        #define function for GSIGMA
        if is_first(t)
            v.GSIGMA[t] = p.gsigma0
        else
            v.GSIGMA[t] = v.GSIGMA[t - 1] * (1 + p.dersig)^5
        end

        #define function for SIGMA
        if is_first(t)
            v.SIGMA[t] = p.sigma0
        else
            v.SIGMA[t] = v.SIGMA[t - 1] * exp(v.GSIGMA[t] * (gettime(t) - gettime(t-1)))
        end

        #define function for ETREE
        if is_first(t)
            v.ETREE[t] = p.eland0
        else
            v.ETREE[t] = v.ETREE[t - 1] * (1 - p.deland)
        end

        #Define function for EIND
        v.EIND[t] = v.SIGMA[t] * p.YGROSS[t] * (1-p.MIU[t])

        #Define function for E
        v.E[t] = v.EIND[t] + v.ETREE[t]

        #Define function for CCA
        if is_first(t)
            v.CCA[t] = p.cca0
        else
            v.CCA[t] = v.CCA[t-1] + v.EIND[t-1] * 5/3.666
        end

    end
end
