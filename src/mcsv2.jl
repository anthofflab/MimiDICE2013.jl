using Distributions

function getsimv2()

    mcs_anderson_et_al_2012 = @defsim begin

    # Using method proposed by (Anderson et al. 2012)
        a0 = Uniform(3.41785926,4.17738354)
        a2 = Uniform(0.0023973750000027,0.0029301250000033)
        a3 = Uniform(1.8,2.2)
        b11 = Uniform(0.8208,1.0032)
        b12 = Uniform(0.079200000000009,0.096800000000011)
        b21 = Uniform(0.034496000000001,0.042161777777779)
        b22 = Uniform(0.8632539999999,1.0550882222221)
        b23 = Uniform(0.00225,0.00275)
        b32 = Uniform(0.00030375,0.00037125)
        b33 = Uniform(0.89969625,1.09962875)
        c1 = Uniform(0.0936,0.1144)
        c3 = Uniform(0.0792,0.0968)
        c4 = Uniform(0.0225,0.0275)
        cca0 = Uniform(81,99)
        damadj = Uniform(9,11)
        dela = Uniform(0.0054,0.0066)
        dersig = Uniform(-0.0011,-0.0009)
        deland = Uniform(0.18,0.22)
        dk = Uniform(0.09,0.11)
        eland0 = Uniform(1.385748,1.693692)
        elasmu = Uniform(1.305,1.595)
        eqmat = Uniform(529.2,646.8)
        expcost2 = Uniform(2.52,3.08)
        fco22x = Uniform(3.42,4.18)
        fex0= Uniform(-0.066,-0.054)
        fex1 = Uniform(0.558,0.682)
        ga0 = Uniform(0.0711,0.0869)
        gama = Uniform(0.27,0.33)
        gsigma0 = Uniform(-0.011,-0.009)
        k0 = Uniform(121.5,148.5)
        mat0 = Uniform(737.0865,900.8835)
        ml0 = Uniform(9009,11011)
        mu0 = Uniform(1374.3,1679.7)
        pbackrate = Uniform(0.0225,0.0275)
        pbacktime0 = Uniform(309.6,378.4)
        pop0 = Uniform(6154.2,7521.8)
        popadj = Uniform(0.121041,0.147939)
        popsym = Uniform(9450,11550)
        prtp = Uniform(0.0135,0.0165)
        scale1 = Uniform(0.0147570298829796,0.018036369856975)
        scale2 = Uniform(-4206.25524301252,-3441.48156246478)
        sigma0 = Uniform(0.44008427184466,0.537880776699028)
        t2xco2 = Uniform(2.88,3.52)
        tatm0 = Uniform(0.747,0.913)
        tocean0 = Uniform(0.00612,0.00748)

        save(neteconomy.CPC,
            neteconomy.C,
            neteconomy.ABATECOST,
            neteconomy.COST1,
            neteconomy.YNET,
            damages.DAMAGES,
            damages.DAMFRAC,
            grosseconomy.L,
            grosseconomy.YGROSS
            )
        end
    return mcs_anderson_et_al_2012

end

