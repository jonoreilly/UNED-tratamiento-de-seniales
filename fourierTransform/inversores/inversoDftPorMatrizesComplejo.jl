module InversoDftPorMatrizesComplejo

export inversoDftPorMatrizesComplejo, CacheMatrizInversaDftComplejo

function generarMatrizInversaDftComplejo(
    N::Int,
    frecuenciaMuestreo::Float32,
    frecuenciaMaxima::Float64
)::Matrix{ComplexF64}

    frecuencias = Int(ceil(frecuenciaMaxima * N / frecuenciaMuestreo))

    matrizBase = ((0:frecuencias-1) * (0:N-1)')

    matrizDft = exp.(((-2im * pi) / N) .* matrizBase)

    matrizInversaDft = adjoint(matrizDft) / N

    return matrizInversaDft

end

mutable struct CacheMatrizInversaDftComplejo
    N::Int
    frecuenciaMuestreo::Float32
    frecuenciaMaxima::Float64
    matrizInversaDft::Matrix{ComplexF64}
end

function getMatrizInversaDftComplejo(
    N::Int,
    frecuenciaMuestreo::Float32,
    frecuenciaMaxima::Float64,
    cache::CacheMatrizInversaDftComplejo
)::Matrix{ComplexF64}

    if (cache.N === N && cache.frecuenciaMuestreo === frecuenciaMuestreo && cache.frecuenciaMaxima === frecuenciaMaxima)

        return cache.matrizInversaDft

    end

    matrizInversaDft = generarMatrizInversaDftComplejo(N, frecuenciaMuestreo, frecuenciaMaxima)

    cache.N = N
    cache.frecuenciaMuestreo = frecuenciaMuestreo
    cache.frecuenciaMaxima = frecuenciaMaxima
    cache.matrizInversaDft = matrizInversaDft

    return matrizInversaDft

end

"Reconstruye las muestras que generaron estas frecuencias mediante el algoritmo inverso de DFT por Matrizes con números complejos"
function inversoDftPorMatrizesComplejo(
    componentesDeFrecuencias::Vector{ComplexF64},
    frecuenciaMuestreo::Float32,
    frecuenciaMaxima::Float64,
    cache::CacheMatrizInversaDftComplejo
)::Vector{Float64}

    N = size(componentesDeFrecuencias)[1]

    matrizInversaDft = getMatrizInversaDftComplejo(N, frecuenciaMuestreo, frecuenciaMaxima, cache)

    resultadoComplejo = matrizInversaDft * componentesDeFrecuencias

    resultado = real.(resultadoComplejo)

    return resultado

end

end