module DftSeparado

export dftSeparado

"Algoritmo DFT con los componentes separados"
function dftSeparado(
    muestras::Vector{Float64},
    frecuenciaMuestreo::Float32,
    frecuenciaMaxima::Float64
)::Vector{Tuple{Float64,Float64}}

    N = size(muestras)[1]

    frecuencias = Int(ceil(frecuenciaMaxima * N / frecuenciaMuestreo))

    componentesFrecuencias = (0:frecuencias-1) .|> f -> begin

        angulos = (0:N-1) .* ((-2 * pi * f) / N)

        real = sum(muestras .* cos.(angulos))

        imaginario = sum(muestras .* sin.(angulos))

        return (real, imaginario)

    end

    return componentesFrecuencias

end

end