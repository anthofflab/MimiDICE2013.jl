using ExcelReaders
include("helpers.jl")

function getdice2013excelparameters(filename)
    p = Dict{Symbol,Any}()

    T = 60

    #Open RICE_2010 Excel File to Read Parameters
    f = openxl(filename)

    p[:a1]          = getparams(f, "B25:B25", :single, "Base", 1)       #Damage coefficient on temperature
    p[:a2]          = getparams(f, "B26:B26", :single, "Base", 1)       #Damage quadratic term
    p[:a3]          = getparams(f, "B27:B27", :single, "Base", 1)       #Damage exponent
    p[:al]          = getparams(f, "B21:BI21", :all, "Base", T)         #Level of total factor productivity
    p[:b11]         = getparams(f, "B65:B65", :single, "Base", 1)/100   #Carbon cycle transition matrix atmosphere to atmosphere
    p[:b12]         = getparams(f, "B67:B67", :single, "Base", 1)/100   #Carbon cycle transition matrix atmosphere to shallow ocean
    p[:b21]         = getparams(f, "B66:B66", :single, "Base", 1)/100   #Carbon cycle transition matrix biosphere/shallow oceans to atmosphere
    p[:b22]         = getparams(f, "B68:B68", :single, "Base", 1)/100   #Carbon cycle transition matrix shallow ocean to shallow oceans
    p[:b23]         = getparams(f, "B70:B70", :single, "Base", 1)/100   #Carbon cycle transition matrix shallow to deep ocean
    p[:b32]         = getparams(f, "B69:B69", :single, "Base", 1)/100   #Carbon cycle transition matrix deep ocean to shallow ocean
    p[:b33]         = getparams(f, "B71:B71", :single, "Base", 1)/100   #Carbon cycle transition matrix deep ocean to deep oceans
    p[:c1]          = getparams(f, "B82:B82", :single, "Base", 1)       #Speed of adjustment parameter for atmospheric temperature (per 5 years)
    p[:c3]          = getparams(f, "B83:B83", :single, "Base", 1)       #Coefficient of heat loss from atmosphere to oceans
    p[:c4]          = getparams(f, "B84:B84", :single, "Base", 1)       #Coefficient of heat gain by deep oceans
    p[:cca0]        = getparams(f, "B92:B92", :single, "Base", T)       #Initial cumulative industrial emissions
    p[:cost1]       = getparams(f, "B32:BI32", :all, "Base", T)         #Abatement cost function coefficient
    p[:damadj]      = getparams(f, "B56:B56", :single, "Parameters", 1) #Adjustment exponent in damage function
    p[:dk]          = getparams(f, "B6:B6", :single, "Base", 1)         #Depreciation rate on capital (per year)
    p[:elasmu]      = getparams(f, "B19:B19", :single, "Base", 1)       #Elasticity of MU of consumption
    p[:eqmat]       = getparams(f, "B71:B71", :single, "Parameters", 1) #Equilibirum concentration of CO2 in atmosphere (GTC)
    p[:etree]       = getparams(f, "B44:BI44", :all, "Base", T)         #Carbon emissions form land use change (GTCO2 per year)
    p[:expcost2]    = getparams(f, "B39:B39", :single, "Base", 1)       #Exponent of control cost function
    p[:fco22x]      = getparams(f, "B80:B80", :single, "Base", 1)       #Forcings of equilibrium CO2 doubling (Wm-2)
    p[:forcoth]     = getparams(f, "B73:BI73", :all, "Base", T)         #Exogenous forcing for other greenhouse gases
    p[:fosslim]     = getparams(f, "B57:B57", :single, "Base", 1)       #Maximum carbon resources (Gtc)
    p[:gama]        = getparams(f, "B5:B5", :single, "Base", 1)         #Capitail Share
    p[:k0]          = getparams(f, "B12:B12", :single, "Base", 1)       #Initial capital
    p[:l]           = getparams(f, "B53:BI53", :all, "Base", T)         #Level of population and labor (millions)
    p[:mat0]        = getparams(f, "B60:B60", :single, "Base", 1)       #Initial Concentration in atmosphere at end 2007 (GtC)
    p[:MIU]         = getparams(f, "B135:BI135", :all, "Base", T)       #Optimized emission control rate results from DICE2013 (base case)
    p[:ml0]         = getparams(f, "B63:B63", :single, "Base", 1)       #Initial Concentration in deep oceans 2008 (GtC)
    p[:mu0]         = getparams(f, "B62:B62", :single, "Base", 1)       #Initial Concentration in biosphere/shallow oceans 2008 (GtC)
    p[:partfract]   = getparams(f, "B47:BI47", :all, "Base", T)         #Fraction of emissions in control regime
    p[:pbacktime]   = getparams(f, "B34:BI34", :all, "Base", T)         #Backstop price ($1000 per ton CO2)
    p[:rr]          = getparams(f, "B18:BI18", :all, "Base", T)         #Social Time Preference Factor
    p[:S]           = getparams(f, "B131:BI131", :all, "Base", T)       #Optimized savings rate (fraction of gross output) results from DICE2013 (base case)
    p[:scale1]      = getparams(f, "B49:B49", :single, "Base", 1)       #Multiplicative scaling coefficient
    p[:scale2]      = getparams(f, "B50:B50", :single, "Base", 1)       #Additive scaling coefficient
    p[:sigma]       = getparams(f, "B41:BI41", :all, "Base", T)         #(industrial, MTCO2/$1000    2000 US$)
    p[:t2xco2]      = getparams(f, "B79:B79", :single, "Base", 1)       #Equilibrium temp impact (oC per doubling CO2)
    p[:tatm0]       = getparams(f, "B76:B76", :single, "Base", 1)       #Initial atmospheric temp change 2008-2011 (C from 1900)
    p[:tocean0]     = getparams(f, "B77:B77", :single, "Base", 1)       #Initial temperature of deep oceans (deg C aboce 1900)
    p[:usedamadj]   = true

    return p
