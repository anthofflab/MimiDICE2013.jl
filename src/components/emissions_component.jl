@defcomp emissions begin
    CCA     = Variable(index=[time])    # Cumulative indiustrial emissions
    E       = Variable(index=[time])    # Total CO2 emissions (GtCO2 per year)
    EIND    = Variable(index=[time])    # Industrial emissions (GtCO2 per year)

    etree   = Parameter(index=[time])   # Emissions from deforestation
    MIU     = Parameter(index=[time])   # Emission control rate GHGs
    sigma   = Parameter(index=[time])   # CO2-equivalent-emissions output ratio
    YGROSS  = Parameter(index=[time])   # Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
    cca0    = Parameter()               # Initial cumulative industrial emissions

    function run_timestep(p, v, d, t)
        # Define function for EIND
        v.EIND[t] = p.sigma[t] * p.YGROSS[t] * (1 - p.MIU[t])
    
        # Define function for E
        v.E[t] = v.EIND[t] + p.etree[t]
    
        # Define function for CCA
        if is_first(t)
            v.CCA[t] = p.cca0
        else
            v.CCA[t] = v.CCA[t - 1] + v.EIND[t - 1] * 5 / 3.666
        end

    end
end
