module TransformadorFourier

include("transformadores/main.jl")
include("inversores/main.jl")
include("grafos.jl")
include("bloques.jl")

using .Transformadores
using .Inversores
using .Grafos
using .Bloques

export
    dftSeparado,
    dftComplejo,
    fftSeparado,
    fftComplejo,
    dftPorMatrizesSeparado,
    CacheMatrizDftSeparado,
    dftPorMatrizesComplejo,
    CacheMatrizDftComplejo,
    reconstruirFftComplejo,
    inversoDftPorMatrizesComplejo,
    CacheMatrizInversaDftComplejo,
    hacerGrafoSeparado,
    hacerGrafoComplejo,
    hacerBloques,
    invertirBloques,
    TamanioBloque,
    Solapamiento

end