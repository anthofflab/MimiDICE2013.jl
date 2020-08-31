@defcomp grosseconomy begin
    K       = Variable(index=[time])    #Capital stock (trillions 2005 US dollars)
    YGROSS  = Variable(index=[time])    #Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
    AL      = Variable(index=[time])    #Total factor productivity
    GA      = Variable(index=[time])    #Growth rate for technology per decade
    L       = Variable(index=[time])    #Level of population and labor

    a0      = Parameter()               #Initial level of total factor productivity
    ga0     = Parameter()               #Initial growth rate for technology per half-decade
    dela    = Parameter()               #Decline rate of technol change per half-decade
    I       = Parameter(index=[time])   #Investment (trillions 2005 USD per year)
    pop0    = Parameter()               #Initial population
    popadj  = Parameter()               #Population adjustment
    popsym  = Parameter()               #Asymptotic population
    dk      = Parameter()               #Depreciation rate on capital (per year)
    gama    = Parameter()               #Capital elasticity in production function
    k0      = Parameter()               #Initial capital value (trill 2005 USD)
    tsteps  = Parameter(index=[time])   #t

    function run_timestep(p, v, d, t)
        #Define function for K, L, AL and GA considering t=0 exception
        if is_first(t)
            v.K[t] = p.k0
            v.L[t] = p.pop0
            v.AL[t] = p.a0
            v.GA[t] = p.ga0
        else
            v.K[t] = (1 - p.dk)^5 * v.K[t-1] + 5 * p.I[t-1]
            v.L[t] = v.L[t-1] * (p.popsym/v.L[t-1])^p.popadj
            v.GA[t] = exp(-p.dela * 5 * (p.tsteps[t] - 1))*p.ga0
            v.AL[t] = v.AL[t - 1] / (1 - v.GA[t - 1])
        end

        #Define function for YGROSS
        v.YGROSS[t] = (v.AL[t] * (v.L[t]/1000)^(1-p.gama)) * (v.K[t]^p.gama)
    end
end
