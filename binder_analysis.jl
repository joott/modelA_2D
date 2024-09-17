cd("/home/jkott/perm/modelA_2D/measurements")

using DelimitedFiles
using JLD2
using CodecZlib
using Glob

L = ARGS[1]

binder = []
masses = collect(-4.0:0.01:-3.5)

for mass in masses
    files = glob("magnetization_L_$(L)_mass_$(mass)_id_*.dat")
    N_files = length(files)
    M4 = 0
    M2 = 0
    N_total = 0

    for file in files
        df = readdlm(file)

        N_total += length(df[:,1])
        M2 += sum(df[:,2].^2)
        M4 += sum(df[:,2].^4)
    end

    M2 /= N_total
    M4 /= N_total
    U = 1 - M4 / (3 * M2^2)
    push!(binder, U)
end

jldsave("binder_L_$(L).jld2", true; U=binder, masses=masses)
