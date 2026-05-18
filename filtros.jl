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

function hacerDftSeparado(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT")

    tInicioDft = time()

    dft = FourierTransform.dftSeparado.(bloques, frecuenciaMuestreo, frecuenciaMaxima)

    duracionDft = time() - tInicioDft

    println("duración DFT: ", round(duracionDft, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(dft, frecuenciaMaxima, titulo="DFT ($(round(duracionDft, digits=1))s)")

end

# FFT

function hacerFftSeparado(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("FFT")

    tInicioFft = time()

    fft = FourierTransform.fftSeparado.(bloques .|> x -> (x .|> v -> (v, 0.0)))

    duracionFft = time() - tInicioFft

    println("duración FFT: ", round(duracionFft, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(fft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, titulo="FFT ($(round(duracionFft, digits=1))s)")

end

# DFT Matriz

function hacerDftMatrizSeparado(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Matriz separado")

    tInicioDftMatrizSeparado = time()

    cacheMatrizDftSeparado = FourierTransform.CacheMatrizDftSeparado(0, 0, 0, Matrix{Float64}(undef, 0, 0), Matrix{Float64}(undef, 0, 0))

    dftMatriz = FourierTransform.dftPorMatrizesSeparado.(bloques, frecuenciaMuestreo, frecuenciaMaxima, Ref(cacheMatrizDftSeparado))

    duracionDftMatrizSeparado = time() - tInicioDftMatrizSeparado

    println("duración DFT Matriz separado: ", round(duracionDftMatrizSeparado, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(dftMatriz, frecuenciaMaxima, titulo="DFT Matriz separado ($(round(duracionDftMatrizSeparado, digits=1))s)")

end

# DFT Matriz complejos

function hacerDftMatrizComplejo(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Matriz complejo")

    tInicioDftMatrizComplejo = time()

    cacheMatrizDftComplejo = FourierTransform.CacheMatrizDftComplejo(0, 0, 0, Matrix{ComplexF64}(undef, 0, 0))

    dftMatrizComplejo = FourierTransform.dftPorMatrizesComplejo.(bloques, frecuenciaMuestreo, frecuenciaMaxima, Ref(cacheMatrizDftComplejo))

    duracionDftMatrizComplejo = time() - tInicioDftMatrizComplejo

    println("duración DFT Matriz complejo: ", round(duracionDftMatrizComplejo, digits=1), "s")

    return FourierTransform.hacerGrafoComplejo(dftMatrizComplejo, frecuenciaMaxima, titulo="DFT Matriz complejo ($(round(duracionDftMatrizComplejo, digits=1))s)")

end

# Graficos

pDft = hacerDftSeparado(bloques, frecuenciaMuestreo, frecuenciaMaxima)

pFft = hacerFftSeparado(bloques, frecuenciaMuestreo, frecuenciaMaxima)

pDftMatriz = hacerDftMatrizSeparado(bloques, frecuenciaMuestreo, frecuenciaMaxima)

pDftMatrizComplejos = hacerDftMatrizComplejo(bloques, frecuenciaMuestreo, frecuenciaMaxima)

p = plot(pDft, pFft, pDftMatriz, pDftMatrizComplejos, layout=(1, 4))

display(p)

println("Press Enter to close...")
readline()