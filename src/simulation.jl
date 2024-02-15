!cpu && using CUDA

function NNp(n)
    n%L+1
end

function NNm(n)
    (n+L-2)%L+1
end

function ΔH(ϕ, m², x, q)
    ϕold = ϕ[x...]
    ϕt = ϕold + q
    Δϕ = ϕt - ϕold
    Δϕ² = ϕt^2 - ϕold^2

    ∑nn = (ϕ[NNp(x[1]), x[2]] + ϕ[x[1], NNp(x[2])]
         + ϕ[NNm(x[1]), x[2]] + ϕ[x[1], NNm(x[2])])

    return 2Δϕ² - Δϕ * ∑nn + 0.5m² * Δϕ² + 0.25λ * (ϕt^4 - ϕold^4)
end

function step(ϕ, m², n, (i,j))
    x = ((2i + j + n)%L+1, j%L+1)

    norm = cos(2pi*rand())*sqrt(-2*log(rand()))
    q = Rate * norm

    δH = ΔH(ϕ, m², x, q)

    ϕ[x...] += q * (rand() < exp(-δH/T))
end

##
if cpu

function sweep(ϕ, m², n)
    Threads.@threads for l in 0:L^2÷2-1
        i = l ÷ L
        j = l % L

        step(ϕ, m², n, (i,j))
    end
end

else

function _sweep(ϕ, m², n)
    index = (blockIdx().x - 1) * blockDim().x + threadIdx().x - 1
    stride = gridDim().x * blockDim().x

    for l in index:stride:L^2÷2-1
        i = l ÷ L
        j = l % L

        step(ϕ, m², n, (i,j))
    end
end

_sweep_gpu = @cuda launch=false _sweep(ArrayType{FloatType}(undef,(L,L)), zero(FloatType), 0)

const N = L^2÷2
config = launch_configuration(_sweep_gpu.fun)
const threads = min(N, config.threads)
const blocks = cld(N, threads)

sweep = (ϕ, m², n) -> _sweep_gpu(ϕ, m², n; threads=threads, blocks=blocks)

end

function dissipative(ϕ, m²)
    for n in 0:1
        sweep(ϕ, m², n)
    end
end

function thermalize(ϕ, m², N)
    for _ in 1:N
        dissipative(ϕ, m²)
    end
end
