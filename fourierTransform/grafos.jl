module Grafos

using Plots

export hacerGrafoSeparado, hacerGrafoComplejo

function hacerGrafoIntensidades(
    amplitudesDeFrecuencias::Vector{Vector{Float64}},
    frecuenciaMaximaDatos::Union{Float32,Float64};
    frecuenciaMaximaGrafo::Union{Float32,Float64,Nothing}=nothing,
    titulo::Union{String,Nothing}=nothing
)::Plots.Plot

    if (frecuenciaMaximaGrafo === nothing)
        frecuenciaMaximaGrafo = frecuenciaMaximaDatos
    end

    contenedoresDeFrecuencias = size(amplitudesDeFrecuencias[1])[1]

    hzPorContenedor = frecuenciaMaximaDatos / contenedoresDeFrecuencias

    maxContenedores = min(Int(floor(frecuenciaMaximaGrafo / hzPorContenedor)), contenedoresDeFrecuencias)

    contenedoresPor100Hz = 100 / hzPorContenedor

    yticks = (
        Int.(floor.(1:contenedoresPor100Hz:(maxContenedores+1))),
        string.(round.(
            ((0:contenedoresPor100Hz:maxContenedores) .|> contenedor -> (contenedor * hzPorContenedor) / 1000),
            digits=2
        )) .* " kHz"
    )

    grafo = heatmap(
        1:size(amplitudesDeFrecuencias)[1],
        1:maxContenedores,
        hcat(amplitudesDeFrecuencias...)[1:maxContenedores, :],
        size=(1900, 900),
        title=titulo,
        yticks=yticks
    )

    return grafo

end

function hacerGrafoSeparado(
    componentesDeFrecuencias::Vector{Vector{Tuple{Float64,Float64}}},
    frecuenciaMaximaDatos::Union{Float32,Float64};
    frecuenciaMaximaGrafo::Union{Float32,Float64,Nothing}=nothing,
    titulo::Union{String,Nothing}=nothing
)::Plots.Plot

    amplitudesDeFrecuencias = componentesDeFrecuencias .|> bloque ->
        (bloque .|> componenteDeFrequencia ->
            abs(componenteDeFrequencia[1] + componenteDeFrequencia[2] * im))

    return hacerGrafoIntensidades(
        amplitudesDeFrecuencias,
        frecuenciaMaximaDatos,
        frecuenciaMaximaGrafo=frecuenciaMaximaGrafo,
        titulo=titulo
    )

end

function hacerGrafoComplejo(
    componentesDeFrecuencias::Vector{Vector{ComplexF64}},
    frecuenciaMaximaDatos::Union{Float32,Float64};
    frecuenciaMaximaGrafo::Union{Float32,Float64,Nothing}=nothing,
    titulo::Union{String,Nothing}=nothing
)::Plots.Plot

    amplitudesDeFrecuencias = [abs.(bloque) for bloque in componentesDeFrecuencias]

    return hacerGrafoIntensidades(
        amplitudesDeFrecuencias,
        frecuenciaMaximaDatos,
        frecuenciaMaximaGrafo=frecuenciaMaximaGrafo,
        titulo=titulo
    )

end

end