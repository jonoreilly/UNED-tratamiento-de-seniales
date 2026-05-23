using WAV
using Plots

include("transformadorFourier/main.jl")

using .TransformadorFourier

y, fs = wavread(raw".\audio\ukelele.wav")

frecuenciaMaxima = 2_000.0

frecuenciaMuestreo = Float64(fs)

muestras = y[:, 1]

duracionOriginal = size(muestras)[1] / frecuenciaMuestreo

bloques = TransformadorFourier.hacerBloques(muestras)

# DFT Separado Total

function hacerDftSeparadoTotal(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64)

    println("DFT Separado Total")

    tInicioDft = time()

    dft = TransformadorFourier.dftSeparado.(bloques, frecuenciaMuestreo, Float64(frecuenciaMuestreo))

    duracionDft = time() - tInicioDft

    println("duración DFT Separado Total: ", round(duracionDft, digits=1), "s")

    return TransformadorFourier.hacerGrafoSeparado(dft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo="DFT Separado Total ($(round(duracionDft, digits=1))s)")

end

# DFT Complejo Total

function hacerDftComplejoTotal(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64)

    println("DFT Complejo Total")

    tInicioDft = time()

    dft = TransformadorFourier.dftComplejo.(bloques, frecuenciaMuestreo, Float64(frecuenciaMuestreo))

    duracionDft = time() - tInicioDft

    println("duración DFT Complejo Total: ", round(duracionDft, digits=1), "s")

    return TransformadorFourier.hacerGrafoComplejo(dft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo="DFT Complejo Total ($(round(duracionDft, digits=1))s)")

end

# DFT Separado Parcial

function hacerDftSeparadoParcial(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64)

    println("DFT Separado Parcial")

    tInicioDft = time()

    dft = TransformadorFourier.dftSeparado.(bloques, frecuenciaMuestreo, frecuenciaMaxima)

    duracionDft = time() - tInicioDft

    println("duración DFT Separado Parcial: ", round(duracionDft, digits=1), "s")

    return TransformadorFourier.hacerGrafoSeparado(dft, frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo="DFT Separado Parcial ($(round(duracionDft, digits=1))s)")

end

# DFT Complejo Parcial

function hacerDftComplejoParcial(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64)

    println("DFT Complejo Parcial")

    tInicioDft = time()

    dft = TransformadorFourier.dftComplejo.(bloques, frecuenciaMuestreo, frecuenciaMaxima)

    duracionDft = time() - tInicioDft

    println("duración DFT Complejo Parcial: ", round(duracionDft, digits=1), "s")

    return TransformadorFourier.hacerGrafoComplejo(dft, frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo="DFT Complejo Parcial ($(round(duracionDft, digits=1))s)")

end

# FFT Separado

function hacerFftSeparado(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64)

    println("FFT Separado")

    tInicioFft = time()

    fft = TransformadorFourier.fftSeparado.(bloques .|> x -> (x .|> v -> (v, 0.0)))

    duracionFft = time() - tInicioFft

    println("duración FFT Separado: ", round(duracionFft, digits=1), "s")

    return TransformadorFourier.hacerGrafoSeparado(fft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo="FFT Separado ($(round(duracionFft, digits=1))s)")

end

# FFT Complejo

function hacerFftComplejo(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64)

    println("FFT Complejo")

    tInicioFft = time()

    fft = TransformadorFourier.fftComplejo.(bloques .|> x -> complex.(x))

    duracionFft = time() - tInicioFft

    println("duración FFT Complejo: ", round(duracionFft, digits=1), "s")

    return TransformadorFourier.hacerGrafoComplejo(fft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo="FFT Complejo ($(round(duracionFft, digits=1))s)")

end

# DFT Matriz Separado Total

function hacerDftMatrizSeparadoTotal(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64)

    println("DFT Matriz Separado Total")

    tInicioDftMatrizSeparado = time()

    cacheMatrizDftSeparado = TransformadorFourier.CacheMatrizDftSeparado(0, 0, 0, Matrix{Float64}(undef, 0, 0), Matrix{Float64}(undef, 0, 0))

    dftMatriz = TransformadorFourier.dftPorMatrizesSeparado.(bloques, frecuenciaMuestreo, Float64(frecuenciaMuestreo), Ref(cacheMatrizDftSeparado))

    duracionDftMatrizSeparado = time() - tInicioDftMatrizSeparado

    println("duración DFT Matriz Separado Total: ", round(duracionDftMatrizSeparado, digits=1), "s")

    return TransformadorFourier.hacerGrafoSeparado(dftMatriz, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo="DFT Matriz Separado Total ($(round(duracionDftMatrizSeparado, digits=1))s)")

