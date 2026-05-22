using WAV
using Plots

include("transformadorFourier/main.jl")
include("filtros/main.jl")
include("generadores/generadorMusical.jl")

using .TransformadorFourier
using .Filtros
using .GeneradorMusical

y, fs = wavread(raw".\audio\ukelele.wav")
# y, fs = wavread(raw".\audio\aoe.wav")
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

    println("FFT Complejo - ", titulo)

    tInicioFft = time()

    fft = TransformadorFourier.fftComplejo.(bloques .|> x -> complex.(x))

    duracionFft = time() - tInicioFft

    println("duración FFT Complejo - ", titulo, ": ", round(duracionFft, digits=1), "s")

    return TransformadorFourier.hacerGrafoComplejo(fft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo=titulo)

end

# Generar música

function generarAcordes(muestrasOriginal::Vector{Float64}, frecuenciaMuestreo::Float64, acordes::Vector{Acorde})

    println("Generando")

    tInicioGenerado = time()

    muestrasGenerado = GeneradorMusical.generarMuestrasAcordes(muestrasOriginal, frecuenciaMuestreo, acordes)

    duracionGenerado = time() - tInicioGenerado

    println("duración Generado: ", round(duracionGenerado, digits=1), "s")

    return muestrasGenerado

end

frecuenciaMaxima = 1_000.0
frecuenciaMuestreo = Float64(fs)
muestras = y[:, 1]

filtro = f -> (
    (400 < f && f < 1000) ? 1.0 : 0.0
)

muestrasFiltrado = hacerFiltrado(muestras, frecuenciaMuestreo, filtro)

acordes = [
    GeneradorMusical.Acorde(),
    GeneradorMusical.Acorde(Do=true, Mi=true, Sol=true),
    GeneradorMusical.Acorde(Si=true, Re=true, Mi=true, SolS_LaB=true),
    GeneradorMusical.Acorde(La=true, Do=true, Mi=true),
    GeneradorMusical.Acorde(La=true, Re=true, FaS_SolB=true, Do=true),
    GeneradorMusical.Acorde(Do=true, Mi=true, Sol=true),
    GeneradorMusical.Acorde(La=true, Re=true, Fa=true, Si=true),
    GeneradorMusical.Acorde(Do=true, Mi=true, Sol=true),
    GeneradorMusical.Acorde(),
]

muestrasGenerado = generarAcordes(muestras, frecuenciaMuestreo, acordes)

duracionOriginal = size(muestras)[1] / frecuenciaMuestreo
duracionFiltrado = size(muestrasFiltrado)[1] / frecuenciaMuestreo
duracionGenerado = size(muestrasGenerado)[1] / frecuenciaMuestreo

bloquesInicial = TransformadorFourier.hacerBloques(muestras)
bloquesFiltrado = TransformadorFourier.hacerBloques(muestrasFiltrado)
bloquesGenerado = TransformadorFourier.hacerBloques(muestrasGenerado)

grafos = [
    hacerFftComplejo(bloquesInicial, frecuenciaMuestreo, frecuenciaMaxima, duracionOriginal, "Original"),
    hacerFftComplejo(bloquesFiltrado, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltrado, "Filtrado"),
    hacerFftComplejo(bloquesGenerado, frecuenciaMuestreo, frecuenciaMaxima, duracionGenerado, "Generado"),
    plot(0:2000, filtro.(0:2000), title="Filtro"),
]

p = plot(
    grafos...,
    layout=(Int(ceil(size(grafos)[1] / 4)), 4)
)

display(p)

wavplay(y, fs)
wavplay(hcat(muestrasFiltrado, muestrasFiltrado), fs)
wavplay(hcat(muestrasGenerado, muestrasGenerado), fs)

println("Pulsa Enter para cerrar...")
readline()
