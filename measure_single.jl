cd(@__DIR__)

using JLD2
using CodecZlib
using Printf

include("src/modelA.jl")

function op(ϕ)
    (sum(ϕ)/L^2, sum(ϕ.^2))
end

function run_m²(ϕ, m²0)
    maxt = L^3
    skip = 100
    mass_id = round(m²0, digits=3)

    open("/home/josh/modelA_2D/measurements/magnetization_L_$(L)_mass_$(mass_id)_id_$(seed).dat", "w") do io
    for i in 0:maxt
        (M, ϕ2) = op(ϕ)
        Printf.@printf(io, "%i %f %f\n", i, M, ϕ2)

        thermalize(ϕ, m²0, skip)

        if maxt%L == 0
            flush(stdout)
        end
    end
    end
end

function main()
    @init_state

    thermalize(ϕ, -3.0, L^4)

    for m²0 in -3.0:-0.005:-3.5
        thermalize(ϕ, m²0, L^3)
        run_m²(ϕ, m²0)
    end
end

main()
