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

#
# N.B. See dice2013-defmodel.jl for the @defmodel version of the following
#

const global datafile = joinpath(dirname(@__FILE__), "..", "Data", "DICE_2013_Excel.xlsm")
p = getdice2013excelparameters(datafile)

DICE = Model()
set_dimension!(DICE, :time, 2010:5:2305)

addcomponent(DICE, grosseconomy, :grosseconomy)
addcomponent(DICE, emissions, :emissions)
addcomponent(DICE, co2cycle, :co2cycle)
addcomponent(DICE, radiativeforcing, :radiativeforcing)
addcomponent(DICE, climatedynamics, :climatedynamics)
addcomponent(DICE, damages, :damages)
addcomponent(DICE, neteconomy, :neteconomy)
addcomponent(DICE, welfare, :welfare)

# GROSS ECONOMY COMPONENT
set_parameter!(DICE, :grosseconomy, :al, p[:al])
set_parameter!(DICE, :grosseconomy, :l, p[:l])
set_parameter!(DICE, :grosseconomy, :gama, p[:gama])
set_parameter!(DICE, :grosseconomy, :dk, p[:dk])
set_parameter!(DICE, :grosseconomy, :k0, p[:k0])

# Note: offset=1 => dependence is on on prior timestep, i.e., not a cycle
connect_parameter(DICE, :grosseconomy, :I, :neteconomy, :I, offset=1)

# EMISSIONS COMPONENT
set_parameter!(DICE, :emissions, :sigma, p[:sigma])
set_parameter!(DICE, :emissions, :MIU, p[:MIU])
set_parameter!(DICE, :emissions, :etree, p[:etree])
set_parameter!(DICE, :emissions, :cca0, p[:cca0])
connect_parameter(DICE, :emissions, :YGROSS, :grosseconomy, :YGROSS, offset=0)

# CO2 CYCLE COMPONENT
set_parameter!(DICE, :co2cycle, :mat0, p[:mat0])
set_parameter!(DICE, :co2cycle, :mu0, p[:mu0])
set_parameter!(DICE, :co2cycle, :ml0, p[:ml0])
set_parameter!(DICE, :co2cycle, :b12, p[:b12])
set_parameter!(DICE, :co2cycle, :b23, p[:b23])
set_parameter!(DICE, :co2cycle, :b11, p[:b11])
set_parameter!(DICE, :co2cycle, :b21, p[:b21])
set_parameter!(DICE, :co2cycle, :b22, p[:b22])
set_parameter!(DICE, :co2cycle, :b32, p[:b32])
set_parameter!(DICE, :co2cycle, :b33, p[:b33])
connect_parameter(DICE, :co2cycle, :E, :emissions, :E, offset=0)

# RADIATIVE FORCING COMPONENT
set_parameter!(DICE, :radiativeforcing, :forcoth, p[:forcoth])
set_parameter!(DICE, :radiativeforcing, :fco22x, p[:fco22x])
set_parameter!(DICE, :radiativeforcing, :eqmat, p[:eqmat])
connect_parameter(DICE, :radiativeforcing, :MAT, :co2cycle, :MAT, offset=0)

# CLIMATE DYNAMICS COMPONENT
set_parameter!(DICE, :climatedynamics, :fco22x, p[:fco22x])
set_parameter!(DICE, :climatedynamics, :t2xco2, p[:t2xco2])
set_parameter!(DICE, :climatedynamics, :tatm0, p[:tatm0])
set_parameter!(DICE, :climatedynamics, :tocean0, p[:tocean0])
set_parameter!(DICE, :climatedynamics, :c1, p[:c1])
set_parameter!(DICE, :climatedynamics, :c3, p[:c3])
set_parameter!(DICE, :climatedynamics, :c4, p[:c4])
connect_parameter(DICE, :climatedynamics, :FORC, :radiativeforcing, :FORC, offset=0)

# DAMAGES COMPONENT
set_parameter!(DICE, :damages, :a1, p[:a1])
set_parameter!(DICE, :damages, :a2, p[:a2])
set_parameter!(DICE, :damages, :a3, p[:a3])
set_parameter!(DICE, :damages, :damadj, p[:damadj])
set_parameter!(DICE, :damages, :usedamadj, p[:usedamadj])
connect_parameter(DICE, :damages, :TATM, :climatedynamics, :TATM, offset=0)
connect_parameter(DICE, :damages, :YGROSS, :grosseconomy, :YGROSS, offset=0)

# NET ECONOMY COMPONENT
set_parameter!(DICE, :neteconomy, :cost1, p[:cost1])
set_parameter!(DICE, :neteconomy, :MIU, p[:MIU])
set_parameter!(DICE, :neteconomy, :expcost2, p[:expcost2])
set_parameter!(DICE, :neteconomy, :partfract, p[:partfract])
set_parameter!(DICE, :neteconomy, :pbacktime, p[:pbacktime])
set_parameter!(DICE, :neteconomy, :S, p[:S])
set_parameter!(DICE, :neteconomy, :l, p[:l])
connect_parameter(DICE, :neteconomy, :YGROSS, :grosseconomy, :YGROSS, offset=0)
connect_parameter(DICE, :neteconomy, :DAMAGES, :damages, :DAMAGES, offset=0)

# WELFARE COMPONENT
set_parameter!(DICE, :welfare, :l, p[:l])
set_parameter!(DICE, :welfare, :elasmu, p[:elasmu])
set_parameter!(DICE, :welfare, :rr, p[:rr])
set_parameter!(DICE, :welfare, :scale1, p[:scale1])
set_parameter!(DICE, :welfare, :scale2, p[:scale2])
connect_parameter(DICE, :welfare, :CPC, :neteconomy, :CPC, offset=0)

add_connector_comps(DICE)

end # module
