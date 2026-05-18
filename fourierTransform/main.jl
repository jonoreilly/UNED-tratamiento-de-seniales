module FourierTransform

include("dftSeparado.jl")
include("dftPorMatrizesSeparado.jl")
include("dftPorMatrizesComplejo.jl")
include("inversoDftPorMatrizesComplejo.jl")
include("fftSeparado.jl")
include("grafos.jl")
include("bloques.jl")

using .DftSeparado
using .DftPorMatrizesSeparado
using .DftPorMatrizesComplejo
using .InversoDftPorMatrizesComplejo
using .FftSeparado
using .Grafos
using .Bloques

export dftSeparado,
    dftPorMatrizesSeparado,
    CacheMatrizDftSeparado,
    dftPorMatrizesComplejo,
    CacheMatrizDftComplejo,
    inversoDftPorMatrizesComplejo,
    CacheMatrizInversaDftComplejo,
    fftSeparado,
    hacerGrafoSeparado,
    hacerGrafoComplejo,
    hacerBloques,
    invertirBloques

end