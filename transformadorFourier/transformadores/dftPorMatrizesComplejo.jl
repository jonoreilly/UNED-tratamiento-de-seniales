module DftPorMatrizesComplejo

export dftPorMatrizesComplejo, CacheMatrizDftComplejo

function generarMatrizDftComplejo(
    N::Int,
    frecuenciaMuestreo::Float64,
    frecuenciaMaxima::Float64
)::Matrix{ComplexF64}

    frecuencias = Int(ceil(frecuenciaMaxima * N / frecuenciaMuestreo))

    matrizBase = ((0:frecuencias-1) * (0:N-1)')

    matrizDft = exp.(((-2im * pi) / N) .* matrizBase)

    return matrizDft

end

mutable struct CacheMatrizDftComplejo
    N::Int
    frecuenciaMuestreo::Float64
    frecuenciaMaxima::Float64
    matrizDft::Matrix{ComplexF64}
end

function getMatrizDftComplejo(
    N::Int,
    frecuenciaMuestreo::Float64,
    frecuenciaMaxima::Float64,
    cache::CacheMatrizDftComplejo
)::Matrix{ComplexF64}

    if (cache.N === N && cache.frecuenciaMuestreo === frecuenciaMuestreo && cache.frecuenciaMaxima === frecuenciaMaxima)

        return cache.matrizDft

    end

    matrizDft = generarMatrizDftComplejo(N, frecuenciaMuestreo, frecuenciaMaxima)

    cache.N = N
    cache.frecuenciaMuestreo = frecuenciaMuestreo
    cache.frecuenciaMaxima = frecuenciaMaxima
    cache.matrizDft = matrizDft

    return matrizDft

end

"Algoritmo DFT por Matrizes con números complejos"
function dftPorMatrizesComplejo(
    muestras::Vector{Float64},
    frecuenciaMuestreo::Float64,
    frecuenciaMaxima::Float64,
    cache::CacheMatrizDftComplejo
)::Vector{ComplexF64}

    N = size(muestras)[1]

    matrizDft = getMatrizDftComplejo(N, frecuenciaMuestreo, frecuenciaMaxima, cache)

    resultado = matrizDft * muestras

    return resultado

end

end