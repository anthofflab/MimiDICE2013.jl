@defcomp neteconomy begin

    ABATECOST   = Variable(index=[time])    #Cost of emissions reductions  (trillions 2005 USD per year)
    C           = Variable(index=[time])    #Consumption (trillions 2005 US dollars per year)
    CPC         = Variable(index=[time])    #Per capita consumption (thousands 2005 USD per year)
    CPRICE      = Variable(index=[time])    #Carbon price (2005$ per ton of CO2)
    COST1       = Variable(index=[time])    #Abatement cost function coefficient
    PBACKTIME   = Variable(index=[time])    #Backstop price
    I           = Variable(index=[time])    #Investment (trillions 2005 USD per year)
    MCABATE     = Variable(index=[time])    #Marginal cost of abatement (2005$ per ton CO2)
    Y           = Variable(index=[time])    #Gross world product net of abatement and damages (trillions 2005 USD per year)
    YNET        = Variable(index=[time])    #Output net of damages equation (trillions 2005 USD per year)

    DAMAGES     = Parameter(index=[time])   #Damages (Trillion $)
    L           = Parameter(index=[time])   #Level of population and labor
    SIGMA       = Parameter(index=[time])    #CO2-equivalent-emissions output ratio
    partfract   = Parameter(index=[time])   #Fraction of emissions in control regime
    MIU         = Parameter(index=[time])   #Emission control rate GHG
    pbacktime0  = Parameter()               #initial Backstop price
    pbackrate   = Parameter()               #Decline rate of backstop price ($1000 per ton CO2)
    S           = Parameter(index=[time])   #Gross savings rate as fraction of gross world product
    YGROSS      = Parameter(index=[time])   #Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
    expcost2    = Parameter()               #Exponent of control cost function

    function run_timestep(p, v, d, t)
        #define function for PBACKTIME
        if is_first(t)
            v.PBACKTIME[t] = p.pbacktime0
        else
            v.PBACKTIME[t] = v.PBACKTIME[t - 1] * (1-p.pbackrate)
        end

        #define function for COST1
        if is_first(t)
            v.COST1[t] = p.pbacktime0 * p.SIGMA[t] / p.expcost2 / 1000
        else
            v.COST1[t] = v.PBACKTIME[t] * p.SIGMA[t] / p.expcost2 / 1000
        end

        #Define function for YNET
        v.YNET[t] = p.YGROSS[t] - p.DAMAGES[t]

        #Define function for ABATECOST
        v.ABATECOST[t] = p.YGROSS[t] * v.COST1[t] * (p.MIU[t]^p.expcost2) * (p.partfract[t]^(1 - p.expcost2))

        #Define function for MCABATE (equation from GAMS version)
        v.MCABATE[t] = v.PBACKTIME[t] * p.MIU[t]^(p.expcost2 - 1)

        #Define function for Y
        v.Y[t] = v.YNET[t] - v.ABATECOST[t]

        #Define function for I
        v.I[t] = p.S[t] * v.Y[t]

        #Define function for C
        v.C[t] = v.Y[t] - v.I[t]

        #Define function for CPC
        v.CPC[t] = 1000 * v.C[t] / p.L[t]

        #Define function for CPRICE (equation from GAMS version of DICE2013)
        v.CPRICE[t] = v.PBACKTIME[t] * (p.MIU[t] / p.partfract[t])^(p.expcost2 - 1)
    end
end
