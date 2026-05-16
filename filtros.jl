using WAV
using Plots

include("fourierTransform/main.jl")

using .FourierTransform

# y, frecuenciaMuestreo = wavread(raw".\aoe.wav")
y, frecuenciaMuestreo = wavread(raw"C:\Windows\Media\Alarm02.wav")
# y, frecuenciaMuestreo = wavread(raw"C:\Windows\Media\Ring01.wav")
# y, frecuenciaMuestreo = wavread(raw".\example.wav")

bloques = FourierTransform.hacerBloques(y[:, 1])

frecuenciaMaxima = 2_000.0

# DFT

function hacerDft(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT")

    tInicioDft = time()

    dft = FourierTransform.dftSeparado.(bloques, frecuenciaMuestreo, frecuenciaMaxima)

    duracionDft = time() - tInicioDft

    println("duración DFT: ", round(duracionDft, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(dft, frecuenciaMaxima, titulo="DFT ($(round(duracionDft, digits=1))s)")

end

# FFT

function hacerFft(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("FFT")

    tInicioFft = time()

    fft = FourierTransform.fftSeparado.(bloques .|> x -> (x .|> v -> (v, 0.0)))

    duracionFft = time() - tInicioFft

    println("duración FFT: ", round(duracionFft, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(fft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, titulo="FFT ($(round(duracionFft, digits=1))s)")

end

# DFT Matriz

function hacerDftMatriz(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Matriz")

    tInicioDftMatriz = time()

    cacheMatrizDft = FourierTransform.CacheMatrizDft(0, 0, 0, Matrix{Float64}(undef, 0, 0), Matrix{Float64}(undef, 0, 0))

    dftMatriz = FourierTransform.dftPorMatrizesSeparado.(bloques, frecuenciaMuestreo, frecuenciaMaxima, Ref(cacheMatrizDft))

    duracionDftMatriz = time() - tInicioDftMatriz

    println("duración DFT Matriz: ", round(duracionDftMatriz, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(dftMatriz, frecuenciaMaxima, titulo="DFT Matriz ($(round(duracionDftMatriz, digits=1))s)")

end

# Graficos

pDft = hacerDft(bloques, frecuenciaMuestreo, frecuenciaMaxima)

pFft = hacerFft(bloques, frecuenciaMuestreo, frecuenciaMaxima)

pDftMatriz = hacerDftMatriz(bloques, frecuenciaMuestreo, frecuenciaMaxima)

p = plot(pDft, pFft, pDftMatriz, layout=(1, 3))

display(p)

println("Press Enter to close...")
readline()