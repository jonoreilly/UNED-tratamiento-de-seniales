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

# DFT Separado Total

function hacerDftSeparadoTotal(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Separado Total")

    tInicioDft = time()

    dft = FourierTransform.dftSeparado.(bloques, frecuenciaMuestreo, Float64(frecuenciaMuestreo))

    duracionDft = time() - tInicioDft

    println("duración DFT Separado Total: ", round(duracionDft, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(dft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, titulo="DFT Separado Total ($(round(duracionDft, digits=1))s)")

end

# DFT Complejo Total

function hacerDftComplejoTotal(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Complejo Total")

    tInicioDft = time()

    dft = FourierTransform.dftComplejo.(bloques, frecuenciaMuestreo, Float64(frecuenciaMuestreo))

    duracionDft = time() - tInicioDft

    println("duración DFT Complejo Total: ", round(duracionDft, digits=1), "s")

    return FourierTransform.hacerGrafoComplejo(dft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, titulo="DFT Complejo Total ($(round(duracionDft, digits=1))s)")

end

# DFT Separado Parcial

function hacerDftSeparadoParcial(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Separado Parcial")

    tInicioDft = time()

    dft = FourierTransform.dftSeparado.(bloques, frecuenciaMuestreo, frecuenciaMaxima)

    duracionDft = time() - tInicioDft

    println("duración DFT Separado Parcial: ", round(duracionDft, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(dft, frecuenciaMaxima, titulo="DFT Separado Parcial ($(round(duracionDft, digits=1))s)")

end

# DFT Complejo Parcial

function hacerDftComplejoParcial(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Complejo Parcial")

    tInicioDft = time()

    dft = FourierTransform.dftComplejo.(bloques, frecuenciaMuestreo, frecuenciaMaxima)

    duracionDft = time() - tInicioDft

    println("duración DFT Complejo Parcial: ", round(duracionDft, digits=1), "s")

    return FourierTransform.hacerGrafoComplejo(dft, frecuenciaMaxima, titulo="DFT Complejo Parcial ($(round(duracionDft, digits=1))s)")

end

# FFT Separado

function hacerFftSeparado(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("FFT Separado")

    tInicioFft = time()

    fft = FourierTransform.fftSeparado.(bloques .|> x -> (x .|> v -> (v, 0.0)))

    duracionFft = time() - tInicioFft

    println("duración FFT Separado: ", round(duracionFft, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(fft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, titulo="FFT Separado ($(round(duracionFft, digits=1))s)")

end

# FFT Complejo

function hacerFftComplejo(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("FFT Complejo")

    tInicioFft = time()

    fft = FourierTransform.fftComplejo.(bloques .|> x -> complex.(x))

    duracionFft = time() - tInicioFft

    println("duración FFT Complejo: ", round(duracionFft, digits=1), "s")

    return FourierTransform.hacerGrafoComplejo(fft, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, titulo="FFT Complejo ($(round(duracionFft, digits=1))s)")

end

# DFT Matriz Separado Total

function hacerDftMatrizSeparadoTotal(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Matriz Separado Total")

    tInicioDftMatrizSeparado = time()

    cacheMatrizDftSeparado = FourierTransform.CacheMatrizDftSeparado(0, 0, 0, Matrix{Float64}(undef, 0, 0), Matrix{Float64}(undef, 0, 0))

    dftMatriz = FourierTransform.dftPorMatrizesSeparado.(bloques, frecuenciaMuestreo, Float64(frecuenciaMuestreo), Ref(cacheMatrizDftSeparado))

    duracionDftMatrizSeparado = time() - tInicioDftMatrizSeparado

    println("duración DFT Matriz Separado Total: ", round(duracionDftMatrizSeparado, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(dftMatriz, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, titulo="DFT Matriz Separado Total ($(round(duracionDftMatrizSeparado, digits=1))s)")

end

# DFT Matriz Complejo Total

function hacerDftMatrizComplejoTotal(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Matriz Complejo Total")

    tInicioDftMatrizComplejo = time()

    cacheMatrizDftComplejo = FourierTransform.CacheMatrizDftComplejo(0, 0, 0, Matrix{ComplexF64}(undef, 0, 0))

    dftMatrizComplejo = FourierTransform.dftPorMatrizesComplejo.(bloques, frecuenciaMuestreo, Float64(frecuenciaMuestreo), Ref(cacheMatrizDftComplejo))

    duracionDftMatrizComplejo = time() - tInicioDftMatrizComplejo

    println("duración DFT Matriz Complejo Total: ", round(duracionDftMatrizComplejo, digits=1), "s")

    return FourierTransform.hacerGrafoComplejo(dftMatrizComplejo, frecuenciaMuestreo, frecuenciaMaximaGrafo=frecuenciaMaxima, titulo="DFT Matriz Complejo Total ($(round(duracionDftMatrizComplejo, digits=1))s)")

end

# DFT Matriz Separado Parcial

function hacerDftMatrizSeparadoParcial(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Matriz Separado Parcial")

    tInicioDftMatrizSeparado = time()

    cacheMatrizDftSeparado = FourierTransform.CacheMatrizDftSeparado(0, 0, 0, Matrix{Float64}(undef, 0, 0), Matrix{Float64}(undef, 0, 0))

    dftMatriz = FourierTransform.dftPorMatrizesSeparado.(bloques, frecuenciaMuestreo, frecuenciaMaxima, Ref(cacheMatrizDftSeparado))

    duracionDftMatrizSeparado = time() - tInicioDftMatrizSeparado

    println("duración DFT Matriz Separado Parcial: ", round(duracionDftMatrizSeparado, digits=1), "s")

    return FourierTransform.hacerGrafoSeparado(dftMatriz, frecuenciaMaxima, titulo="DFT Matriz Separado Parcial ($(round(duracionDftMatrizSeparado, digits=1))s)")

end

# DFT Matriz Complejo Parcial

function hacerDftMatrizComplejoParcial(bloques::Vector{Vector{Float64}}, frecuenciaMuestreo::Float32, frecuenciaMaxima::Float64)

    println("DFT Matriz Complejo Parcial")

    tInicioDftMatrizComplejo = time()

    cacheMatrizDftComplejo = FourierTransform.CacheMatrizDftComplejo(0, 0, 0, Matrix{ComplexF64}(undef, 0, 0))

    dftMatrizComplejo = FourierTransform.dftPorMatrizesComplejo.(bloques, frecuenciaMuestreo, frecuenciaMaxima, Ref(cacheMatrizDftComplejo))

    duracionDftMatrizComplejo = time() - tInicioDftMatrizComplejo

    println("duración DFT Matriz Complejo Parcial: ", round(duracionDftMatrizComplejo, digits=1), "s")

    return FourierTransform.hacerGrafoComplejo(dftMatrizComplejo, frecuenciaMaxima, titulo="DFT Matriz Complejo Parcial ($(round(duracionDftMatrizComplejo, digits=1))s)")

end

# Graficos

grafos = [
    hacerDftSeparadoTotal(bloques, frecuenciaMuestreo, frecuenciaMaxima),
    hacerDftComplejoTotal(bloques, frecuenciaMuestreo, frecuenciaMaxima),
    hacerDftSeparadoParcial(bloques, frecuenciaMuestreo, frecuenciaMaxima),
    hacerDftComplejoParcial(bloques, frecuenciaMuestreo, frecuenciaMaxima),
    hacerFftSeparado(bloques, frecuenciaMuestreo, frecuenciaMaxima),
    hacerFftComplejo(bloques, frecuenciaMuestreo, frecuenciaMaxima),
    hacerDftMatrizSeparadoTotal(bloques, frecuenciaMuestreo, frecuenciaMaxima),
    hacerDftMatrizComplejoTotal(bloques, frecuenciaMuestreo, frecuenciaMaxima),
    hacerDftMatrizSeparadoParcial(bloques, frecuenciaMuestreo, frecuenciaMaxima),
    hacerDftMatrizComplejoParcial(bloques, frecuenciaMuestreo, frecuenciaMaxima)
]


p = plot(
    grafos...,
    layout=(2, Int(ceil(size(grafos)[1] / 2)))
)

display(p)

println("Press Enter to close...")
readline()