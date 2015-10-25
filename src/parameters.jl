using ExcelReaders
include("helpers.jl")

function getdice2013parameters(filename)
    p = Dict{Symbol,Any}()

    T = 60
    t = 1:T #  Time periods (5 years per period)

    #Open RICE_2010 Excel File to Read Parameters
    f = openxl(filename)

    tstep = 5 # Years per Period
    dt =  5 #Time step parameter for model equations

    a1          = getparams(f, "B25:B25", :single, "Base", 1)       #Damage coefficient on temperature
    a2          = getparams(f, "B26:B26", :single, "Base", 1)       #Damage quadratic term
    a3          = getparams(f, "B27:B27", :single, "Base", 1)       #Damage exponent
    al          = getparams(f, "B21:BI21", :all, "Base", T)         #Level of total factor productivity
    b11         = getparams(f, "B65:B65", :single, "Base", 1)       #Carbon cycle transition matrix atmosphere to atmosphere
    b12         = getparams(f, "B67:B67", :single, "Base", 1)       #Carbon cycle transition matrix atmosphere to shallow ocean
    b21         = getparams(f, "B66:B66", :single, "Base", 1)       #Carbon cycle transition matrix biosphere/shallow oceans to atmosphere
    b22         = getparams(f, "B68:B68", :single, "Base", 1)       #Carbon cycle transition matrix shallow ocean to shallow oceans
    b23         = getparams(f, "B70:B70", :single, "Base", 1)       #Carbon cycle transition matrix shallow to deep ocean
    b32         = getparams(f, "B69:B69", :single, "Base", 1)       #Carbon cycle transition matrix deep ocean to shallow ocean
    b33         = getparams(f, "B71:B71", :single, "Base", 1)       #Carbon cycle transition matrix deep ocean to deep oceans
    c1          = getparams(f, "B82:B82", :single, "Base", 1)       #Speed of adjustment parameter for atmospheric temperature (per 5 years)
    c3          = getparams(f, "B83:B83", :single, "Base", 1)       #Coefficient of heat loss from atmosphere to oceans
    c4          = getparams(f, "B84:B84", :single, "Base", 1)       #Coefficient of heat gain by deep oceans
    cca0        = getparams(f, "B92:B92", :single, "Base", T)       #Initial cumulative industrial emissions
    cost1       = getparams(f, "B32:BI32", :all, "Base", T)         #Abatement cost function coefficient
    damadj      = getparams(f, "B56:B56", :single, "Parameters", 1) #Adjustment exponent in damage function
    dk          = getparams(f, "B6:B6", :single, "Base", 1)         #Depreciation rate on capital (per year)
    elasmu      = getparams(f, "B19:B19", :single, "Base", 1)       #Elasticity of MU of consumption
    eqmat       = getparams(f, "B71:B71", :single, "Parameters", 1) #Equilibirum concentration of CO2 in atmosphere (GTC)
    etree       = getparams(f, "B44:BI44", :all, "Base", T)         #Carbon emissions form land use change (GTCO2 per year)
    expcost2    = getparams(f, "B39:B39", :single, "Base", 1)       #Exponent of control cost function
    fco22x      = getparams(f, "B80:B80", :single, "Base", 1)       #Forcings of equilibrium CO2 doubling (Wm-2)
    forcoth     = getparams(f, "B73:BI73", :all, "Base", T)         #Exogenous forcing for other greenhouse gases
    fosslim     = getparams(f, "B57:B57", :single, "Base", 1)       #Maximum carbon resources (Gtc)
    gama        = getparams(f, "B5:B5", :single, "Base", 1)         #Capitail Share
    k0          = getparams(f, "B12:B12", :single, "Base", 1)       #Initial capital
    l           = getparams(f, "B53:BI53", :all, "Base", T)         #Level of population and labor (millions)
    mat0        = getparams(f, "B60:B60", :single, "Base", 1)       #Initial Concentration in atmosphere at end 2007 (GtC)
    MIU         = getparams(f, "B135:BI135", :all, "Base", T)       #Optimized emission control rate results from DICE2013 (base case)
    ml0         = getparams(f, "B63:B63", :single, "Base", 1)       #Initial Concentration in deep oceans 2008 (GtC)
    mu0         = getparams(f, "B62:B62", :single, "Base", 1)       #Initial Concentration in biosphere/shallow oceans 2008 (GtC)
    partfract   = getparams(f, "B47:BI47", :all, "Base", T)         #Fraction of emissions in control regime
    pbacktime   = getparams(f, "B34:BI34", :all, "Base", T)         #Backstop price ($1000 per ton CO2)
    rr          = getparams(f, "B18:BI18", :all, "Base", T)         #Social Time Preference Factor
    S           = getparams(f, "B131:BI131", :all, "Base", T)       #Optimized savings rate (fraction of gross output) results from DICE2013 (base case)
    scale1      = getparams(f, "B49:B49", :single, "Base", 1)       #Multiplicative scaling coefficient
    scale2      = getparams(f, "B50:B50", :single, "Base", 1)       #Additive scaling coefficient
    sigma       = getparams(f, "B41:BI41", :all, "Base", T)         #(industrial, MTCO2/$1000    2000 US$)
    t2xco2      = getparams(f, "B79:B79", :single, "Base", 1)       #Equilibrium temp impact (oC per doubling CO2)
    tatm0       = getparams(f, "B76:B76", :single, "Base", 1)       #Initial atmospheric temp change 2008-2011 (C from 1900)
    tocean0     = getparams(f, "B77:B77", :single, "Base", 1)       #Initial temperature of deep oceans (deg C aboce 1900)

    p[:a1]          = a1
    p[:a2]          = a2
    p[:a3]          = a3
    p[:al]          = al
    p[:b12]         = b12
    p[:b23]         = b23
    p[:b11]         = b11
    p[:b21]         = b21
    p[:b22]         = b22
    p[:b32]         = b32
    p[:b33]         = b33
    p[:c1]          = c1
    p[:c3]          = c3
    p[:c4]          = c4
    p[:cca0]        = cca0
    p[:cost1]       = cost1
    p[:damadj]      = damadj
    p[:dk]          = dk
    p[:elasmu]      = elasmu
    p[:eqmat]       = eqmat
    p[:etree]       = etree
    p[:expcost2]    = expcost2
    p[:fco22x]      = fco22x
    p[:forcoth]     = forcoth
    p[:fosslim]     = fosslim
    p[:gama]        = gama
    p[:k0]          = k0
    p[:l]           = l
    p[:mat0]        = mat0
    p[:MIU]         = MIU
    p[:ml0]         = ml0
    p[:mu0]         = mu0
    p[:partfract]   = partfract
    p[:pbacktime]   = pbacktime
    p[:rr]          = rr
    p[:S]           = S
    p[:scale1]      = scale1
    p[:scale2]      = scale2
    p[:sigma]       = sigma
    p[:t2xco2]      = t2xco2
    p[:tatm0]       = tatm0
    p[:tocean0]     = tocean0

    return p
end