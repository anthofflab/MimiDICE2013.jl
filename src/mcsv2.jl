using Distributions

function getsimv2()

    mcs_anderson_et_al_2012 = @defsim begin

    # Using the method proposed by Anderson et al. (2012). Uncertainty in Integrated Assessment Modelling:Can Global Sensitivity Analysis Be of Help?. IEFE. https://ideas.repec.org/p/bcu/iefewp/iefewp52.html 
       
        a0 = Uniform(3.41785926,4.17738354)                          #Initial level of total factor productivity
        a2 = Uniform(0.0023973750000027,0.0029301250000033)          #Damage quadratic term
        a3 = Uniform(1.8,2.2)                                        #Damage exponent
        b11 = Uniform(0.8208,1.0032)                                 #Carbon cycle transition matrix atmosphere to atmosphere
        b12 = Uniform(0.079200000000009,0.096800000000011)           #Carbon cycle transition matrix atmosphere to shallow ocean
        b21 = Uniform(0.034496000000001,0.042161777777779)           #Carbon cycle transition matrix biosphere/shallow oceans to atmosphere
        b22 = Uniform(0.8632539999999,1.0550882222221)               #Carbon cycle transition matrix shallow ocean to shallow oceans
        b23 = Uniform(0.00225,0.00275)                               #Carbon cycle transition matrix shallow to deep ocean
        b32 = Uniform(0.00030375,0.00037125)                         #Carbon cycle transition matrix deep ocean to shallow ocean
        b33 = Uniform(0.89969625,1.09962875)                         #Carbon cycle transition matrix deep ocean to deep oceans
        c1 = Uniform(0.0936,0.1144)                                  # Speed of adjustment parameter for atmospheric temperature
        c3 = Uniform(0.0792,0.0968)                                  # Coefficient of heat loss from atmosphere to oceans
        c4 = Uniform(0.0225,0.0275)                                  # Coefficient of heat gain by deep oceans.
        cca0 = Uniform(81,99)                                        #Initial cumulative industrial emissions
        damadj = Uniform(9,11)                                       #Adjustment exponent in damage function
        dela = Uniform(0.0054,0.0066)                                #Decline rate of technol change per half-decade
        dersig = Uniform(-0.0011,-0.0009)                            #Decline rate of sigma (per year)
        deland = Uniform(0.18,0.22)                                  #Decline rate of land emissions per decade
        dk = Uniform(0.09,0.11)                                      #Depreciation rate on capital (per year)
        eland0 = Uniform(1.385748,1.693692)                          #Carbon emissions from land 2005(GtC per decade)
        elasmu = Uniform(1.305,1.595)                                #Elasticity of the marginal utility of consumption
        eqmat = Uniform(529.2,646.8)                                 #Equilibrium concentration of CO2 in atmosphere (GTC)
        expcost2 = Uniform(2.52,3.08)                                #Exponent of control cost function
        fco22x = Uniform(3.42,4.18)                                  # Forcings of equilibrium CO2 doubling (Wm-2)
        fex0= Uniform(-0.066,-0.054)                                 #Estimate of 2000 forcings of non-CO2 GHG
        fex1 = Uniform(0.558,0.682)                                  #Estimate of 2100 forcings of non-CO2 GHG
        ga0 = Uniform(0.0711,0.0869)                                 #Initial growth rate for technology per half-decade
        gama = Uniform(0.27,0.33)                                    #Capital elasticity in production function
        gsigma0 = Uniform(-0.011,-0.009)                             #Initial growth of sigma per decade
        k0 = Uniform(121.5,148.5)                                    #Initial capital value (trill 2005 USD)
        mat0 = Uniform(737.0865,900.8835)                            #Initial Concentration in atmosphere 2010 (GtC)
        ml0 = Uniform(9009,11011)                                    #Initial Concentration in lower strata 2010 (GtC)
        mu0 = Uniform(1374.3,1679.7)                                 #Initial Concentration in upper strata 2010 (GtC)
        pbackrate = Uniform(0.0225,0.0275)                           #Decline rate of backstop price ($1000 per ton CO2)
        pbacktime0 = Uniform(309.6,378.4)                            #initial Backstop price
        pop0 = Uniform(6154.2,7521.8)                                #Initial population
        popadj = Uniform(0.121041,0.147939)                          #Population adjustment
        popsym = Uniform(9450,11550)                                 #Asymptotic population
        prtp = Uniform(0.0135,0.0165)                                #Rate of social time preference (% py)
        scale1 = Uniform(0.0147570298829796,0.018036369856975)       #Multiplicative scaling coefficient
        scale2 = Uniform(-4206.25524301252,-3441.48156246478)        #Additive scaling coefficient
        sigma0 = Uniform(0.44008427184466,0.537880776699028)         #Initial sigma (tC per $1000 GDP US $, 2005 prices) 2005
        t2xco2 = Uniform(2.88,3.52)                                  # Equilibrium temp impact (oC per doubling CO2)
        tatm0 = Uniform(0.747,0.913)                                 # Initial atmospheric temp change (C from 1900)
        tocean0 = Uniform(0.00612,0.00748)                           # Initial lower stratum temp change (C from 1900)

        save(neteconomy.CPC,
            neteconomy.C,
            neteconomy.ABATECOST,
            neteconomy.COST1,
            neteconomy.YNET,
            damages.DAMAGES,
            damages.DAMFRAC,
            grosseconomy.L,
            grosseconomy.YGROSS
            )
        end
    return mcs_anderson_et_al_2012

end

