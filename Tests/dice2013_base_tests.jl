using Base.Test
using Mimi
using ExcelReaders

include("dice2013.jl")
include("helpers.jl")

m = getdice();
run(m)

f=openxl("../Data/DICE_2013_Excel.xlsm")

#Test Precision
Precision = 1.0e-11

#Time Periods
T=60

#TATM Test (temperature increase)
True_TATM = getparams(f, "B99:BI99", :all, "Base", T);
@test_approx_eq_eps maxabs(m[:climatedynamics, :TATM] .- True_TATM) 0. Precision

#MAT Test (carbon concentration atmosphere)
True_MAT = getparams(f, "B87:BI87", :all, "Base", T);
@test_approx_eq_eps maxabs(m[:co2cycle, :MAT] .- True_MAT) 0. Precision

#DAMFRAC Test (damages fraction)
True_DAMFRAC = getparams(f, "B105:BI105", :all, "Base", T);
@test_approx_eq_eps maxabs(m[:damages, :DAMFRAC] .- True_DAMFRAC) 0. Precision

#DAMAGES Test (damages $)
True_DAMAGES = getparams(f, "B106:BI106", :all, "Base", T);
@test_approx_eq_eps maxabs(m[:damages, :DAMAGES] .- True_DAMAGES) 0. Precision

#E Test (emissions)
True_E = getparams(f, "B112:BI112", :all, "Base", T);
@test_approx_eq_eps maxabs(m[:emissions, :E] .- True_E) 0. Precision

#YGROSS Test (gross output)
True_YGROSS = getparams(f, "B104:BI104", :all, "Base", T);
@test_approx_eq_eps maxabs(m[:grosseconomy, :YGROSS] .- True_YGROSS) 0. Precision

#CPC Test (per capita consumption)
True_CPC = getparams(f, "B126:BI126", :all, "Base", T);
@test_approx_eq_eps maxabs(m[:neteconomy, :CPC] .- True_CPC) 0. Precision

#FORC Test (radiative forcing)
True_FORC = getparams(f, "B100:BI100", :all, "Base", T);
@test_approx_eq_eps maxabs(m[:radiativeforcing, :FORC] .- True_FORC) 0. Precision

True_UTILITY = getparams(f, "B129:B129", :single, "Base", T);
@test_approx_eq_eps maxabs(m[:welfare, :UTILITY] .- True_UTILITY) 0. Precision
