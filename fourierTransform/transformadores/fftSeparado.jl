module FftSeparado

export fftSeparado

function esPotencia2(n::Integer)::Bool

    return n > 0 && (n & (n - 1)) === 0

end

"Algoritmo FFT con los componentes separados"
function fftSeparado(muestras::Vector{Tuple{Float64,Float64}})::Vector{Tuple{Float64,Float64}}

    N = size(muestras)[1]

    if (N === 1)
        return muestras
    end

    if (!esPotencia2(N))

        siguientePotencia2 = 2^ceil(Int, log2(N))

        muestrasPotencia2 = [muestras; (1:(siguientePotencia2-N)) .|> _ -> (0.0, 0.0)]

        return fftSeparado(muestrasPotencia2)

    end

    impar = muestras[1:2:end]
    par = muestras[2:2:end]

    fftImpar = fftSeparado(impar)
    fftPar = fftSeparado(par)

    angulos = (0:(N/2)-1) .* ((-2 * pi) / N)

    senos = sin.(angulos)
    cosenos = cos.(angulos)

    fftParReal = getindex.(fftPar, 1)
    fftParImaginario = getindex.(fftPar, 2)

    fftImparReal = getindex.(fftImpar, 1)
    fftImparImaginario = getindex.(fftImpar, 2)

    twiddleFactorReal = (cosenos .* fftParReal) .+ (senos .* fftParImaginario)
    twiddleFactorImaginario = (cosenos .* fftParImaginario) .- (senos .* fftParReal)

    resultadoReal = [fftImparReal .+ twiddleFactorReal; fftImparReal .- twiddleFactorReal]
    resultadoImaginario = [fftImparImaginario .+ twiddleFactorImaginario; fftImparImaginario .- twiddleFactorImaginario]

    resultado = [(resultadoReal[i], resultadoImaginario[i]) for i in eachindex(resultadoReal)]

    return resultado

end

end