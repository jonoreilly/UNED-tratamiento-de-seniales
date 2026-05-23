using WAV
using Plots
using DSP

include("transformadorFourier/main.jl")
include("filtros/main.jl")
include("generadores/generadorMusical.jl")

using .TransformadorFourier
using .Filtros
using .GeneradorMusical

y, fs = wavread(raw".\audio\ukelele.wav")

# FFT Complejo

function hacerFftComplejo(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64, titulo::String)

    println("FFT Complejo - ", titulo)

    tInicioFft = time()

    fft = TransformadorFourier.fftComplejo.(bloques .|> x -> complex.(x))

    duracionFft = time() - tInicioFft

    println("duración FFT Complejo - ", titulo, ": ", round(duracionFft, digits=1), "s")

    return TransformadorFourier.hacerGrafoComplejo(fft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo=titulo)

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

function hacerFiltradoDspPasoAlto(muestras::Vector{Float64}, frecuenciaMuestreo::Float64, frecuenciaMinima::Float64, titulo::String)

    filtro =
        digitalfilter(
            Highpass(frecuenciaMinima / (frecuenciaMuestreo / 2)),
            Butterworth(16)
        )

    return hacerFiltradoDsp(muestras, filtro, titulo)

end

function hacerFiltradoDspPasoBajo(muestras::Vector{Float64}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, titulo::String)

    filtro =
        digitalfilter(
            Lowpass(frecuenciaMaxima / (frecuenciaMuestreo / 2)),
            Butterworth(16)
        )

    return hacerFiltradoDsp(muestras, filtro, titulo)

end

function hacerFiltradoDspPasoBanda(muestras::Vector{Float64}, frecuenciaMuestreo::Float64, frecuenciaMinima::Float64, frecuenciaMaxima::Float64, titulo::String)

    filtro =
        digitalfilter(
            Bandpass(frecuenciaMinima / (frecuenciaMuestreo / 2), frecuenciaMaxima / (frecuenciaMuestreo / 2)),
            Butterworth(16)
        )

    return hacerFiltradoDsp(muestras, filtro, titulo)

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

frecuenciaMaxima = 3_000.0
frecuenciaMuestreo = Float64(fs)
muestras = y[:, 1]

frecuenciaMinimaPasoAlto = 2_000.0
frecuenciaMaximaPasoBajo = 1_500.0
frecuenciaMinimaPasoBanda = 500.0
frecuenciaMaximaPasoBanda = 1_500.0

filtroPasoAlto = f -> (frecuenciaMinimaPasoAlto < f ? 1.0 : 0.0)
filtroPasoBajo = f -> (f < frecuenciaMaximaPasoBajo ? 1.0 : 0.0)
filtroPasoBanda = f -> ((frecuenciaMinimaPasoBanda < f && f < frecuenciaMaximaPasoBanda) ? 1.0 : 0.0)

muestrasFiltradoPasoAlto = hacerFiltrado(muestras, frecuenciaMuestreo, filtroPasoAlto)
muestrasFiltradoPasoBajo = hacerFiltrado(muestras, frecuenciaMuestreo, filtroPasoBajo)
muestrasFiltradoPasoBanda = hacerFiltrado(muestras, frecuenciaMuestreo, filtroPasoBanda)

muestrasFiltradoDspPasoAlto = hacerFiltradoDspPasoAlto(muestras, frecuenciaMuestreo, frecuenciaMinimaPasoAlto, "Paso alto 2 kHz")
muestrasFiltradoDspPasoBajo = hacerFiltradoDspPasoBajo(muestras, frecuenciaMuestreo, frecuenciaMaximaPasoBajo, "Paso bajo 1.5 kHz")
muestrasFiltradoDspPasoBanda = hacerFiltradoDspPasoBanda(muestras, frecuenciaMuestreo, frecuenciaMinimaPasoBanda, frecuenciaMaximaPasoBanda, "Paso banda 0.5 - 1.5 kHz")

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
duracionFiltradoPasoAlto = size(muestrasFiltradoPasoAlto)[1] / frecuenciaMuestreo
duracionFiltradoPasoBajo = size(muestrasFiltradoPasoBajo)[1] / frecuenciaMuestreo
duracionFiltradoPasoBanda = size(muestrasFiltradoPasoBanda)[1] / frecuenciaMuestreo
duracionFiltradoDspPasoAlto = size(muestrasFiltradoDspPasoAlto)[1] / frecuenciaMuestreo
duracionFiltradoDspPasoBajo = size(muestrasFiltradoDspPasoBajo)[1] / frecuenciaMuestreo
duracionFiltradoDspPasoBanda = size(muestrasFiltradoDspPasoBanda)[1] / frecuenciaMuestreo
duracionGenerado = size(muestrasGenerado)[1] / frecuenciaMuestreo

