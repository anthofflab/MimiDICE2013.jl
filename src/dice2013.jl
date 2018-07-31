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

add_comp!(DICE, grosseconomy, :grosseconomy)
add_comp!(DICE, emissions, :emissions)
add_comp!(DICE, co2cycle, :co2cycle)
add_comp!(DICE, radiativeforcing, :radiativeforcing)
add_comp!(DICE, climatedynamics, :climatedynamics)
add_comp!(DICE, damages, :damages)
add_comp!(DICE, neteconomy, :neteconomy)
add_comp!(DICE, welfare, :welfare)

# GROSS ECONOMY COMPONENT
set_param!(DICE, :grosseconomy, :al, p[:al])
set_param!(DICE, :grosseconomy, :l, p[:l])
set_param!(DICE, :grosseconomy, :gama, p[:gama])
set_param!(DICE, :grosseconomy, :dk, p[:dk])
set_param!(DICE, :grosseconomy, :k0, p[:k0])

# Note: offset=1 => dependence is on on prior timestep, i.e., not a cycle
connect_param!(DICE, :grosseconomy, :I, :neteconomy, :I, offset=1)

# EMISSIONS COMPONENT
set_param!(DICE, :emissions, :sigma, p[:sigma])
set_param!(DICE, :emissions, :MIU, p[:MIU])
set_param!(DICE, :emissions, :etree, p[:etree])
set_param!(DICE, :emissions, :cca0, p[:cca0])
connect_param!(DICE, :emissions, :YGROSS, :grosseconomy, :YGROSS, offset=0)

# CO2 CYCLE COMPONENT
set_param!(DICE, :co2cycle, :mat0, p[:mat0])
set_param!(DICE, :co2cycle, :mu0, p[:mu0])
set_param!(DICE, :co2cycle, :ml0, p[:ml0])
set_param!(DICE, :co2cycle, :b12, p[:b12])
set_param!(DICE, :co2cycle, :b23, p[:b23])
set_param!(DICE, :co2cycle, :b11, p[:b11])
set_param!(DICE, :co2cycle, :b21, p[:b21])
set_param!(DICE, :co2cycle, :b22, p[:b22])
set_param!(DICE, :co2cycle, :b32, p[:b32])
set_param!(DICE, :co2cycle, :b33, p[:b33])
connect_param!(DICE, :co2cycle, :E, :emissions, :E, offset=0)

# RADIATIVE FORCING COMPONENT
set_param!(DICE, :radiativeforcing, :forcoth, p[:forcoth])
set_param!(DICE, :radiativeforcing, :fco22x, p[:fco22x])
set_param!(DICE, :radiativeforcing, :eqmat, p[:eqmat])
connect_param!(DICE, :radiativeforcing, :MAT, :co2cycle, :MAT, offset=0)

# CLIMATE DYNAMICS COMPONENT
set_param!(DICE, :climatedynamics, :fco22x, p[:fco22x])
set_param!(DICE, :climatedynamics, :t2xco2, p[:t2xco2])
set_param!(DICE, :climatedynamics, :tatm0, p[:tatm0])
set_param!(DICE, :climatedynamics, :tocean0, p[:tocean0])
set_param!(DICE, :climatedynamics, :c1, p[:c1])
set_param!(DICE, :climatedynamics, :c3, p[:c3])
set_param!(DICE, :climatedynamics, :c4, p[:c4])
connect_param!(DICE, :climatedynamics, :FORC, :radiativeforcing, :FORC, offset=0)

# DAMAGES COMPONENT
set_param!(DICE, :damages, :a1, p[:a1])
set_param!(DICE, :damages, :a2, p[:a2])
set_param!(DICE, :damages, :a3, p[:a3])
set_param!(DICE, :damages, :damadj, p[:damadj])
set_param!(DICE, :damages, :usedamadj, p[:usedamadj])
connect_param!(DICE, :damages, :TATM, :climatedynamics, :TATM, offset=0)
connect_param!(DICE, :damages, :YGROSS, :grosseconomy, :YGROSS, offset=0)

# NET ECONOMY COMPONENT
set_param!(DICE, :neteconomy, :cost1, p[:cost1])
set_param!(DICE, :neteconomy, :MIU, p[:MIU])
set_param!(DICE, :neteconomy, :expcost2, p[:expcost2])
set_param!(DICE, :neteconomy, :partfract, p[:partfract])
set_param!(DICE, :neteconomy, :pbacktime, p[:pbacktime])
set_param!(DICE, :neteconomy, :S, p[:S])
set_param!(DICE, :neteconomy, :l, p[:l])
connect_param!(DICE, :neteconomy, :YGROSS, :grosseconomy, :YGROSS, offset=0)
connect_param!(DICE, :neteconomy, :DAMAGES, :damages, :DAMAGES, offset=0)

# WELFARE COMPONENT
set_param!(DICE, :welfare, :l, p[:l])
set_param!(DICE, :welfare, :elasmu, p[:elasmu])
set_param!(DICE, :welfare, :rr, p[:rr])
set_param!(DICE, :welfare, :scale1, p[:scale1])
set_param!(DICE, :welfare, :scale2, p[:scale2])
connect_param!(DICE, :welfare, :CPC, :neteconomy, :CPC, offset=0)

end # module
