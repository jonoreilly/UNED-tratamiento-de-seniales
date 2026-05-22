module InversorFftComplejo

export inversorFftComplejo

function esPotencia2(n::Integer)::Bool

    return n > 0 && (n & (n - 1)) === 0

end

"Reconstruye las muestras que generaron estas frecuencias mediante el algoritmo inverso de FFT con números complejos"
function inversorFftComplejo(componentesDeFrecuencias::Vector{ComplexF64})::Vector{ComplexF64}

    N = size(componentesDeFrecuencias)[1]

    if (N === 1)

        return componentesDeFrecuencias

    end

    if (!esPotencia2(N))

        siguientePotencia2 = 2^ceil(Int, log2(N))

        muestrasPotencia2 = [componentesDeFrecuencias; zeros(ComplexF64, siguientePotencia2 - N)]

        return inversorFftComplejo(muestrasPotencia2)

    end

    impar = componentesDeFrecuencias[1:2:end]
    par = componentesDeFrecuencias[2:2:end]

    inversoFftImpar = inversorFftComplejo(impar)
    inversoFftPar = inversorFftComplejo(par)

    factoresTwiddleInversos = [exp(2im * pi * n / N) for n in 0:(N/2)-1]

    inversoFftParProcesado = factoresTwiddleInversos .* inversoFftPar

    resultado = [(inversoFftImpar .+ inversoFftParProcesado); (inversoFftImpar .- inversoFftParProcesado)] ./ N

    return resultado

end

end