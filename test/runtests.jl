using Base.Test
using Mimi
using ExcelReaders

include("../src/dice2013.jl")

@testset "DICE2013" begin

m = getdiceexcel();
run(m)

f=openxl(joinpath(dirname(@__FILE__), "..", "Data", "DICE_2013_Excel.xlsm"))

#Test Precision
Precision = 1.0e-11

#Time Periods
T=60

#TATM Test (temperature increase)
True_TATM = getparams(f, "B99:BI99", :all, "Base", T);
@test maxabs(m[:climatedynamics, :TATM] .- True_TATM) ≈ 0. atol = Precision

#MAT Test (carbon concentration atmosphere)
True_MAT = getparams(f, "B87:BI87", :all, "Base", T);
@test maxabs(m[:co2cycle, :MAT] .- True_MAT) ≈ 0. atol = Precision

#DAMFRAC Test (damages fraction)
True_DAMFRAC = getparams(f, "B105:BI105", :all, "Base", T);
@test maxabs(m[:damages, :DAMFRAC] .- True_DAMFRAC) ≈ 0. atol = Precision

#DAMAGES Test (damages $)
True_DAMAGES = getparams(f, "B106:BI106", :all, "Base", T);
@test maxabs(m[:damages, :DAMAGES] .- True_DAMAGES) ≈ 0. atol = Precision

#E Test (emissions)
True_E = getparams(f, "B112:BI112", :all, "Base", T);
@test maxabs(m[:emissions, :E] .- True_E) ≈ 0. atol = Precision

#YGROSS Test (gross output)
True_YGROSS = getparams(f, "B104:BI104", :all, "Base", T);
@test maxabs(m[:grosseconomy, :YGROSS] .- True_YGROSS) ≈ 0. atol = Precision

#CPC Test (per capita consumption)
True_CPC = getparams(f, "B126:BI126", :all, "Base", T);
@test maxabs(m[:neteconomy, :CPC] .- True_CPC) ≈ 0. atol = Precision

#FORC Test (radiative forcing)
True_FORC = getparams(f, "B100:BI100", :all, "Base", T);
@test maxabs(m[:radiativeforcing, :FORC] .- True_FORC) ≈ 0. atol = Precision

True_UTILITY = getparams(f, "B129:B129", :single, "Base", T);
@test maxabs(m[:welfare, :UTILITY] .- True_UTILITY) ≈ 0. atol = Precision

end
