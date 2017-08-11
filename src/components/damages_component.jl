using Mimi


@defcomp damages begin
    DAMAGES = Variable(index=[time])    #Damages (trillions 2005 USD per year)
    DAMFRAC = Variable(index=[time])    #Increase in temperature of atmosphere (degrees C from 1900)

    TATM    = Parameter(index=[time])   #Increase temperature of atmosphere (degrees C from 1900)
    YGROSS  = Parameter(index=[time])   #Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
    a1      = Parameter()               #Damage intercept
    a2      = Parameter()               #Damage quadratic term
    a3      = Parameter()               #Damage exponent
    damadj  = Parameter()               #Adjustment exponent in damage function
    usedamadj::Bool = Parameter()       # Only the Excel version uses the damadj parameter
end


function run_timestep(state::damages, t::Int)
    v = state.Variables
    p = state.Parameters

    #Define function for DAMFRAC
    v.DAMFRAC[t] = p.a1 * p.TATM[t] + p.a2 * p.TATM[t] ^ p.a3

    #Define function for DAMAGES
    if p.usedamadj
        # Excel version
        v.DAMAGES[t] = p.YGROSS[t] * v.DAMFRAC[t] / (1 + v.DAMFRAC[t] ^ p.damadj)
    else
        # GAMS Version
        v.DAMAGES[t] = p.YGROSS[t] * v.DAMFRAC[t]
    end
end
