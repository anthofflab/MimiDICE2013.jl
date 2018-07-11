using Base.Test
using ExcelReaders
using DataTables

include("../src/dice2013.jl")
using dice2013

@testset "DICE2013" begin

#------------------------------------------------------------------------------
#   1. Run tests on the whole model
#------------------------------------------------------------------------------

@testset "DICE2013-model" begin

# m = getdiceexcel();
m = dice2013.DICE
run(m)

f = openxl(joinpath(dirname(@__FILE__), "..", "Data", "DICE_2013_Excel.xlsm"))

#Test Precision
Precision = 1.0e-11

#Time Periods
T=60

#TATM Test (temperature increase)
True_TATM = dice2013.getparams(f, "B99:BI99", :all, "Base", T);
@test maximum(abs, m[:climatedynamics, :TATM] .- True_TATM) ≈ 0. atol = Precision

#MAT Test (carbon concentration atmosphere)
True_MAT = dice2013.getparams(f, "B87:BI87", :all, "Base", T);
@test maximum(abs, m[:co2cycle, :MAT] .- True_MAT) ≈ 0. atol = Precision

#DAMFRAC Test (damages fraction)
True_DAMFRAC = dice2013.getparams(f, "B105:BI105", :all, "Base", T);
@test maximum(abs, m[:damages, :DAMFRAC] .- True_DAMFRAC) ≈ 0. atol = Precision

#DAMAGES Test (damages $)
True_DAMAGES = dice2013.getparams(f, "B106:BI106", :all, "Base", T);
@test maximum(abs, m[:damages, :DAMAGES] .- True_DAMAGES) ≈ 0. atol = Precision

#E Test (emissions)
True_E = dice2013.getparams(f, "B112:BI112", :all, "Base", T);
@test maximum(abs, m[:emissions, :E] .- True_E) ≈ 0. atol = Precision

#YGROSS Test (gross output)
True_YGROSS = dice2013.getparams(f, "B104:BI104", :all, "Base", T);
@test maximum(abs, m[:grosseconomy, :YGROSS] .- True_YGROSS) ≈ 0. atol = Precision

#CPC Test (per capita consumption)
True_CPC = dice2013.getparams(f, "B126:BI126", :all, "Base", T);
@test maximum(abs, m[:neteconomy, :CPC] .- True_CPC) ≈ 0. atol = Precision

#FORC Test (radiative forcing)
True_FORC = dice2013.getparams(f, "B100:BI100", :all, "Base", T);
@test maximum(abs, m[:radiativeforcing, :FORC] .- True_FORC) ≈ 0. atol = Precision

True_UTILITY = dice2013.getparams(f, "B129:B129", :single, "Base", T);
@test maximum(abs, m[:welfare, :UTILITY] .- True_UTILITY) ≈ 0. atol = Precision

end #DICE2013-model testset


#------------------------------------------------------------------------------
#   2. Run tests to make sure integration version (Mimi v0.5.0)
#   values match Mimi 0.4.0 values
#------------------------------------------------------------------------------

@testset "DICE2013-integration" begin

Mimi.reset_compdefs()

Precision = 1.0e-11
nullvalue = -999.999

m = dice2013.DICE
run(m)

for c in map(name, Mimi.compdefs(m)), v in Mimi.variable_names(m, c)
    
    #load data for comparison
    filepath = "../data/validation_data_v040/$c-$v.csv"        
    results = m[c, v]

    if typeof(results) <: Number
        validation_results = DataFrames.readtable(filepath)[1,1]
        
    else
        validation_results = convert(Array, DataFrames.readtable(filepath))

        #match dimensions
        if size(validation_results,1) == 1
            validation_results = validation_results'
        end

        #remove NaNs
        results[isnan.(results)] = nullvalue
        validation_results[isnan.(validation_results)] = nullvalue
        
    end
    @test results ≈ validation_results atol = Precision
    
end #for loop

end #DICE2013-integration testset

end #DICE2013 testset

nothing
