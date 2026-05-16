module Grafos

using Plots

export hacerGrafoSeparado

function hacerGrafoSeparado(
    frecuencias::Vector{Vector{Tuple{Float64,Float64}}},
    frecuenciaMaximaDatos::Union{Float32,Float64};
    frecuenciaMaximaGrafo::Union{Float32,Float64,Nothing}=nothing,
    titulo::Union{String,Nothing}=nothing
)::Plots.Plot

    if (frecuenciaMaximaGrafo === nothing)
        frecuenciaMaximaGrafo = frecuenciaMaximaDatos
    end

    intensidades = frecuencias .|> b -> (b .|> f -> abs(f[1] + f[2] * im))

    contenedoresDeFrecuencias = size(intensidades[1])[1]

    hzPorContenedor = frecuenciaMaximaDatos / contenedoresDeFrecuencias

    maxContenedores = min(Int(floor(frecuenciaMaximaGrafo / hzPorContenedor)), contenedoresDeFrecuencias)

    contenedoresPor100Hz = 100 / hzPorContenedor

    yticks = (
        Int.(floor.(1:contenedoresPor100Hz:(maxContenedores+1))),
        string.(round.(((0:contenedoresPor100Hz:maxContenedores) .|> contenedor -> (contenedor * hzPorContenedor) / 1000), digits=3)) .* " kHz"
    )

    grafo = heatmap(
        1:size(intensidades)[1],
        1:maxContenedores,
        hcat(intensidades...)[1:maxContenedores, :],
        size=(1900, 900),
        title=titulo,
        yticks=yticks
    )

    return grafo

end

end