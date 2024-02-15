using DelimitedFiles
using JLD2
using CodecZlib

L = ARGS[1]
id = ARGS[2]

binder = []
masses = collect(-4.5:0.005:-3.0)

for mass in masses
    file = readdlm("measurements/magnetization_L_$(L)_mass_$(mass)_id_$(id).dat")
    N = length(file[:,1])
    M2 = sum(file[:,2].^2)/N
    M4 = sum(file[:,2].^4)/N

    U = 1 - M4 / (3 * M2^2)
    push!(binder, U)
end

jldsave("measurements/binder_L_$(L).jld2", true; U=binder, masses=masses)
