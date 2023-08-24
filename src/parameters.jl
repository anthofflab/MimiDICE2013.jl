using XLSX: readxlsx

"""
 Get DICE2013 default Excel parameters. Returns a Dictionary with two keys:
 * :shared => (parameter_name => default_value) for parameters shared in the model.
 * :unshared => ((component_name, parameter_name) => default_value) for component specific parameters that are not shared values.
 """
function getdice2013excelparameters(filename)

    p_unshared = Dict{Tuple{Symbol,Symbol},Any}()
    p_shared = Dict{Symbol,Any}()

    T = 60

    # Open  DICE_2013_Excel File to Read Parameters
    f = readxlsx(filename)

    #
    # SHARED PARAMETERS 
    #

    p_shared[:fco22x] = getparams(f, "B80:B80", :single, "Base", 1) # Forcings of equilibrium CO2 doubling (Wm-2)
    p_shared[:MIU] = getparams(f, "B135:BI135", :all, "Base", T) # Optimized emission control rate results from DICE2013 (base case)
    p_shared[:l] = getparams(f, "B53:BI53", :all, "Base", T) # Level of population and labor (millions)

    #
    # COMPONENT PARAMETERS 
    #

    p_unshared[(:damages, :a1)] = getparams(f, "B25:B25", :single, "Base", 1) # Damage coefficient on temperature
    p_unshared[(:damages, :a2)] = getparams(f, "B26:B26", :single, "Base", 1) # Damage quadratic term
    p_unshared[(:damages, :a3)] = getparams(f, "B27:B27", :single, "Base", 1) # Damage exponent
    p_unshared[(:grosseconomy, :al)] = getparams(f, "B21:BI21", :all, "Base", T) # Level of total factor productivity
    p_unshared[(:co2cycle, :b11)] = getparams(f, "B65:B65", :single, "Base", 1) / 100 # Carbon cycle transition matrix atmosphere to atmosphere
    p_unshared[(:co2cycle, :b12)] = getparams(f, "B67:B67", :single, "Base", 1) / 100 # Carbon cycle transition matrix atmosphere to shallow ocean
    p_unshared[(:co2cycle, :b21)] = getparams(f, "B66:B66", :single, "Base", 1) / 100 # Carbon cycle transition matrix biosphere/shallow oceans to atmosphere
    p_unshared[(:co2cycle, :b22)] = getparams(f, "B68:B68", :single, "Base", 1) / 100 # Carbon cycle transition matrix shallow ocean to shallow oceans
    p_unshared[(:co2cycle, :b23)] = getparams(f, "B70:B70", :single, "Base", 1) / 100 # Carbon cycle transition matrix shallow to deep ocean
    p_unshared[(:co2cycle, :b32)] = getparams(f, "B69:B69", :single, "Base", 1) / 100 # Carbon cycle transition matrix deep ocean to shallow ocean
    p_unshared[(:co2cycle, :b33)] = getparams(f, "B71:B71", :single, "Base", 1) / 100 # Carbon cycle transition matrix deep ocean to deep oceans
    p_unshared[(:climatedynamics, :c1)] = getparams(f, "B82:B82", :single, "Base", 1) # Speed of adjustment parameter for atmospheric temperature (per 5 years)
    p_unshared[(:climatedynamics, :c3)] = getparams(f, "B83:B83", :single, "Base", 1) # Coefficient of heat loss from atmosphere to oceans
    p_unshared[(:climatedynamics, :c4)] = getparams(f, "B84:B84", :single, "Base", 1) # Coefficient of heat gain by deep oceans
    p_unshared[(:emissions, :cca0)] = getparams(f, "B92:B92", :single, "Base", T) # Initial cumulative industrial emissions
    p_unshared[(:neteconomy, :cost1)] = getparams(f, "B32:BI32", :all, "Base", T) # Abatement cost function coefficient
    p_unshared[(:damages, :damadj)] = getparams(f, "B56:B56", :single, "Parameters", 1) # Adjustment exponent in damage function
    p_unshared[(:grosseconomy, :dk)] = getparams(f, "B6:B6", :single, "Base", 1) # Depreciation rate on capital (per year)
    p_unshared[(:welfare, :elasmu)] = getparams(f, "B19:B19", :single, "Base", 1) # Elasticity of MU of consumption
    p_unshared[(:radiativeforcing, :eqmat)] = getparams(f, "B71:B71", :single, "Parameters", 1) # Equilibirum concentration of CO2 in atmosphere (GTC)
    p_unshared[(:emissions, :etree)] = getparams(f, "B44:BI44", :all, "Base", T) # Carbon emissions form land use change (GTCO2 per year)
    p_unshared[(:neteconomy, :expcost2)] = getparams(f, "B39:B39", :single, "Base", 1) # Exponent of control cost function
    p_unshared[(:radiativeforcing, :forcoth)] = getparams(f, "B73:BI73", :all, "Base", T) # Exogenous forcing for other greenhouse gases
    p_unshared[(:grosseconomy, :gama)] = getparams(f, "B5:B5", :single, "Base", 1) # Capitail Share
    p_unshared[(:grosseconomy, :k0)] = getparams(f, "B12:B12", :single, "Base", 1) # Initial capital
    p_unshared[(:co2cycle, :mat0)] = getparams(f, "B60:B60", :single, "Base", 1) # Initial Concentration in atmosphere at end 2007 (GtC)
    p_unshared[(:co2cycle, :ml0)] = getparams(f, "B63:B63", :single, "Base", 1) # Initial Concentration in deep oceans 2008 (GtC)
    p_unshared[(:co2cycle, :mu0)] = getparams(f, "B62:B62", :single, "Base", 1) # Initial Concentration in biosphere/shallow oceans 2008 (GtC)
    p_unshared[(:neteconomy, :partfract)] = getparams(f, "B47:BI47", :all, "Base", T) # Fraction of emissions in control regime
    p_unshared[(:neteconomy, :pbacktime)] = getparams(f, "B34:BI34", :all, "Base", T) # Backstop price ($1000 per ton CO2)
    p_unshared[(:welfare, :rr)] = getparams(f, "B18:BI18", :all, "Base", T) # Social Time Preference Factor
    p_unshared[(:neteconomy, :S)] = getparams(f, "B131:BI131", :all, "Base", T) # Optimized savings rate (fraction of gross output) results from DICE2013 (base case)
    p_unshared[(:welfare, :scale1)] = getparams(f, "B49:B49", :single, "Base", 1) # Multiplicative scaling coefficient
    p_unshared[(:welfare, :scale2)] = getparams(f, "B50:B50", :single, "Base", 1) # Additive scaling coefficient
    p_unshared[(:emissions, :sigma)] = getparams(f, "B41:BI41", :all, "Base", T) # (industrial, MTCO2/$1000    2000 US$)
    p_unshared[(:climatedynamics, :t2xco2)] = getparams(f, "B79:B79", :single, "Base", 1) # Equilibrium temp impact (oC per doubling CO2)
    p_unshared[(:climatedynamics, :tatm0)] = getparams(f, "B76:B76", :single, "Base", 1) # Initial atmospheric temp change 2008-2011 (C from 1900)
    p_unshared[(:climatedynamics, :tocean0)] = getparams(f, "B77:B77", :single, "Base", 1) # Initial temperature of deep oceans (deg C aboce 1900)
    p_unshared[(:damages, :usedamadj)] = true

    return Dict(:unshared => p_unshared, :shared => p_shared)
