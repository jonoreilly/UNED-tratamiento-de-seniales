using WAV
using Plots

include("transformadorFourier/main.jl")
include("filtros/main.jl")

using .TransformadorFourier
using .Filtros

y, fs = wavread(raw".\audio\aoe.wav")
# y, fs = wavread(raw"C:\Windows\Media\Alarm02.wav")
# y, fs = wavread(raw"C:\Windows\Media\Ring01.wav")
# y, fs = wavread(raw".\audio\example.wav")

# Filtro

function hacerFiltrado(muestras::Vector{Float64}, frecuenciaMuestreo::Float64, filtro::Function)

    println("Filtrando")

    tInicioFiltrado = time()

    muestrasFiltrado = Filtros.filtrarFrecuencias(muestras, frecuenciaMuestreo, filtro)

    duracionFiltrado = time() - tInicioFiltrado

    println("duración Filtrado: ", round(duracionFiltrado, digits=1), "s")

    return muestrasFiltrado

end

# FFT Complejo

function hacerFftComplejo(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64, titulo::String)

    println("FFT Complejo")

    tInicioFft = time()

    fft = TransformadorFourier.fftComplejo.(bloques .|> x -> complex.(x))

    duracionFft = time() - tInicioFft

    println("duración FFT Complejo: ", round(duracionFft, digits=1), "s")

    return TransformadorFourier.hacerGrafoComplejo(fft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo=titulo)

end


frecuenciaMaxima = 2_000.0
frecuenciaMuestreo = Float64(fs)
muestras = y[:, 1]

filtro = f -> (
    (f > 2000) ? 0.0 :
    cos(f / 100)
)

muestrasFiltrado = hacerFiltrado(muestras, frecuenciaMuestreo, filtro)

duracionOriginal = size(muestras)[1] / frecuenciaMuestreo
duracionFiltrado = size(muestras)[1] / frecuenciaMuestreo

bloquesInicial = TransformadorFourier.hacerBloques(muestras)
bloquesFiltrado = TransformadorFourier.hacerBloques(muestrasFiltrado)

grafos = [
    hacerFftComplejo(bloquesInicial, frecuenciaMuestreo, frecuenciaMaxima, duracionOriginal, "Original"),
    hacerFftComplejo(bloquesFiltrado, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltrado, "Filtrado"),
    plot(0:2000, filtro.(0:2000), title="Filtro"),
]

p = plot(
    grafos...,
    layout=(2, Int(ceil(size(grafos)[1] / 2)))
)

display(p)

println("Press Enter to close...")
readline()

# println("")
# println("Filtros: ", filtros)
