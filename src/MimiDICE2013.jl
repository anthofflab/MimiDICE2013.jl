module MimiDICE2013

using Mimi
using XLSX: readxlsx

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

export constructdice, getdiceexcel, getdicegams

const model_years = 2010:5:2305

function constructdice(params_dict)

    m = Model()
    set_dimension!(m, :time, model_years)

    # --------------------------------------------------------------------------
    # Add components in order
    # --------------------------------------------------------------------------

    add_comp!(m, grosseconomy, :grosseconomy)
    add_comp!(m, emissions, :emissions)
    add_comp!(m, co2cycle, :co2cycle)
    add_comp!(m, radiativeforcing, :radiativeforcing)
    add_comp!(m, climatedynamics, :climatedynamics)
    add_comp!(m, damages, :damages)
    add_comp!(m, neteconomy, :neteconomy)
    add_comp!(m, welfare, :welfare)

    # --------------------------------------------------------------------------
    # Make internal parameter connections
    # --------------------------------------------------------------------------

    # Emissions
    connect_param!(m, :grosseconomy, :I, :neteconomy, :I)
    connect_param!(m, :emissions, :YGROSS, :grosseconomy, :YGROSS)

    # Climate
    connect_param!(m, :co2cycle, :E, :emissions, :E)
    connect_param!(m, :radiativeforcing, :MAT, :co2cycle, :MAT)
    connect_param!(m, :climatedynamics, :FORC, :radiativeforcing, :FORC)

    # Damages
    connect_param!(m, :damages, :TATM, :climatedynamics, :TATM)
    connect_param!(m, :damages, :YGROSS, :grosseconomy, :YGROSS)
    connect_param!(m, :neteconomy, :YGROSS, :grosseconomy, :YGROSS)
    connect_param!(m, :neteconomy, :DAMAGES, :damages, :DAMAGES)
    connect_param!(m, :welfare, :CPC, :neteconomy, :CPC)

    # --------------------------------------------------------------------------
    # Set external parameter values 
    # --------------------------------------------------------------------------

    # Set unshared parameters - name is a Tuple{Symbol, Symbol} of (component_name, param_name)
    for (name, value) in params_dict[:unshared]
        update_param!(m, name[1], name[2], value)
    end

    # Set shared parameters - name is a Symbol representing the param_name, here
    # we will create a shared model parameter with the same name as the component
    # parameter and then connect our component parameters to this shared model parameter

    # * for convenience later, name shared model parameter same as the component 
    # parameters, but this is not required could give a unique name *

    add_shared_param!(m, :fco22x, params_dict[:shared][:fco22x])
    connect_param!(m, :climatedynamics, :fco22x, :fco22x)
    connect_param!(m, :radiativeforcing, :fco22x, :fco22x)

    add_shared_param!(m, :MIU, params_dict[:shared][:MIU], dims=[:time])
    connect_param!(m, :neteconomy, :MIU, :MIU)
    connect_param!(m, :emissions, :MIU, :MIU)

    add_shared_param!(m, :l, params_dict[:shared][:l], dims=[:time])
    connect_param!(m, :neteconomy, :l, :l)
    connect_param!(m, :grosseconomy, :l, :l)
    connect_param!(m, :welfare, :l, :l)

    return m

end

function getdiceexcel(; datafile=joinpath(dirname(@__FILE__), "..", "data", "DICE_2013_Excel.xlsm"))
    params_dict = getdice2013excelparameters(datafile)

    m = constructdice(params_dict)

    return m
end

function getdicegams(; datafile=joinpath(dirname(@__FILE__), "..", "data", "DICE2013_IAMF_Parameters.xlsx"))
    params_dict = getdice2013gamsparameters(datafile)

    m = constructdice(params_dict)

    return m
end

# get_model function for standard Mimi API: use the Excel version
get_model = getdiceexcel

end # module
