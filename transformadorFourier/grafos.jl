module Grafos

using Plots

export hacerGrafoSeparado, hacerGrafoComplejo

function hacerGrafoIntensidades(
    amplitudesDeFrecuencias::Vector{Vector{Float64}},
    frecuenciaMaximaDatos::Float64;
    frecuenciaMaximaGrafo::Union{Float64,Nothing}=nothing,
    titulo::Union{String,Nothing}=nothing,
    duracionOriginal::Union{Float64,Nothing}=nothing
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
            ((0:contenedoresPor100Hz:maxContenedores) .* (hzPorContenedor / 1000)),
            digits=2
        )) .* " kHz"
    )

    xticks = false

    if (duracionOriginal !== nothing)

        segundosPorTick = duracionOriginal <= 3 ? 0.5 :
                          duracionOriginal <= 10 ? 1 :
                          duracionOriginal <= 60 ? 10 :
                          duracionOriginal <= (60 * 4) ? 30 :
                          60

        numeroBloques = size(amplitudesDeFrecuencias)[1]

        segundosPorBloque = duracionOriginal / numeroBloques

        tamanioTickX = segundosPorTick / segundosPorBloque

        xticks = (
            Int.(floor.(1:tamanioTickX:numeroBloques+1)),
            (0:tamanioTickX:numeroBloques) .|> bloque -> begin

                segundos = bloque * segundosPorBloque

                if (duracionOriginal <= 3)

                    return string(round(
                        segundos,
                        digits=1
                    )) * "s"

                end

                if (duracionOriginal <= 60)

                    return string(round(segundos)) * "s"

                end

                minutos = Int(round(segundos / 60))
                segundosResto = mod(Int(round(segundos)), 60)

                return string(minutos) * ":" * lpad(segundosResto, 2, "0")

            end
        )

    end

    grafo = heatmap(
        1:size(amplitudesDeFrecuencias)[1],
        1:maxContenedores,
        hcat(amplitudesDeFrecuencias...)[1:maxContenedores, :],
        size=(1900, 900),
        title=titulo,
        yticks=yticks,
        xticks=xticks,
        colorbar=false
    )

    return grafo

end

function hacerGrafoSeparado(
    componentesDeFrecuencias::Vector{Vector{Tuple{Float64,Float64}}},
    frecuenciaMaximaDatos::Float64;
    frecuenciaMaximaGrafo::Union{Float64,Nothing}=nothing,
    titulo::Union{String,Nothing}=nothing,
    duracionOriginal::Union{Float64,Nothing}=nothing
)::Plots.Plot

    amplitudesDeFrecuencias = componentesDeFrecuencias .|> bloque ->
        (bloque .|> componenteDeFrequencia ->
            abs(componenteDeFrequencia[1] + componenteDeFrequencia[2] * im))

    return hacerGrafoIntensidades(
        amplitudesDeFrecuencias,
        frecuenciaMaximaDatos,
        frecuenciaMaximaGrafo=frecuenciaMaximaGrafo,
        titulo=titulo,
        duracionOriginal=duracionOriginal
    )

end

function hacerGrafoComplejo(
    componentesDeFrecuencias::Vector{Vector{ComplexF64}},
    frecuenciaMaximaDatos::Float64;
    frecuenciaMaximaGrafo::Union{Float64,Nothing}=nothing,
    titulo::Union{String,Nothing}=nothing,
    duracionOriginal::Union{Float64,Nothing}=nothing
)::Plots.Plot

    amplitudesDeFrecuencias = [abs.(bloque) for bloque in componentesDeFrecuencias]

    return hacerGrafoIntensidades(
        amplitudesDeFrecuencias,
        frecuenciaMaximaDatos,
        frecuenciaMaximaGrafo=frecuenciaMaximaGrafo,
        titulo=titulo,
        duracionOriginal=duracionOriginal
    )

end

end