bloquesInicial = TransformadorFourier.hacerBloques(muestras)
bloquesFiltradoPasoAlto = TransformadorFourier.hacerBloques(muestrasFiltradoPasoAlto)
bloquesFiltradoPasoBajo = TransformadorFourier.hacerBloques(muestrasFiltradoPasoBajo)
bloquesFiltradoPasoBanda = TransformadorFourier.hacerBloques(muestrasFiltradoPasoBanda)
bloquesFiltradoDspPasoAlto = TransformadorFourier.hacerBloques(muestrasFiltradoDspPasoAlto)
bloquesFiltradoDspPasoBajo = TransformadorFourier.hacerBloques(muestrasFiltradoDspPasoBajo)
bloquesFiltradoDspPasoBanda = TransformadorFourier.hacerBloques(muestrasFiltradoDspPasoBanda)
bloquesGenerado = TransformadorFourier.hacerBloques(muestrasGenerado)

grafos = [
    hacerFftComplejo(bloquesInicial, frecuenciaMuestreo, frecuenciaMaxima, duracionOriginal, "Original"),
    hacerFftComplejo(bloquesFiltradoPasoAlto, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltradoPasoAlto, "Paso alto 2 kHz"),
    hacerFftComplejo(bloquesFiltradoPasoBajo, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltradoPasoBajo, "Paso bajo 1.5 kHz"),
    hacerFftComplejo(bloquesFiltradoPasoBanda, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltradoPasoBanda, "Paso banda 0.5 - 1.5 kHz"),
    hacerFftComplejo(bloquesGenerado, frecuenciaMuestreo, frecuenciaMaxima, duracionGenerado, "Generado"),
    hacerFftComplejo(bloquesFiltradoDspPasoAlto, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltradoDspPasoAlto, "DSP - Paso alto 2 kHz"),
    hacerFftComplejo(bloquesFiltradoDspPasoBajo, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltradoDspPasoBajo, "DSP - Paso bajo 1.5 kHz"),
    hacerFftComplejo(bloquesFiltradoDspPasoBanda, frecuenciaMuestreo, frecuenciaMaxima, duracionFiltradoDspPasoBanda, "DSP - Paso banda 0.5 - 1.5 kHz"),
    plot(),
    plot(0:Int(frecuenciaMaxima), filtroPasoAlto.(0:Int(frecuenciaMaxima)), title="Paso alto 2 kHz"),
    plot(0:Int(frecuenciaMaxima), filtroPasoBajo.(0:Int(frecuenciaMaxima)), title="Paso bajo 1.5 kHz"),
    plot(0:Int(frecuenciaMaxima), filtroPasoBanda.(0:Int(frecuenciaMaxima)), title="Paso banda 0.5 - 1.5 kHz"),
]

p = plot(
    grafos...,
    layout=(Int(ceil(size(grafos)[1] / 4)), 4)
)

display(p)

wavplay(y, fs)
wavplay(hcat(muestrasFiltradoPasoAlto, muestrasFiltradoPasoAlto), fs)
wavplay(hcat(muestrasFiltradoDspPasoAlto, muestrasFiltradoDspPasoAlto), fs)
wavplay(hcat(muestrasFiltradoPasoBajo, muestrasFiltradoPasoBajo), fs)
wavplay(hcat(muestrasFiltradoDspPasoBajo, muestrasFiltradoDspPasoBajo), fs)
wavplay(hcat(muestrasFiltradoPasoBanda, muestrasFiltradoPasoBanda), fs)
wavplay(hcat(muestrasFiltradoDspPasoBanda, muestrasFiltradoDspPasoBanda), fs)
wavplay(hcat(muestrasGenerado, muestrasGenerado), fs)

println("Pulsa Enter para cerrar...")
readline()
