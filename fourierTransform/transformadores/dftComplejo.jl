module DftComplejo

export dftComplejo

"Algoritmo DFT con números complejos"
function dftComplejo(
    muestras::Vector{Float64},
    frecuenciaMuestreo::Float32,
    frecuenciaMaxima::Float64
)::Vector{ComplexF64}

    N = size(muestras)[1]

    frecuencias = Int(ceil(frecuenciaMaxima * N / frecuenciaMuestreo))

    componentesDeFrecuencias = [
        sum(muestras .* exp.((-2im * pi * f / N) .* (0:N-1)))
        for f in (0:frecuencias-1)
    ]

    return componentesDeFrecuencias

end

end