end

function getdice2013gamsparameters(filename)
    p_unshared = Dict{Tuple{Symbol,Symbol},Any}()
    p_shared = Dict{Symbol,Any}()

    T = 60

    # Open DICE_2013 Excel File to Read Parameters
    f = readxlsx(filename)
    sheet = "DICE2013_Base"

    #
    # SHARED PARAMETERS 
    #
    p_shared[:MIU] = getparams(f, "B48:BI48", :all, sheet, T) # Optimized emission control rate results from DICE2013 (base case)
    p_shared[:l] = getparams(f, "B6:BI6", :all, sheet, T) # Level of population and labor (millions)
    p_shared[:fco22x] = getparams(f, "B30:B30", :single, sheet, 1) # Forcings of equilibrium CO2 doubling (Wm-2)

    #
    # COMPONENT PARAMETERS 
    #

    p_unshared[(:damages, :a1)] = getparams(f, "B42:B42", :single, sheet, 1) # Damage coefficient on temperature
    p_unshared[(:damages, :a2)] = getparams(f, "B43:B43", :single, sheet, 1) # Damage quadratic term
    p_unshared[(:damages, :a3)] = getparams(f, "B44:B44", :single, sheet, 1) # Damage exponent
    p_unshared[(:grosseconomy, :al)] = getparams(f, "B5:BI5", :all, sheet, T) # Level of total factor productivity
    p_unshared[(:co2cycle, :b11)] = getparams(f, "B22:B22", :single, sheet, 1) # Carbon cycle transition matrix atmosphere to atmosphere
    p_unshared[(:co2cycle, :b12)] = getparams(f, "B20:B20", :single, sheet, 1) # Carbon cycle transition matrix atmosphere to shallow ocean
    p_unshared[(:co2cycle, :b21)] = getparams(f, "B23:B23", :single, sheet, 1) # Carbon cycle transition matrix biosphere/shallow oceans to atmosphere
    p_unshared[(:co2cycle, :b22)] = getparams(f, "B24:B24", :single, sheet, 1) # Carbon cycle transition matrix shallow ocean to shallow oceans
    p_unshared[(:co2cycle, :b23)] = getparams(f, "B21:B21", :single, sheet, 1) # Carbon cycle transition matrix shallow to deep ocean
    p_unshared[(:co2cycle, :b32)] = getparams(f, "B25:B25", :single, sheet, 1) # Carbon cycle transition matrix deep ocean to shallow ocean
    p_unshared[(:co2cycle, :b33)] = getparams(f, "B26:B26", :single, sheet, 1) # Carbon cycle transition matrix deep ocean to deep oceans
    p_unshared[(:climatedynamics, :c1)] = getparams(f, "B37:B37", :single, sheet, 1) # Speed of adjustment parameter for atmospheric temperature (per 5 years)
    p_unshared[(:climatedynamics, :c3)] = getparams(f, "B38:B38", :single, sheet, 1) # Coefficient of heat loss from atmosphere to oceans
    p_unshared[(:climatedynamics, :c4)] = getparams(f, "B39:B39", :single, sheet, 1) # Coefficient of heat gain by deep oceans
    p_unshared[(:emissions, :cca0)] = getparams(f, "B14:B14", :single, sheet, 1) # Initial cumulative industrial emissions
    p_unshared[(:neteconomy, :cost1)] = getparams(f, "B47:BI47", :all, sheet, T) # Abatement cost function coefficient
    p_unshared[(:damages, :damadj)] = 1.0 # Adjustment exponent in damage function (not used in GAMS version).
    p_unshared[(:grosseconomy, :dk)] = getparams(f, "B8:B8", :single, sheet, 1) # Depreciation rate on capital (per year)
    p_unshared[(:welfare, :elasmu)] = getparams(f, "B55:BI55", :single, sheet, 1) # Elasticity of MU of consumption
    p_unshared[(:radiativeforcing, :eqmat)] = getparams(f, "B31:B31", :single, sheet, 1) # Equilibirum concentration of CO2 in atmosphere (GTC)
    p_unshared[(:emissions, :etree)] = getparams(f, "B13:BI13", :all, sheet, T) # Carbon emissions form land use change (GTCO2 per year)
    p_unshared[(:neteconomy, :expcost2)] = getparams(f, "B49:B49", :single, sheet, 1) # Exponent of control cost function
    p_unshared[(:radiativeforcing, :forcoth)] = getparams(f, "B29:BI29", :all, sheet, T) # Exogenous forcing for other greenhouse gases
    p_unshared[(:grosseconomy, :gama)] = getparams(f, "B7:B7", :single, sheet, 1) # Capitail Share
    p_unshared[(:grosseconomy, :k0)] = getparams(f, "B9:B9", :single, sheet, 1) # Initial capital
    p_unshared[(:co2cycle, :mat0)] = getparams(f, "B17:B17", :single, sheet, 1) # Initial Concentration in atmosphere at end 2007 (GtC)
    p_unshared[(:co2cycle, :ml0)] = getparams(f, "B19:B19", :single, sheet, 1) # Initial Concentration in deep oceans 2008 (GtC)
    p_unshared[(:co2cycle, :mu0)] = getparams(f, "B18:B18", :single, sheet, 1) # Initial Concentration in biosphere/shallow oceans 2008 (GtC)
    p_unshared[(:neteconomy, :partfract)] = getparams(f, "B50:BI50", :all, sheet, T) # Fraction of emissions in control regime
    p_unshared[(:neteconomy, :pbacktime)] = getparams(f, "B51:BI51", :all, sheet, T) # Backstop price ($1000 per ton CO2)
    p_unshared[(:welfare, :rr)] = getparams(f, "B56:BI56", :all, sheet, T) # Social Time Preference Factor
    p_unshared[(:neteconomy, :S)] = getparams(f, "B52:BI52", :all, sheet, T) # Optimized savings rate (fraction of gross output) results from DICE2013 (base case)
    p_unshared[(:welfare, :scale1)] = getparams(f, "B57:B57", :single, sheet, 1) # Multiplicative scaling coefficient
    p_unshared[(:welfare, :scale2)] = getparams(f, "B58:B58", :single, sheet, 1) # Additive scaling coefficient
    p_unshared[(:emissions, :sigma)] = getparams(f, "B12:BI12", :all, sheet, T) # (industrial, MTCO2/$1000    2000 US$)
    p_unshared[(:climatedynamics, :t2xco2)] = getparams(f, "B34:B34", :single, sheet, 1) # Equilibrium temp impact (oC per doubling CO2)
    p_unshared[(:climatedynamics, :tatm0)] = getparams(f, "B35:B35", :single, sheet, 1) # Initial atmospheric temp change 2008-2011 (C from 1900)
    p_unshared[(:climatedynamics, :tocean0)] = getparams(f, "B36:B36", :single, sheet, 1) # Initial temperature of deep oceans (deg C aboce 1900)
    p_unshared[(:damages, :usedamadj)] = false

    return Dict(:unshared => p_unshared, :shared => p_shared)
end
