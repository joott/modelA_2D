cd(@__DIR__)

using JLD2
using CodecZlib
using Printf

include("src/modelA.jl")

function op(ϕ)
    (sum(ϕ)/L^2, sum(ϕ.^2))
end

function main()
    @init_state

    maxt = L^3
    skip = 100
    mass_id = round(m², digits=3)
    thermalize(ϕ, m², L^3)

    open("/home/jkott/perm/modelA_2D/measurements/magnetization_L_$(L)_mass_$(mass_id)_id_$(seed).dat", "w") do io
    for i in 0:maxt
        (M, ϕ2) = op(ϕ)
        Printf.@printf(io, "%i %f %f\n", i, M, ϕ2)

        thermalize(ϕ, m², skip)

        if i%L == 0
            flush(stdout)
        end
    end
    end
end

main()
