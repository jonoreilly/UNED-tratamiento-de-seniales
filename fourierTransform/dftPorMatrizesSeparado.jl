module DftPorMatrizesSeparado

export dftPorMatrizesSeparado, CacheMatrizDft

function generarMatrizesDft(
    N::Int,
    frecuenciaMuestreo::Float32,
    frecuenciaMaxima::Float64
)::Tuple{Matrix{Float64},Matrix{Float64}}

    frecuencias = Int(ceil(frecuenciaMaxima * N / frecuenciaMuestreo))

    matrizBase = ((0:frecuencias-1) * (0:N-1)')

    angulos = ((-2 * pi) / N) .* matrizBase

    matrizDFTR = cos.(angulos)
    matrizDFTI = -sin.(angulos)

    return matrizDFTR, matrizDFTI

end

mutable struct CacheMatrizDft
    N::Int
    frecuenciaMuestreo::Float32
    frecuenciaMaxima::Float64
    matrizDftReal::Matrix{Float64}
    matrizDftImaginaria::Matrix{Float64}
end

function getMatrizesDFT(
    N::Int,
    frecuenciaMuestreo::Float32,
    frecuenciaMaxima::Float64,
    cache::CacheMatrizDft
)::Tuple{Matrix{Float64},Matrix{Float64}}

    if (cache.N === N && cache.frecuenciaMuestreo === frecuenciaMuestreo && cache.frecuenciaMaxima === frecuenciaMaxima)

        return (cache.matrizDftReal, cache.matrizDftImaginaria)

    end

    (matrizDftReal, matrizDftImaginaria) = generarMatrizesDft(N, frecuenciaMuestreo, frecuenciaMaxima)

    cache.N = N
    cache.frecuenciaMuestreo = frecuenciaMuestreo
    cache.frecuenciaMaxima = frecuenciaMaxima
    cache.matrizDftReal = matrizDftReal
    cache.matrizDftImaginaria = matrizDftImaginaria

    return (matrizDftReal, matrizDftImaginaria)

end

"Algoritmo DFT por Matrizes con los componentes separados"
function dftPorMatrizesSeparado(
    muestras::Vector{Float64},
    frecuenciaMuestreo::Float32,
    frecuenciaMaxima::Float64,
    cache::CacheMatrizDft
)::Vector{Tuple{Float64,Float64}}

    N = size(muestras)[1]

    (matrizDftReal, matrizDftImaginario) = getMatrizesDFT(N, frecuenciaMuestreo, frecuenciaMaxima, cache)

    resultadoReal = matrizDftReal * muestras

    resultadoImaginario = matrizDftImaginario * muestras

    resultado = [(resultadoReal[i], resultadoImaginario[i]) for i in eachindex(resultadoReal)]

    return resultado

end

end