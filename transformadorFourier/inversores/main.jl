module Inversores

include("inversoFftComplejo.jl")
include("inversoDftPorMatrizesComplejo.jl")

using .InversoFftComplejo
using .InversoDftPorMatrizesComplejo

export
    reconstruirFftComplejo,
    inversoDftPorMatrizesComplejo,
    CacheMatrizInversaDftComplejo

end