end

function getdice2013gamsparameters(filename)
    p = Dict{Symbol,Any}()

    T = 60

    #Open RICE_2010 Excel File to Read Parameters
    f = openxl(filename)

    p[:a1]          = getparams(f, "B41:B41", :single, "DICE2013_Base", 1)       #Damage coefficient on temperature
    p[:a2]          = getparams(f, "B42:B42", :single, "DICE2013_Base", 1)       #Damage quadratic term
    p[:a3]          = getparams(f, "B43:B43", :single, "DICE2013_Base", 1)       #Damage exponent
    p[:al]          = getparams(f, "B5:BI5", :all, "DICE2013_Base", T)         #Level of total factor productivity
    p[:b11]         = getparams(f, "B22:B22", :single, "DICE2013_Base", 1)   #Carbon cycle transition matrix atmosphere to atmosphere
    p[:b12]         = getparams(f, "B20:B20", :single, "DICE2013_Base", 1)   #Carbon cycle transition matrix atmosphere to shallow ocean
    p[:b21]         = getparams(f, "B23:B23", :single, "DICE2013_Base", 1)   #Carbon cycle transition matrix biosphere/shallow oceans to atmosphere
    p[:b22]         = getparams(f, "B24:B24", :single, "DICE2013_Base", 1)   #Carbon cycle transition matrix shallow ocean to shallow oceans
    p[:b23]         = getparams(f, "B21:B21", :single, "DICE2013_Base", 1)   #Carbon cycle transition matrix shallow to deep ocean
    p[:b32]         = getparams(f, "B25:B25", :single, "DICE2013_Base", 1)   #Carbon cycle transition matrix deep ocean to shallow ocean
    p[:b33]         = getparams(f, "B26:B26", :single, "DICE2013_Base", 1)   #Carbon cycle transition matrix deep ocean to deep oceans
    p[:c1]          = getparams(f, "B36:B36", :single, "DICE2013_Base", 1)       #Speed of adjustment parameter for atmospheric temperature (per 5 years)
    p[:c3]          = getparams(f, "B37:B37", :single, "DICE2013_Base", 1)       #Coefficient of heat loss from atmosphere to oceans
    p[:c4]          = getparams(f, "B38:B38", :single, "DICE2013_Base", 1)       #Coefficient of heat gain by deep oceans
    p[:cca0]        = getparams(f, "B14:B14", :single, "DICE2013_Base", 1)       #Initial cumulative industrial emissions
    p[:cost1]       = getparams(f, "B46:BI46", :all, "DICE2013_Base", T)         #Abatement cost function coefficient
    p[:damadj]      = getparams(f, ) #Adjustment exponent in damage function
    p[:dk]          = getparams(f, "B8:B8", :single, "DICE2013_Base", 1)         #Depreciation rate on capital (per year)
    p[:elasmu]      = getparams(f, "B54:BI54", :single, "DICE2013_Base", 1)       #Elasticity of MU of consumption
    p[:eqmat]       = getparams(f, 588.) #Equilibirum concentration of CO2 in atmosphere (GTC)
    p[:etree]       = getparams(f, "B13:BI13", :all, "DICE2013_Base", T)         #Carbon emissions form land use change (GTCO2 per year)
    p[:expcost2]    = getparams(f, "B48:B48", :single, "DICE2013_Base", 1)       #Exponent of control cost function
    p[:fco22x]      = getparams(f, "B30:B30", :single, "DICE2013_Base", 1)       #Forcings of equilibrium CO2 doubling (Wm-2)
    p[:forcoth]     = getparams(f, "B29:BI29", :all, "DICE2013_Base", T)         #Exogenous forcing for other greenhouse gases
    p[:gama]        = getparams(f, "B7:B7", :single, "DICE2013_Base", 1)         #Capitail Share
    p[:k0]          = getparams(f, "B9:B9", :single, "DICE2013_Base", 1)       #Initial capital
    p[:l]           = getparams(f, "B6:BI6", :all, "DICE2013_Base", T)         #Level of population and labor (millions)
    p[:mat0]        = getparams(f, "B17:B17", :single, "DICE2013_Base", 1)       #Initial Concentration in atmosphere at end 2007 (GtC)
    p[:MIU]         = getparams(f, "B47:BI47", :all, "DICE2013_Base", T)       #Optimized emission control rate results from DICE2013 (base case)
    p[:ml0]         = getparams(f, "B19:B19", :single, "DICE2013_Base", 1)       #Initial Concentration in deep oceans 2008 (GtC)
    p[:mu0]         = getparams(f, "B18:B18", :single, "DICE2013_Base", 1)       #Initial Concentration in biosphere/shallow oceans 2008 (GtC)
    p[:partfract]   = getparams(f, "B49:BI49", :all, "DICE2013_Base", T)         #Fraction of emissions in control regime
    p[:pbacktime]   = getparams(f, "B50:BI50", :all, "DICE2013_Base", T)         #Backstop price ($1000 per ton CO2)
    p[:rr]          = getparams(f, "B55:BI55", :all, "DICE2013_Base", T)         #Social Time Preference Factor
    p[:S]           = getparams(f, "B51:BI51", :all, "DICE2013_Base", T)       #Optimized savings rate (fraction of gross output) results from DICE2013 (base case)
    p[:scale1]      = getparams(f, "B56:B56", :single, "DICE2013_Base", 1)       #Multiplicative scaling coefficient
    p[:scale2]      = getparams(f, "B57:B57", :single, "DICE2013_Base", 1)       #Additive scaling coefficient
    p[:sigma]       = getparams(f, "B12:BI12", :all, "DICE2013_Base", T)         #(industrial, MTCO2/$1000    2000 US$)
    p[:t2xco2]      = getparams(f, "B33:B33", :single, "DICE2013_Base", 1)       #Equilibrium temp impact (oC per doubling CO2)
    p[:tatm0]       = getparams(f, "B34:B34", :single, "DICE2013_Base", 1)       #Initial atmospheric temp change 2008-2011 (C from 1900)
    p[:tocean0]     = getparams(f, "B35:B35", :single, "DICE2013_Base", 1)       #Initial temperature of deep oceans (deg C aboce 1900)
    p[:usedamadj]   = false

    return p
end
