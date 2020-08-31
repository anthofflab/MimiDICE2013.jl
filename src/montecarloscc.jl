using Dates

#This function runs a Monte Carlo Simulation, that includes a post trial function, which calculates de Social Cost of Carbon and allows to enter the rate of time preference,
# prtp, and the elasticity of the marginal utility of consumption as uncertain input variables, check mcsv2.jl

function monte_carlo_compute_scc(m::Model = MimiDICE2013.get_model(); year::Union{Int, Nothing} = nothing, trials = 100, output_dir = nothing, save_trials = false) 
    dice_years = 2010:5:2305
    
    year === nothing ? error("Must specify an emission year. Try `monte_carlo_compute_scc(m, year=2020)`.") : nothing
    !(year in dice_years) ? error("Cannot compute the scc for year $year, year must be within the model's time index $dice_years.") : nothing    

    output_dir = output_dir === nothing ? joinpath(@__DIR__, "../output/", "SCC $(Dates.format(now(), "yyyy-mm-dd HH-MM-SS")) MC$trials") : output_dir
    mkpath("$output_dir/results")
    save_trials ? trials_output_filename = joinpath(@__DIR__, "$output_dir/trials.csv") : trials_output_filename = nothing 

    scc_file = joinpath(output_dir, "scc.csv")
    open(scc_file, "w") do f 
        write(f, "trial, SCC: $year\n")
    end
    
    mcs = MimiDICE2013.getsimv2()
    last_year = dice_years[end]
    mm = MimiDICE2013.get_marginal_model(year=year)
    
    function scc_calculation(mcs::SimulationInstance, trialnum::Int, ntimesteps::Int, ::Nothing)


        mm = mcs.models[1]

        ntimesteps = findfirst(isequal(last_year), dice_years)     # Will run through the timestep of the specified last_year
        run(mm, ntimesteps=ntimesteps)

        marginal_damages = -1 * mm[:neteconomy, :C][1:ntimesteps] * 10^12     # Go from trillion$ to $; multiply by -1 so that damages are positive; pulse was in CO2 so we don't need to multiply by 12/44

        cpc = mm.base[:neteconomy, :CPC]
        eta = mm.base[:welfare, :elasmu]
        prtp = mm.base[:welfare, :prtp]

        year_index = findfirst(isequal(year), dice_years)

        df = [zeros(year_index-1)..., ((cpc[year_index]/cpc[i])^eta * 1/(1+prtp)^(t-year) for (i,t) in enumerate(dice_years) if year<=t<=last_year)...]
        scc = sum(df .* marginal_damages * 5)

        open(scc_file, "a") do f
            write(f, "$trialnum, $scc\n")
        end

        return nothing
    end
    
    scc_data = run(mcs, mm, trials;
             trials_output_filename = trials_output_filename,             
             results_output_dir = "$output_dir/results",
             post_trial_func = scc_calculation)
    
    return scc_data
end
