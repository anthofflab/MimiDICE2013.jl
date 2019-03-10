module MimiDICE2013

using Mimi
using ExcelReaders

include("helpers.jl")
include("parameters.jl")

include("marginaldamage.jl")

include("components/grosseconomy_component.jl")
include("components/emissions_component.jl")
include("components/co2cycle_component.jl")
include("components/radiativeforcing_component.jl")
include("components/climatedynamics_component.jl")
include("components/damages_component.jl")
include("components/neteconomy_component.jl")
include("components/welfare_component.jl")

export constructdice, getdiceexcel, getdicegams, getmarginal_dice_models

function constructdice(p)

    m = Model()
    set_dimension!(m, :time, 2010:5:2305)

    add_comp!(m, grosseconomy, :grosseconomy)
    add_comp!(m, emissions, :emissions)
    add_comp!(m, co2cycle, :co2cycle)
    add_comp!(m, radiativeforcing, :radiativeforcing)
    add_comp!(m, climatedynamics, :climatedynamics)
    add_comp!(m, damages, :damages)
    add_comp!(m, neteconomy, :neteconomy)
    add_comp!(m, welfare, :welfare)

    # GROSS ECONOMY COMPONENT
    set_param!(m, :grosseconomy, :al, p[:al])
    set_param!(m, :grosseconomy, :l, p[:l])
    set_param!(m, :grosseconomy, :gama, p[:gama])
    set_param!(m, :grosseconomy, :dk, p[:dk])
    set_param!(m, :grosseconomy, :k0, p[:k0])

    # Note: offset=1 => dependence is on on prior timestep, i.e., not a cycle
    connect_param!(m, :grosseconomy, :I, :neteconomy, :I)

    # EMISSIONS COMPONENT
    set_param!(m, :emissions, :sigma, p[:sigma])
    set_param!(m, :emissions, :MIU, p[:MIU])
    set_param!(m, :emissions, :etree, p[:etree])
    set_param!(m, :emissions, :cca0, p[:cca0])
    connect_param!(m, :emissions, :YGROSS, :grosseconomy, :YGROSS)

    # CO2 CYCLE COMPONENT
    set_param!(m, :co2cycle, :mat0, p[:mat0])
    set_param!(m, :co2cycle, :mu0, p[:mu0])
    set_param!(m, :co2cycle, :ml0, p[:ml0])
    set_param!(m, :co2cycle, :b12, p[:b12])
    set_param!(m, :co2cycle, :b23, p[:b23])
    set_param!(m, :co2cycle, :b11, p[:b11])
    set_param!(m, :co2cycle, :b21, p[:b21])
    set_param!(m, :co2cycle, :b22, p[:b22])
    set_param!(m, :co2cycle, :b32, p[:b32])
    set_param!(m, :co2cycle, :b33, p[:b33])
    connect_param!(m, :co2cycle, :E, :emissions, :E)

    # RADIATIVE FORCING COMPONENT
    set_param!(m, :radiativeforcing, :forcoth, p[:forcoth])
    set_param!(m, :radiativeforcing, :fco22x, p[:fco22x])
    set_param!(m, :radiativeforcing, :eqmat, p[:eqmat])
    connect_param!(m, :radiativeforcing, :MAT, :co2cycle, :MAT)

    # CLIMATE DYNAMICS COMPONENT
    set_param!(m, :climatedynamics, :fco22x, p[:fco22x])
    set_param!(m, :climatedynamics, :t2xco2, p[:t2xco2])
    set_param!(m, :climatedynamics, :tatm0, p[:tatm0])
    set_param!(m, :climatedynamics, :tocean0, p[:tocean0])
    set_param!(m, :climatedynamics, :c1, p[:c1])
    set_param!(m, :climatedynamics, :c3, p[:c3])
    set_param!(m, :climatedynamics, :c4, p[:c4])
    connect_param!(m, :climatedynamics, :FORC, :radiativeforcing, :FORC)

    # DAMAGES COMPONENT
    set_param!(m, :damages, :a1, p[:a1])
    set_param!(m, :damages, :a2, p[:a2])
    set_param!(m, :damages, :a3, p[:a3])
    set_param!(m, :damages, :damadj, p[:damadj])
    set_param!(m, :damages, :usedamadj, p[:usedamadj])
    connect_param!(m, :damages, :TATM, :climatedynamics, :TATM)
    connect_param!(m, :damages, :YGROSS, :grosseconomy, :YGROSS)

    # NET ECONOMY COMPONENT
    set_param!(m, :neteconomy, :cost1, p[:cost1])
    set_param!(m, :neteconomy, :MIU, p[:MIU])
    set_param!(m, :neteconomy, :expcost2, p[:expcost2])
    set_param!(m, :neteconomy, :partfract, p[:partfract])
    set_param!(m, :neteconomy, :pbacktime, p[:pbacktime])
    set_param!(m, :neteconomy, :S, p[:S])
    set_param!(m, :neteconomy, :l, p[:l])
    connect_param!(m, :neteconomy, :YGROSS, :grosseconomy, :YGROSS)
    connect_param!(m, :neteconomy, :DAMAGES, :damages, :DAMAGES)

    # WELFARE COMPONENT
    set_param!(m, :welfare, :l, p[:l])
    set_param!(m, :welfare, :elasmu, p[:elasmu])
    set_param!(m, :welfare, :rr, p[:rr])
    set_param!(m, :welfare, :scale1, p[:scale1])
    set_param!(m, :welfare, :scale2, p[:scale2])
    connect_param!(m, :welfare, :CPC, :neteconomy, :CPC)

    return m

end

function getdiceexcel(;datafile = joinpath(dirname(@__FILE__), "..", "Data", "DICE_2013_Excel.xlsm"))
    params = getdice2013excelparameters(datafile)

    m = constructdice(params)

    return m
end

function getdicegams(;datafile = joinpath(dirname(@__FILE__), "..", "Data", "DICE2013_IAMF_Parameters.xlsx"))
    params = getdice2013gamsparameters(datafile)

    m = constructdice(params)

    return m
end

end # module
