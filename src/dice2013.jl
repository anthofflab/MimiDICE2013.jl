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

    a1          = p[:a1]
    a2          = p[:a2]
    a3          = p[:a3]
    al          = p[:al]
    b11         = p[:b11]
    b12         = p[:b12]
    b21         = p[:b21]
    b22         = p[:b22]
    b23         = p[:b23]
    b32         = p[:b32]
    b33         = p[:b33]
    c1          = p[:c1]
    c3          = p[:c3]
    c4          = p[:c4]
    cca0        = p[:cca0]
    cost1       = p[:cost1]
    damadj      = p[:damadj]
    dk          = p[:dk]
    elasmu      = p[:elasmu]
    eqmat       = p[:eqmat]
    etree       = p[:etree]
    expcost2    = p[:expcost2]
    fco22x      = p[:fco22x]
    forcoth     = p[:forcoth]
    fosslim     = p[:fosslim]
    gama        = p[:gama]
    k0          = p[:k0]
    l           = p[:l]
    mat0        = p[:mat0]
    MIU         = p[:MIU]
    ml0         = p[:ml0]
    mu0         = p[:mu0]
    partfract   = p[:partfract]
    pbacktime   = p[:pbacktime]
    rr          = p[:rr]
    S           = p[:S]
    scale1      = p[:scale1]
    scale2      = p[:scale2]
    sigma       = p[:sigma]
    t2xco2      = p[:t2xco2]
    tatm0       = p[:tatm0]
    tocean0     = p[:tocean0]

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
    setparameter(m, :grosseconomy, :al, al)
    setparameter(m, :grosseconomy, :l, l)
    setparameter(m, :grosseconomy, :gama, gama)
    setparameter(m, :grosseconomy, :dk, dk)
    setparameter(m, :grosseconomy, :k0, k0)

    connectparameter(m, :grosseconomy, :I, :neteconomy, :I)


    #EMISSIONS COMPONENT
    setparameter(m, :emissions, :sigma, sigma)
    setparameter(m, :emissions, :MIU, MIU)
    setparameter(m, :emissions, :etree, etree)
    setparameter(m, :emissions, :cca0, cca0)

    connectparameter(m, :emissions, :YGROSS, :grosseconomy, :YGROSS)


    #CO2 CYCLE COMPONENT
    setparameter(m, :co2cycle, :mat0, mat0)
    setparameter(m, :co2cycle, :mu0, mu0)
    setparameter(m, :co2cycle, :ml0, ml0)
    setparameter(m, :co2cycle, :b12, b12)
    setparameter(m, :co2cycle, :b23, b23)
    setparameter(m, :co2cycle, :b11, b11)
    setparameter(m, :co2cycle, :b21, b21)
    setparameter(m, :co2cycle, :b22, b22)
    setparameter(m, :co2cycle, :b32, b32)
    setparameter(m, :co2cycle, :b33, b33)

    connectparameter(m, :co2cycle, :E, :emissions, :E)


    #RADIATIVE FORCING COMPONENT
    setparameter(m, :radiativeforcing, :forcoth, forcoth)
    setparameter(m, :radiativeforcing, :fco22x, fco22x)
    setparameter(m, :radiativeforcing, :eqmat, eqmat)

    connectparameter(m, :radiativeforcing, :MAT, :co2cycle, :MAT)


    #CLIMATE DYNAMICS COMPONENT
    setparameter(m, :climatedynamics, :fco22x, fco22x)
    setparameter(m, :climatedynamics, :t2xco2, t2xco2)
    setparameter(m, :climatedynamics, :tatm0, tatm0)
    setparameter(m, :climatedynamics, :tocean0, tocean0)
    setparameter(m, :climatedynamics, :c1, c1)
    setparameter(m, :climatedynamics, :c3, c3)
    setparameter(m, :climatedynamics, :c4, c4)

    connectparameter(m, :climatedynamics, :FORC, :radiativeforcing, :FORC)


    #DAMAGES COMPONENT
    setparameter(m, :damages, :a1, a1)
    setparameter(m, :damages, :a2, a2)
    setparameter(m, :damages, :a3, a3)
    setparameter(m, :damages, :damadj, damadj)

    connectparameter(m, :damages, :TATM, :climatedynamics, :TATM)
    connectparameter(m, :damages, :YGROSS, :grosseconomy, :YGROSS)


    #NET ECONOMY COMPONENT
    setparameter(m, :neteconomy, :cost1, cost1)
    setparameter(m, :neteconomy, :MIU, MIU)
    setparameter(m, :neteconomy, :expcost2, expcost2)
    setparameter(m, :neteconomy, :partfract, partfract)
    setparameter(m, :neteconomy, :pbacktime, pbacktime)
    setparameter(m, :neteconomy, :S, S)
    setparameter(m, :neteconomy, :l, l)

    connectparameter(m, :neteconomy, :YGROSS, :grosseconomy, :YGROSS)
    connectparameter(m, :neteconomy, :DAMAGES, :damages, :DAMAGES)


    #WELFARE COMPONENT
    setparameter(m, :welfare, :l, l)
    setparameter(m, :welfare, :elasmu, elasmu)
    setparameter(m, :welfare, :rr, rr)
    setparameter(m, :welfare, :scale1, scale1)
    setparameter(m, :welfare, :scale2, scale2)

    connectparameter(m, :welfare, :CPC, :neteconomy, :CPC)

    return m
end


function getdice(;datafile = "../Data/DICE_2013_Excel.xlsm")
    params = getdice2013parameters(datafile)

    m=constructdice(params)

    return m
end







