cd(@__DIR__)

using JLD2
using CodecZlib

include("src/modelA.jl")

function main()
    @init_state
    mass_id = round(parsed_args["mass"], digits=3)

    for i in 1:L
        thermalize(ϕ, m², L^3)
        @show i
        flush(stdout)
        jldsave("/home/jkott/perm/modelA_2D/thermalized/thermalized_L_$(L)_mass_$(mass_id)_id_$(seed).jld2", true; ϕ=Array(ϕ), m²)
    end
end

main()
