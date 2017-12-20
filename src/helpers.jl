#Timestep conversion function
function getindexfromyear_dice_2013(year)
    const baseyear = 2010

    if rem(year - baseyear, 5) != 0
        error("Invalid year")
    end

    return div(year - baseyear, 5) + 1
end



#Get parameters from DICE2013 excel sheet
#range is the range of cell values on the excel sheet and must be a string, "B56:B77"
#parameters = :single for just one value, or :all for entire time series
#sheet is the sheet in the excel file to reference (i.e. "Base")
#T is the length of the time period (i.e 60)

#example:   getparams("B15:BI15", :all, "Base",  60)


function getparams(f, range::String, parameters::Symbol, sheet::String, T)

    if parameters == :single
        vals= Float64
            data=readxl(f,"$sheet\!$range")
            vals=data[1]
        return vals

    elseif parameters == :all
        vals= Array{Float64}(T)

            data=readxl(f,"$sheet\!$range")
                for i=1:T
                vals[i] = data[i]
                end
            end
        return vals
    end
