module InversoFftComplejo

include("../bloques.jl")

using .Bloques

export reconstruirFftComplejo

function esPotencia2(n::Integer)::Bool

    return n > 0 && (n & (n - 1)) === 0

end

function inversoFftComplejo(componentesDeFrecuencias::Vector{ComplexF64})::Vector{ComplexF64}

    N = size(componentesDeFrecuencias)[1]

    if (N === 1)

        return componentesDeFrecuencias

    end

    if (!esPotencia2(N))

        siguientePotencia2 = 2^ceil(Int, log2(N))

        muestrasPotencia2 = [componentesDeFrecuencias; zeros(ComplexF64, siguientePotencia2 - N)]

        return inversoFftComplejo(muestrasPotencia2)

    end

    impar = componentesDeFrecuencias[1:2:end]
    par = componentesDeFrecuencias[2:2:end]

    inversoFftImpar = inversoFftComplejo(impar)
    inversoFftPar = inversoFftComplejo(par)

    factoresTwiddleInversos = [exp(2im * pi * n / N) for n in 0:(N/2)-1]

    inversoFftParProcesado = factoresTwiddleInversos .* inversoFftPar

    resultado = [(inversoFftImpar .+ inversoFftParProcesado); (inversoFftImpar .- inversoFftParProcesado)]


    return resultado

end

"Reconstruye las muestras que generaron estas frecuencias mediante el algoritmo inverso de FFT con números complejos"
function reconstruirFftComplejo(componentesDeFrecuenciasEnBloques::Vector{Vector{ComplexF64}})::Vector{Float64}

    N = size(componentesDeFrecuenciasEnBloques[1])[1]

    resultadoEnBloques = inversoFftComplejo.(componentesDeFrecuenciasEnBloques)

    resultadoEnBloquesNormalizado = [real.(bloque ./ N) for bloque in resultadoEnBloques]

    resultado = Bloques.invertirBloques(resultadoEnBloquesNormalizado)

end

end