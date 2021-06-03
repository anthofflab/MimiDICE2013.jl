using Distributions

m = constructdice()
run(m)

mcs = @defsim begin
    # The parameters of the log‐normal distribution fit to Olsen et al. 
    # are μ = 1.10704 and σ = 0.264 (Gillingham et al. 2015)
    t2xco2 = LogNormal(1.10704, 0.264)

    save(damages.DAMAGES)
end

res = run(mcs, m, 1000; trials_output_filename="/tmp/dice-2013/trialdata.csv", results_output_dir="/tmp/dice-2013")
