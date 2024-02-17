using DelimitedFiles
using JLD2
using CodecZlib
using Glob

include("bootstrap.jl")

sizes = [8, 12, 16, 24, 32, 48, 64]

mass = -3.81
masses = collect(-3.9:0.005:-3.7)

jldopen("reweighted_mass_$(mass).jld2", "w") do savefile

function observable(df, mass0, c, N, n)
    sum( exp(-(mass0-mass)/2 * (df[t,3] - c)) * df[t,2]^n for t in 1:N) / sum( exp(-(mass0-mass)/2 * (df[t,3] - c)) for t in 1:N)
end

function average(x)
    sum(x)/length(x)
end

for L in sizes
    files = glob("magnetization_L_$(L)_mass_$(mass)_id_*.dat", "/home/jkott/perm/modelA_2D/measurements")
    binders = []

    for file in files
        println(file)
        df = readdlm(file, ' ')
        N = length(df[:,1])
        c = sum(df[:,3])/N
        
        M2 = zeros(length(masses))
        M4 = zeros(length(masses))
        Threads.@threads for idx in 1:length(masses)
            M2[idx] = observable(df, masses[idx], c, N, 2)
            M4[idx] = observable(df, masses[idx], c, N, 4)
        end

        binder = 1 .- M4 ./ (3 * M2.^2)
        push!(binders, binder)
    end

    (U, err) = bootstrap(binders, 500)
    savefile["L_$(L)/U"] = U
    savefile["L_$(L)/err"] = err
end

end
