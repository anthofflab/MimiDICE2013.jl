using Distributions

m = constructdice()
run(m)

mcs = @defsim begin
    # The parameters of the log‐normal distribution fit to Olsen et al. 
    # are μ = 1.10704 and σ = 0.264 (Gillingham et al. 2015)
    t2xco2 = LogNormal(1.10704, 0.264)

    save(damages.DAMAGES)
end

generate_trials!(mcs, 10000, filename="/tmp/dice-2013/trialdata.csv")

# Run trials 1:4, and save results to the indicated directory
set_models!(mcs, m)
run_sim(mcs, output_dir="/tmp/dice-2013")