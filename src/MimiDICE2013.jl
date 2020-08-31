module MimiDICE2013

using Mimi
using ExcelReaders

include("helpers.jl")
include("parameters.jl")
include("mcs.jl")
include("marginaldamage.jl")
include("montecarloscc.jl")
include("mcsv2.jl")

include("components/grosseconomy_component.jl")
include("components/emissions_component.jl")
include("components/co2cycle_component.jl")
include("components/radiativeforcing_component.jl")
include("components/climatedynamics_component.jl")
include("components/damages_component.jl")
include("components/neteconomy_component.jl")
include("components/welfare_component.jl")

export constructdice, getdiceexcel, getdicegams, getsim, getsimv2

const model_years = 2010:5:2305

function constructdice(p)

    m = Model()
    set_dimension!(m, :time, model_years)

    add_comp!(m, grosseconomy, :grosseconomy)
    add_comp!(m, emissions, :emissions)
    add_comp!(m, co2cycle, :co2cycle)
    add_comp!(m, radiativeforcing, :radiativeforcing)
    add_comp!(m, climatedynamics, :climatedynamics)
    add_comp!(m, damages, :damages)
    add_comp!(m, neteconomy, :neteconomy)
    add_comp!(m, welfare, :welfare)

    # GROSS ECONOMY COMPONENT
    set_param!(m, :grosseconomy, :a0, p[:a0])
    set_param!(m, :grosseconomy, :ga0, p[:ga0])
    set_param!(m, :grosseconomy, :dela, p[:dela])
    set_param!(m, :grosseconomy, :pop0, p[:pop0])
    set_param!(m, :grosseconomy, :popadj, p[:popadj])
    set_param!(m, :grosseconomy, :popsym, p[:popsym])
    set_param!(m, :grosseconomy, :gama, p[:gama])
    set_param!(m, :grosseconomy, :dk, p[:dk])
    set_param!(m, :grosseconomy, :k0, p[:k0])
    set_param!(m, :grosseconomy, :tsteps, p[:tsteps])

    # Note: offset=1 => dependence is on on prior timestep, i.e., not a cycle
    connect_param!(m, :grosseconomy, :I, :neteconomy, :I)

    # EMISSIONS COMPONENT
    set_param!(m, :emissions, :sigma0, p[:sigma0])
    set_param!(m, :emissions, :gsigma0, p[:gsigma0])
    set_param!(m, :emissions, :dersig, p[:dersig])
    set_param!(m, :emissions, :eland0, p[:eland0])
    set_param!(m, :emissions, :deland, p[:deland])
    set_param!(m, :emissions, :MIU, p[:MIU])
    set_param!(m, :emissions, :expcost2, p[:expcost2])
    set_param!(m, :emissions, :cca0, p[:cca0])
    set_param!(m, :emissions, :pbacktime0, p[:pbacktime0])
    set_param!(m, :emissions, :partfract, p[:partfract])
    connect_param!(m, :emissions, :CPRICE, :neteconomy, :CPRICE)
    connect_param!(m, :emissions, :PBACKTIME, :neteconomy, :PBACKTIME)
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
    set_param!(m, :radiativeforcing, :fex0, p[:fex0])
    set_param!(m, :radiativeforcing, :fex1, p[:fex1])
    set_param!(m, :radiativeforcing, :fco22x, p[:fco22x])
    set_param!(m, :radiativeforcing, :eqmat, p[:eqmat])
    set_param!(m, :radiativeforcing, :tsteps, p[:tsteps])
    connect_param!(m, :radiativeforcing, :MAT, :co2cycle, :MAT)

    # CLIMATE DYNAMICS COMPONENT
    set_param!(m, :climatedynamics, :fco22x, p[:fco22x])
    set_param!(m, :climatedynamics, :t2xco2, p[:t2xco2])
    set_param!(m, :climatedynamics, :tatm0, p[:tatm0])
    set_param!(m, :climatedynamics, :tocean0, p[:tocean0])
    set_param!(m, :climatedynamics, :c1, p[:c1])
    set_param!(m, :climatedynamics, :c3, p[:c3])
    set_param!(m, :climatedynamics, :c4, p[:c4])
    set_param!(m, :climatedynamics, :a3, p[:a3])
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
    set_param!(m, :neteconomy, :expcost2, p[:expcost2])
    set_param!(m, :neteconomy, :partfract, p[:partfract])
    set_param!(m, :neteconomy, :pbacktime0, p[:pbacktime0])
    set_param!(m, :neteconomy, :pbackrate, p[:pbackrate])
    set_param!(m, :neteconomy, :S, p[:S])
    set_param!(m, :neteconomy, :MIU, p[:MIU])
    connect_param!(m, :neteconomy, :SIGMA, :emissions, :SIGMA)
    connect_param!(m, :neteconomy, :L, :grosseconomy, :L)
    connect_param!(m, :neteconomy, :YGROSS, :grosseconomy, :YGROSS)
    connect_param!(m, :neteconomy, :DAMAGES, :damages, :DAMAGES)

    # WELFARE COMPONENT
    set_param!(m, :welfare, :elasmu, p[:elasmu])
    set_param!(m, :welfare, :rr0, p[:rr0])
    set_param!(m, :welfare, :prtp, p[:prtp])
    set_param!(m, :welfare, :scale1, p[:scale1])
    set_param!(m, :welfare, :scale2, p[:scale2])
    connect_param!(m, :welfare, :CPC, :neteconomy, :CPC)
    connect_param!(m, :welfare, :L, :grosseconomy, :L)

    return m

end

function getdiceexcel(;datafile = joinpath(dirname(@__FILE__), "..", "data", "DICE_2013_Excel.xlsm"))
    params = getdice2013excelparameters(datafile)

    m = constructdice(params)

    return m
end

function getdicegams(;datafile = joinpath(dirname(@__FILE__), "..", "data", "DICE2013_IAMF_Parameters.xlsx"))
    params = getdice2013gamsparameters(datafile)

    m = constructdice(params)

    return m
end

# get_model function for standard Mimi API: use the Excel version
get_model = getdiceexcel

end # module