end

# DFT Matriz Complejo Total

function hacerDftMatrizComplejoTotal(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64)

    println("DFT Matriz Complejo Total")

    tInicioDftMatrizComplejo = time()

    cacheMatrizDftComplejo = TransformadorFourier.CacheMatrizDftComplejo(0, 0, 0, Matrix{ComplexF64}(undef, 0, 0))

    dftMatrizComplejo = TransformadorFourier.dftPorMatrizesComplejo.(bloques, frecuenciaMuestreo, Float64(frecuenciaMuestreo), Ref(cacheMatrizDftComplejo))

    duracionDftMatrizComplejo = time() - tInicioDftMatrizComplejo

    println("duración DFT Matriz Complejo Total: ", round(duracionDftMatrizComplejo, digits=1), "s")

    return TransformadorFourier.hacerGrafoComplejo(dftMatrizComplejo, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo="DFT Matriz Complejo Total ($(round(duracionDftMatrizComplejo, digits=1))s)")

end

# DFT Matriz Separado Parcial

function hacerDftMatrizSeparadoParcial(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64)

    println("DFT Matriz Separado Parcial")

    tInicioDftMatrizSeparado = time()

    cacheMatrizDftSeparado = TransformadorFourier.CacheMatrizDftSeparado(0, 0, 0, Matrix{Float64}(undef, 0, 0), Matrix{Float64}(undef, 0, 0))

    dftMatriz = TransformadorFourier.dftPorMatrizesSeparado.(bloques, frecuenciaMuestreo, frecuenciaMaxima, Ref(cacheMatrizDftSeparado))

    duracionDftMatrizSeparado = time() - tInicioDftMatrizSeparado

    println("duración DFT Matriz Separado Parcial: ", round(duracionDftMatrizSeparado, digits=1), "s")

    return TransformadorFourier.hacerGrafoSeparado(dftMatriz, frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo="DFT Matriz Separado Parcial ($(round(duracionDftMatrizSeparado, digits=1))s)")

end

# DFT Matriz Complejo Parcial

function hacerDftMatrizComplejoParcial(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float64, frecuenciaMaxima::Float64, duracionOriginal::Float64)

    println("DFT Matriz Complejo Parcial")

    tInicioDftMatrizComplejo = time()

    cacheMatrizDftComplejo = TransformadorFourier.CacheMatrizDftComplejo(0, 0, 0, Matrix{ComplexF64}(undef, 0, 0))

    dftMatrizComplejo = TransformadorFourier.dftPorMatrizesComplejo.(bloques, frecuenciaMuestreo, frecuenciaMaxima, Ref(cacheMatrizDftComplejo))

    duracionDftMatrizComplejo = time() - tInicioDftMatrizComplejo

    println("duración DFT Matriz Complejo Parcial: ", round(duracionDftMatrizComplejo, digits=1), "s")

    return TransformadorFourier.hacerGrafoComplejo(dftMatrizComplejo, frecuenciaMaxima, duracionOriginal=duracionOriginal, titulo="DFT Matriz Complejo Parcial ($(round(duracionDftMatrizComplejo, digits=1))s)")

end

# Graficos

grafos = [
    hacerDftSeparadoTotal,
    hacerDftComplejoTotal,
    hacerDftSeparadoParcial,
    hacerDftComplejoParcial,
    hacerFftSeparado,
    hacerFftComplejo,
    hacerDftMatrizSeparadoTotal,
    hacerDftMatrizComplejoTotal,
    hacerDftMatrizSeparadoParcial,
    hacerDftMatrizComplejoParcial
] .|> f -> f(bloques, frecuenciaMuestreo, frecuenciaMaxima, duracionOriginal)

p = plot(
    grafos...,
    layout=(Int(ceil(size(grafos)[1] / 4)), 4)
)

display(p)

println("Pulsa Enter para cerrar...")
readline()