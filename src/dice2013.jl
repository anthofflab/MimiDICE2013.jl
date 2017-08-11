using Mimi
using ExcelReaders

include("parameters.jl")

include("components/grosseconomy_component.jl")
include("components/emissions_component.jl")
include("components/co2cycle_component.jl")
include("components/radiativeforcing_component.jl")
include("components/climatedynamics_component.jl")
include("components/damages_component.jl")
include("components/neteconomy_component.jl")
include("components/welfare_component.jl")

function constructdice(p)
    m = Model()

    setindex(m, :time, collect(2010:5:2305))

    addcomponent(m, grosseconomy)
    addcomponent(m, emissions)
    addcomponent(m, co2cycle)
    addcomponent(m, radiativeforcing)
    addcomponent(m, climatedynamics)
    addcomponent(m, damages)
    addcomponent(m, neteconomy)
    addcomponent(m, welfare)


    #GROSS ECONOMY COMPONENT
    setparameter(m, :grosseconomy, :al, p[:al])
    setparameter(m, :grosseconomy, :l, p[:l])
    setparameter(m, :grosseconomy, :gama, p[:gama])
    setparameter(m, :grosseconomy, :dk, p[:dk])
    setparameter(m, :grosseconomy, :k0, p[:k0])

    connectparameter(m, :grosseconomy, :I, :neteconomy, :I)


    #EMISSIONS COMPONENT
    setparameter(m, :emissions, :sigma, p[:sigma])
    setparameter(m, :emissions, :MIU, p[:MIU])
    setparameter(m, :emissions, :etree, p[:etree])
    setparameter(m, :emissions, :cca0, p[:cca0])

    connectparameter(m, :emissions, :YGROSS, :grosseconomy, :YGROSS)


    #CO2 CYCLE COMPONENT
    setparameter(m, :co2cycle, :mat0, p[:mat0])
    setparameter(m, :co2cycle, :mu0, p[:mu0])
    setparameter(m, :co2cycle, :ml0, p[:ml0])
    setparameter(m, :co2cycle, :b12, p[:b12])
    setparameter(m, :co2cycle, :b23, p[:b23])
    setparameter(m, :co2cycle, :b11, p[:b11])
    setparameter(m, :co2cycle, :b21, p[:b21])
    setparameter(m, :co2cycle, :b22, p[:b22])
    setparameter(m, :co2cycle, :b32, p[:b32])
    setparameter(m, :co2cycle, :b33, p[:b33])

    connectparameter(m, :co2cycle, :E, :emissions, :E)


    #RADIATIVE FORCING COMPONENT
    setparameter(m, :radiativeforcing, :forcoth, p[:forcoth])
    setparameter(m, :radiativeforcing, :fco22x, p[:fco22x])
    setparameter(m, :radiativeforcing, :eqmat, p[:eqmat])

    connectparameter(m, :radiativeforcing, :MAT, :co2cycle, :MAT)


    #CLIMATE DYNAMICS COMPONENT
    setparameter(m, :climatedynamics, :fco22x, p[:fco22x])
    setparameter(m, :climatedynamics, :t2xco2, p[:t2xco2])
    setparameter(m, :climatedynamics, :tatm0, p[:tatm0])
    setparameter(m, :climatedynamics, :tocean0, p[:tocean0])
    setparameter(m, :climatedynamics, :c1, p[:c1])
    setparameter(m, :climatedynamics, :c3, p[:c3])
    setparameter(m, :climatedynamics, :c4, p[:c4])

    connectparameter(m, :climatedynamics, :FORC, :radiativeforcing, :FORC)


    #DAMAGES COMPONENT
    setparameter(m, :damages, :a1, p[:a1])
    setparameter(m, :damages, :a2, p[:a2])
    setparameter(m, :damages, :a3, p[:a3])
    setparameter(m, :damages, :damadj, p[:damadj])
    setparameter(m, :damages, :usedamadj, p[:usedamadj])

    connectparameter(m, :damages, :TATM, :climatedynamics, :TATM)
    connectparameter(m, :damages, :YGROSS, :grosseconomy, :YGROSS)


    #NET ECONOMY COMPONENT
    setparameter(m, :neteconomy, :cost1, p[:cost1])
    setparameter(m, :neteconomy, :MIU, p[:MIU])
    setparameter(m, :neteconomy, :expcost2, p[:expcost2])
    setparameter(m, :neteconomy, :partfract, p[:partfract])
    setparameter(m, :neteconomy, :pbacktime, p[:pbacktime])
    setparameter(m, :neteconomy, :S, p[:S])
    setparameter(m, :neteconomy, :l, p[:l])

    connectparameter(m, :neteconomy, :YGROSS, :grosseconomy, :YGROSS)
    connectparameter(m, :neteconomy, :DAMAGES, :damages, :DAMAGES)


    #WELFARE COMPONENT
    setparameter(m, :welfare, :l, p[:l])
    setparameter(m, :welfare, :elasmu, p[:elasmu])
    setparameter(m, :welfare, :rr, p[:rr])
    setparameter(m, :welfare, :scale1, p[:scale1])
    setparameter(m, :welfare, :scale2, p[:scale2])

    connectparameter(m, :welfare, :CPC, :neteconomy, :CPC)

    return m
end


function getdiceexcel(;datafile = joinpath(dirname(@__FILE__), "..", "Data", "DICE_2013_Excel.xlsm"))
    params = getdice2013excelparameters(datafile)

    m=constructdice(params)

    return m
end

function getdicegams(;datafile = joinpath(dirname(@__FILE__), "..", "Data", "DICE2013_IAMF_Parameters.xlsx"))
    params = getdice2013gamsparameters(datafile)

    m=constructdice(params)

    return m
end
