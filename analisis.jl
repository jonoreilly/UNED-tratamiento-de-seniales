using WAV
using Plots
using DSP
using AbstractFFTs

include("transformadorFourier/main.jl")
include("filtros/main.jl")

using .TransformadorFourier
using .Filtros

y, fs = wavread(raw".\audio\ukelele.wav")

# FFT Complejo

function hacerFftComplejo(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64, titulo::String)

    println("FFT Complejo - ", titulo)

    tInicioFft = time()

    ft = TransformadorFourier.fftComplejo.(bloques .|> x -> complex.(x))

    duracionFft = time() - tInicioFft

    println("duración FFT Complejo - ", titulo, ": ", round(duracionFft, digits=1), "s")

    return TransformadorFourier.hacerGrafoComplejo(ft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo=titulo)

end

# Abstract FFT

function hacerAbstractFft(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64, titulo::String)

    println("Abstract FFT - ", titulo)

    tInicioFft = time()

    ft = fft.(bloques .|> x -> complex.(x))

    duracionFft = time() - tInicioFft

    println("duración Abstract FFT - ", titulo, ": ", round(duracionFft, digits=1), "s")

    return TransformadorFourier.hacerGrafoComplejo(ft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo=titulo)

end

# Filtro

function hacerFiltrado(muestras::Vector{Float64}, frecuenciaMuestreo::Float64, filtro::Function)

    println("Filtrando")

    tInicioFiltrado = time()

    muestrasFiltrado = Filtros.filtrarFrecuencias(muestras, frecuenciaMuestreo, filtro)

    duracionFiltrado = time() - tInicioFiltrado

    println("duración Filtrado: ", round(duracionFiltrado, digits=1), "s")

    return muestrasFiltrado

end

# Filtrar DSP

function hacerFiltradoDsp(muestras::Vector{Float64}, filtro::FilterCoefficients, titulo::String)

    println("Filtrado DSP - ", titulo)

    tInicioFiltrado = time()

    muestrasFiltrado = filt(filtro, muestras)

    duracionFiltrado = time() - tInicioFiltrado

    println("duración Filtrado DSP: - ", titulo, ": ", round(duracionFiltrado, digits=1), "s")

    return muestrasFiltrado

end

function hacerFiltradoDspPasoBanda(muestras::Vector{Float64}, frecuenciaMuestreo::Float64, frecuenciaMinima::Float64, frecuenciaMaxima::Float64, titulo::String)

    filtro =
        digitalfilter(
            Bandpass(frecuenciaMinima / (frecuenciaMuestreo / 2), frecuenciaMaxima / (frecuenciaMuestreo / 2)),
            Butterworth(16)
        )

    return hacerFiltradoDsp(muestras, filtro, titulo)

end

# Graficos

frecuenciaMaxima = 3_000.0
frecuenciaMuestreo = Float64(fs)
muestras = y[:, 1]

frecuenciaMinimaPasoBanda = 500.0
frecuenciaMaximaPasoBanda = 1_500.0

filtroPasoBanda = f -> ((frecuenciaMinimaPasoBanda < f && f < frecuenciaMaximaPasoBanda) ? 1.0 : 0.0)

muestrasFiltradoPasoBanda = hacerFiltrado(muestras, frecuenciaMuestreo, filtroPasoBanda)

muestrasFiltradoDspPasoBanda = hacerFiltradoDspPasoBanda(muestras, frecuenciaMuestreo, frecuenciaMinimaPasoBanda, frecuenciaMaximaPasoBanda, "Paso banda 0.5 - 1.5 kHz")

duracionOriginal = size(muestras)[1] / frecuenciaMuestreo
duracionFiltradoPasoBanda = size(muestrasFiltradoPasoBanda)[1] / frecuenciaMuestreo
duracionFiltradoDspPasoBanda = size(muestrasFiltradoDspPasoBanda)[1] / frecuenciaMuestreo

bloquesInicial = TransformadorFourier.hacerBloques(muestras)
bloquesFiltradoPasoBanda = TransformadorFourier.hacerBloques(muestrasFiltradoPasoBanda)
bloquesFiltradoDspPasoBanda = TransformadorFourier.hacerBloques(muestrasFiltradoDspPasoBanda)

grafos = [
    hacerFftComplejo(bloquesInicial, frecuenciaMuestreo, frecuenciaMaxima, duracionOriginal, "Original"),
    hacerFftComplejo(bloquesFiltradoPasoBanda, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltradoPasoBanda, "Paso banda 0.5 - 1.5 kHz"),
    hacerFftComplejo(bloquesFiltradoDspPasoBanda, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltradoDspPasoBanda, "DSP - Paso banda 0.5 - 1.5 kHz"),
    hacerAbstractFft(bloquesInicial, frecuenciaMuestreo, frecuenciaMaxima, duracionOriginal, "AbstractFFTs - Original"),
    hacerAbstractFft(bloquesFiltradoPasoBanda, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltradoPasoBanda, "AbstractFFTs - Paso banda 0.5 - 1.5 kHz"),
    hacerAbstractFft(bloquesFiltradoDspPasoBanda, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltradoDspPasoBanda, "AbstractFFTs - DSP - Paso banda 0.5 - 1.5 kHz"),
]

p = plot(
    grafos...,
    layout=(Int(ceil(size(grafos)[1] / 3)), 3)
)

display(p)

display(p)

println("Pulsa Enter para cerrar...")
readline()