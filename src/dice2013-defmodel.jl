module dice2013

using Mimi
using ExcelReaders

include("helpers.jl")
include("parameters.jl")
include("components/grosseconomy_component.jl")
include("components/emissions_component.jl")
include("components/co2cycle_component.jl")
include("components/radiativeforcing_component.jl")
include("components/climatedynamics_component.jl")
include("components/damages_component.jl")
include("components/neteconomy_component.jl")
include("components/welfare_component.jl")

export DICE

const global datafile = joinpath(dirname(@__FILE__), "..", "Data", "DICE_2013_Excel.xlsm")

@defmodel DICE begin
    p = getdice2013excelparameters(datafile)

    index[time] = 2010:5:2305

    component(grosseconomy)
    component(emissions)
    component(co2cycle)
    component(radiativeforcing)
    component(climatedynamics)
    component(damages)
    component(neteconomy)
    component(welfare)

    # GROSS ECONOMY COMPONENT
    grosseconomy.al   = p[:al]
    grosseconomy.l    = p[:l]
    grosseconomy.gama = p[:gama]
    grosseconomy.dk   = p[:dk]
    grosseconomy.k0   = p[:k0]

    # Note that dependence is on prior timestep ("[t-1]")
    neteconomy.I[t-1] => grosseconomy.I

    # EMISSIONS COMPONENT
    emissions.sigma = p[:sigma]
    emissions.MIU   = p[:MIU]
    emissions.etree = p[:etree]
    emissions.cca0  = p[:cca0]

    grosseconomy.YGROSS => emissions.YGROSS

    # CO2 CYCLE COMPONENT
    co2cycle.mat0 = p[:mat0]
    co2cycle.mu0  = p[:mu0]
    co2cycle.ml0  = p[:ml0]
    co2cycle.b12  = p[:b12]
    co2cycle.b23  = p[:b23]
    co2cycle.b11  = p[:b11]
    co2cycle.b21  = p[:b21]
    co2cycle.b22  = p[:b22]
    co2cycle.b32  = p[:b32]
    co2cycle.b33  = p[:b33]

    emissions.E => co2cycle.E

    # RADIATIVE FORCING COMPONENT
    radiativeforcing.forcoth = p[:forcoth]
    radiativeforcing.fco22x  = p[:fco22x]
    radiativeforcing.eqmat   = p[:eqmat]

    co2cycle.MAT => radiativeforcing.MAT

    # CLIMATE DYNAMICS COMPONENT
    climatedynamics.fco22x  = p[:fco22x]
    climatedynamics.t2xco2  = p[:t2xco2]
    climatedynamics.tatm0   = p[:tatm0]
    climatedynamics.tocean0 = p[:tocean0]
    climatedynamics.c1 = p[:c1]
    climatedynamics.c3 = p[:c3]
    climatedynamics.c4 = p[:c4]

    radiativeforcing.FORC => climatedynamics.FORC

    # DAMAGES COMPONENT
    damages.a1 = p[:a1]
    damages.a2 = p[:a2]
    damages.a3 = p[:a3]
    damages.damadj    = p[:damadj]
    damages.usedamadj = p[:usedamadj]

    climatedynamics.TATM => damages.TATM
    grosseconomy.YGROSS  => damages.YGROSS

    # NET ECONOMY COMPONENT
    neteconomy.cost1 = p[:cost1]
    neteconomy.MIU = p[:MIU]
    neteconomy.expcost2 = p[:expcost2]
    neteconomy.partfract = p[:partfract]
    neteconomy.pbacktime = p[:pbacktime]
    neteconomy.S = p[:S]
    neteconomy.l = p[:l]

    grosseconomy.YGROSS => neteconomy.YGROSS
    damages.DAMAGES => neteconomy.DAMAGES

    # WELFARE COMPONENT
    welfare.l = p[:l]
    welfare.elasmu = p[:elasmu]
    welfare.rr = p[:rr]
    welfare.scale1 = p[:scale1]
    welfare.scale2 = p[:scale2]

    neteconomy.CPC => welfare.CPC
end

end # module
