module FiltrarFrecuencias

include("../transformadorFourier/main.jl")

using .TransformadorFourier

export
    filtrarFrecuencias,
    filtrarPasoBajo,
    filtrarPasoAlto,
    filtrarPasoBanda

"Atenua la señal siguiendo el patron descrito por el parametro `filtro`. Filtro banda 1kHz-5kHz -> ((1000 < f && f < 5000) ? 1.0 : 0.0)"
function filtrarFrecuencias(muestras::Vector{Float64}, frecuenciaMuestreo::Float64, filtro::Function)::Vector{Float64}

    bloques = TransformadorFourier.hacerBloques(muestras)

    fft = TransformadorFourier.fftComplejo.(bloques .|> x -> complex.(x))

    contenedoresDeFrecuencias = size(fft[1])[1]

    hzPorContenedor = frecuenciaMuestreo / contenedoresDeFrecuencias

    frecuencias = [
        (
            (
                # En FT las frecuencias aumentan hasta N/2 y luego disminuyen reflejando la primera parte 
                (i > (contenedoresDeFrecuencias / 2) ? (contenedoresDeFrecuencias - i) : i)
                *
                hzPorContenedor
            )
            # Para cada bloque usamos la frecuencia del medio de su rango
            +
            (hzPorContenedor / 2)
        )
        for i in (0:contenedoresDeFrecuencias-1)
    ]

    permisividades = [
        filtro(frecuencia)
        for frecuencia in frecuencias
    ]

    fftFiltrado = [
        bloque .* permisividades
        for bloque in fft
    ]

    cacheMatrizInversaDftComplejo = TransformadorFourier.CacheMatrizInversaDftComplejo(0, 0, 0, Matrix{ComplexF64}(undef, 0, 0))

    resultadoEnBloques = TransformadorFourier.inversoDftPorMatrizesComplejo.(fftFiltrado, frecuenciaMuestreo, frecuenciaMuestreo, Ref(cacheMatrizInversaDftComplejo))

    resultado = TransformadorFourier.invertirBloques(resultadoEnBloques)

    return resultado

end

function filtrarPasoBajo(muestras::Vector{Float64}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64)::Vector{Float64}

    filtro = f -> (f < frecuenciaMaxima) ? 1.0 : 0.0

    return filtrarFrecuencias(muestras, frecuenciaMuestreo, filtro)

end

function filtrarPasoAlto(muestras::Vector{Float64}, frecuenciaMuestreo::Float64, frecuenciaMinima::Float64)::Vector{Float64}

    filtro = f -> (frecuenciaMinima < f) ? 1.0 : 0.0

    return filtrarFrecuencias(muestras, frecuenciaMuestreo, filtro)

end

function filtrarPasoBanda(muestras::Vector{Float64}, frecuenciaMuestreo::Float64, frecuenciaMinima::Float64, frecuenciaMaxima::Float64)::Vector{Float64}

    filtro = f -> (frecuenciaMinima < f && f < frecuenciaMaxima) ? 1.0 : 0.0

    return filtrarFrecuencias(muestras, frecuenciaMuestreo, filtro)

end

end