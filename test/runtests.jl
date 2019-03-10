using Test
using ExcelReaders
using DataFrames
using Mimi
using MimiDICE2013
using CSVFiles

using MimiDICE2013: getparams

@testset "MimiDICE2013" begin

#------------------------------------------------------------------------------
#   1. Run tests on the whole model
#------------------------------------------------------------------------------

@testset "MimiDICE2013-model" begin

m = getdiceexcel();
run(m)

f = openxl(joinpath(dirname(@__FILE__), "..", "Data", "DICE_2013_Excel.xlsm"))

#Test Precision
Precision = 1.0e-11

#Time Periods
T=60

#TATM Test (temperature increase)
True_TATM = getparams(f, "B99:BI99", :all, "Base", T);
@test maximum(abs, m[:climatedynamics, :TATM] .- True_TATM) ≈ 0. atol = Precision

#MAT Test (carbon concentration atmosphere)
True_MAT = getparams(f, "B87:BI87", :all, "Base", T);
@test maximum(abs, m[:co2cycle, :MAT] .- True_MAT) ≈ 0. atol = Precision

#DAMFRAC Test (damages fraction)
True_DAMFRAC = getparams(f, "B105:BI105", :all, "Base", T);
@test maximum(abs, m[:damages, :DAMFRAC] .- True_DAMFRAC) ≈ 0. atol = Precision

#DAMAGES Test (damages $)
True_DAMAGES = getparams(f, "B106:BI106", :all, "Base", T);
@test maximum(abs, m[:damages, :DAMAGES] .- True_DAMAGES) ≈ 0. atol = Precision

#E Test (emissions)
True_E = getparams(f, "B112:BI112", :all, "Base", T);
@test maximum(abs, m[:emissions, :E] .- True_E) ≈ 0. atol = Precision

#YGROSS Test (gross output)
True_YGROSS = getparams(f, "B104:BI104", :all, "Base", T);
@test maximum(abs, m[:grosseconomy, :YGROSS] .- True_YGROSS) ≈ 0. atol = Precision

#CPC Test (per capita consumption)
True_CPC = getparams(f, "B126:BI126", :all, "Base", T);
@test maximum(abs, m[:neteconomy, :CPC] .- True_CPC) ≈ 0. atol = Precision

#FORC Test (radiative forcing)
True_FORC = getparams(f, "B100:BI100", :all, "Base", T);
@test maximum(abs, m[:radiativeforcing, :FORC] .- True_FORC) ≈ 0. atol = Precision

True_UTILITY = getparams(f, "B129:B129", :single, "Base", T);
@test maximum(abs, m[:welfare, :UTILITY] .- True_UTILITY) ≈ 0. atol = Precision

end #MimiDICE2013-model testset


#------------------------------------------------------------------------------
#   2. Run tests to make sure integration version (Mimi v0.5.0)
#   values match Mimi 0.4.0 values
#------------------------------------------------------------------------------

@testset "MimiDICE2013-integration" begin

Precision = 1.0e-11
nullvalue = -999.999

m = getdiceexcel();
run(m)

for c in map(name, Mimi.compdefs(m)), v in Mimi.variable_names(m, c)
    
    #load data for comparison
    filepath = joinpath(@__DIR__, "../data/validation_data_v040/$c-$v.csv")        
    results = m[c, v]

    df = load(filepath) |> DataFrame
    if typeof(results) <: Number
        validation_results = df[1,1]
        
    else
        validation_results = convert(Array, df)

        #remove NaNs
        results[ismissing.(results)] .= nullvalue
        results[isnan.(results)] .= nullvalue
        validation_results[isnan.(validation_results)] .= nullvalue
  
        #match dimensions
        if size(validation_results,1) == 1
            validation_results = validation_results'
        end

    end
    @test results ≈ validation_results atol = Precision
    
end #for loop

end #MimiDICE2013-integration testset

end #MimiDICE2013 testset

nothing
