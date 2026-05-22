using WAV
using Plots

include("transformadorFourier/main.jl")

using .TransformadorFourier

y, fs = wavread(raw".\audio\ukelele.wav")
# y, fs = wavread(raw".\audio\aoe.wav")
# y, frecuenciaMuestreo = wavread(raw"C:\Windows\Media\Alarm02.wav")
# y, frecuenciaMuestreo = wavread(raw"C:\Windows\Media\Ring01.wav")
# y, frecuenciaMuestreo = wavread(raw".\example.wav")


# FFT Complejo

function hacerFftComplejo(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64, titulo::String)

    println("FFT Complejo - ", titulo)

    tInicioFft = time()

    fft = TransformadorFourier.fftComplejo.(bloques .|> x -> complex.(x))

    duracionFft = time() - tInicioFft

    println("duración FFT Complejo - ", titulo, ": ", round(duracionFft, digits=1), "s")

    pFft = TransformadorFourier.hacerGrafoComplejo(fft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo=titulo)

    return fft, pFft

end

# Reconstruir señal

function reconstruirSenial(ft::Vector{Vector{ComplexF64}}, frecuenciaMuestreo::Float64)

    println("Reconstruir señal")

    tInicioReconstruirSenial = time()

    muestrasEnBloques = TransformadorFourier.inversorFftComplejo.(ft)

    muestras = TransformadorFourier.invertirBloques(muestrasEnBloques)

    duracionReconstruirSenial = time() - tInicioReconstruirSenial

    println("duración Reconstruir señal: ", round(duracionReconstruirSenial, digits=1), "s")

    return muestras

end

frecuenciaMaxima = 1_000.0
frecuenciaMuestreo = Float64(fs)
muestras = y[:, 1]

# FFT

duracionOriginal = size(muestras)[1] / frecuenciaMuestreo

bloquesOriginal = TransformadorFourier.hacerBloques(muestras)

fftOriginal, pFftOriginal = hacerFftComplejo(bloquesOriginal, frecuenciaMuestreo, frecuenciaMaxima, duracionOriginal, "Original")

# Reconstruir señal

muestrasReconstruido = reconstruirSenial(fftOriginal, frecuenciaMuestreo)

# FFT señal reconstruida

duracionReconstruido = size(muestrasReconstruido)[1] / frecuenciaMuestreo

bloquesReconstruido = TransformadorFourier.hacerBloques(muestrasReconstruido)

fftReconstruido, pFftReconstruido = hacerFftComplejo(bloquesOriginal, frecuenciaMuestreo, frecuenciaMaxima, duracionReconstruido, "Reconstruido")

# Graficos

p = plot(pFftOriginal, pFftReconstruido, layout=(1, 2))
display(p)

# Audio

wavplay(y, fs)
wavplay(hcat(muestrasReconstruido, muestrasReconstruido), fs)

println("Pulsa Enter para cerrar...")
readline()