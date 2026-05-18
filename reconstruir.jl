using WAV
using Plots

include("fourierTransform/main.jl")

using .FourierTransform

y, frecuenciaMuestreo = wavread(raw".\audio\aoe.wav")
# y, frecuenciaMuestreo = wavread(raw"C:\Windows\Media\Alarm02.wav")
# y, frecuenciaMuestreo = wavread(raw"C:\Windows\Media\Ring01.wav")
# y, frecuenciaMuestreo = wavread(raw".\example.wav")


frecuenciaMaxima = Float64(frecuenciaMuestreo)

# DFT Matriz complejos 1

bloques1 = FourierTransform.hacerBloques(y[:, 1])

println("DFT Matriz complejo 1")

tInicioDftMatrizComplejo1 = time()

cacheMatrizDftComplejo = FourierTransform.CacheMatrizDftComplejo(0, 0, 0, Matrix{ComplexF64}(undef, 0, 0))

dftMatrizComplejo1 = FourierTransform.dftPorMatrizesComplejo.(bloques1, frecuenciaMuestreo, frecuenciaMaxima, Ref(cacheMatrizDftComplejo))

duracionDftMatrizComplejo1 = time() - tInicioDftMatrizComplejo1

println("duración DFT Matriz complejo 1: ", round(duracionDftMatrizComplejo1, digits=1), "s")

pDft1 = FourierTransform.hacerGrafoComplejo(dftMatrizComplejo1, frecuenciaMaxima, frecuenciaMaximaGrafo=2_000.0, titulo="DFT Matriz complejo 1 ($(round(duracionDftMatrizComplejo1, digits=1))s)")

# Inverso DFT Matriz complejos

println("Inverso DFT Matriz complejo")

tInicioInversoDftMatrizComplejo = time()

cacheMatrizInversaDftComplejo = FourierTransform.CacheMatrizInversaDftComplejo(0, 0, 0, Matrix{ComplexF64}(undef, 0, 0))

muestrasEnBloques = FourierTransform.inversoDftPorMatrizesComplejo.(dftMatrizComplejo1, frecuenciaMuestreo, frecuenciaMaxima, Ref(cacheMatrizInversaDftComplejo))

muestras = FourierTransform.invertirBloques(muestrasEnBloques)

duracionDftInversoMatrizComplejo = time() - tInicioInversoDftMatrizComplejo

println("duración inverso DFT Matriz complejo: ", round(duracionDftInversoMatrizComplejo, digits=1), "s")

# DFT Matriz complejos 2

println("DFT Matriz complejo 2")

bloques2 = FourierTransform.hacerBloques(muestras)

tInicioDftMatrizComplejo2 = time()

dftMatrizComplejo2 = FourierTransform.dftPorMatrizesComplejo.(bloques2, frecuenciaMuestreo, frecuenciaMaxima, Ref(cacheMatrizDftComplejo))

duracionDftMatrizComplejo2 = time() - tInicioDftMatrizComplejo2

println("duración DFT Matriz complejo 2: ", round(duracionDftMatrizComplejo2, digits=1), "s")

pDft2 = FourierTransform.hacerGrafoComplejo(dftMatrizComplejo2, frecuenciaMaxima, frecuenciaMaximaGrafo=2_000.0, titulo="DFT Matriz complejo 2 ($(round(duracionDftMatrizComplejo2, digits=1))s)")

# Audio

println("Reproducioendo original...")

# wavplay(y, frecuenciaMuestreo)

println("Reproducioendo reconstruido...")

wavplay(repeat(muestras, 1, 2), frecuenciaMuestreo)

# Graficos

p = plot(pDft1, pDft2, layout=(1, 2))

display(p)



println("Press Enter to close...")
readline()