using WAV
using Plots

# y, frecuenciaMuestreo = wavread(raw".\aoe.wav")
# y, frecuenciaMuestreo = wavread(raw"C:\Windows\Media\Alarm02.wav")
y, frecuenciaMuestreo = wavread(raw"C:\Windows\Media\Ring01.wav")
# y, frecuenciaMuestreo = wavread(raw".\example.wav")

function DFT(muestras::Vector{Float64}, frecuenciaMaxima::Float64)

    N = size(muestras)[1]

    frecuencias = Int(ceil(frecuenciaMaxima * N / frecuenciaMuestreo))

    componentesFrecuencias = (0:frecuencias-1) .|> f -> begin

        angulos = (0:N-1) .* ((-2 * pi * f) / N)

        real = sum(muestras .* cos.(angulos))

        imaginario = sum(muestras .* sin.(angulos))

        return (real, imaginario)

    end

    return componentesFrecuencias

end

function esPotencia2(n::Integer)
    return n > 0 && (n & (n - 1)) == 0
end

function FFT(muestras::Vector{Tuple{Float64,Float64}})

    N = size(muestras)[1]

    if (N == 1)
        return muestras
    end

    if (!esPotencia2(N))
        siguientePotencia2 = 2^ceil(Int, log2(N))

        muestrasPotencia2 = [muestras; (1:(siguientePotencia2-N)) .|> _ -> (0.0, 0.0)]

        return FFT(muestrasPotencia2)
    end

    impar = muestras[1:2:end]

    par = muestras[2:2:end]

    fftImpar = FFT(impar)

    fftPar = FFT(par)

    angulos = (0:(N/2)-1) .* ((-2 * pi) / N)

    senos = sin.(angulos)

    cosenos = cos.(angulos)

    fftParReal = fftPar .|> x -> x[1]

    fftParImaginario = fftPar .|> x -> x[2]

    fftImparReal = fftImpar .|> x -> x[1]

    fftImparImaginario = fftImpar .|> x -> x[2]

    twiddleFactorReal = (cosenos .* fftParReal) .+ (senos .* fftParImaginario)

    twiddleFactorImaginario = (cosenos .* fftParImaginario) .- (senos .* fftParReal)

    resltadoReal = [fftImparReal .+ twiddleFactorReal; fftImparReal .- twiddleFactorReal]

    resltadoImaginario = [fftImparImaginario .+ twiddleFactorImaginario; fftImparImaginario .- twiddleFactorImaginario]

    resultado = [(resltadoReal[i], resltadoImaginario[i]) for i in eachindex(resltadoReal)]

    return resultado

end

function hann_window(bloque)
    N = size(bloque)[1]

    return bloque .* [0.5 * (1 - cos(2π * n / (N - 1))) for n in (0:N-1)]
end

tamanioBloque = 2^12

muestrasConPadding = [zeros(tamanioBloque); y[:, 1]; zeros(tamanioBloque)]

bloquesMuestras = [hann_window(muestrasConPadding[inicio:(inicio+tamanioBloque)]) for inicio in (1:Int(floor(tamanioBloque * 0.125)):((size(muestrasConPadding)[1])-tamanioBloque))]

frecuenciaMaxima = 2_000.0

println("typeof(bloquesMuestras): ", typeof(bloquesMuestras))

# DFT

println("DFT")

tInicioDft = time()

dft = DFT.(bloquesMuestras .|> x -> [x; zeros(size(x)[1])], frecuenciaMaxima)

# dft = bloquesMuestras .|> x -> DFT([x; zeros(size(x)[1])])

duracionDft = time() - tInicioDft

println("duración DFT: ", round(duracionDft, digits=1), "s")
println("typeof(dft): ", typeof(dft))
println("size(dft): ", size(dft))
println("size(dft[1]): ", size(dft[1]))

intensidadesDft = dft .|> b -> (b .|> f -> abs(f[1] + f[2] * im))

println("typeof(intensidadesDft): ", typeof(intensidadesDft))
println("size(intensidadesDft): ", size(intensidadesDft))
println("size(intensidadesDft[1]): ", size(intensidadesDft[1]))

contenedoresDeFrecuenciasDft = size(intensidadesDft[1])[1]

ticksPorHzDft = contenedoresDeFrecuenciasDft / frecuenciaMaxima

limiteEspectroDft = contenedoresDeFrecuenciasDft

pasoDe100HzEnTicksDft = Int(floor(ticksPorHzDft * 100))

yticksDft = (1:pasoDe100HzEnTicksDft:limiteEspectroDft, string.(round.(((0:pasoDe100HzEnTicksDft:limiteEspectroDft-1) .|> tick -> (tick / ticksPorHzDft) / 1000), digits=1)) .* " kHz")

pDft = heatmap(1:size(intensidadesDft)[1], 1:limiteEspectroDft, hcat(intensidadesDft...)[1:limiteEspectroDft, :], size=(1900, 900), title="DFT ($(round(duracionDft, digits=1))s)", yticks=yticksDft)

# FFT

println("FFT")

tInicioFft = time()

fft = FFT.(bloquesMuestras .|> x -> (x .|> v -> (v, 0.0)))

# fft = bloquesMuestras .|> x -> FFT([[(v, 0.0) for v in x]; ((1:size(x)[1]) .|> _ -> (0.0, 0.0))])

duracionFft = time() - tInicioFft

println("duración FFT: ", round(duracionFft, digits=1), "s")
println("typeof(fft): ", typeof(fft))
println("size(fft): ", size(fft))

intensidadesFft = fft .|> b -> (b .|> f -> abs(f[1] + f[2] * im))

println("typeof(intensidadesFft): ", typeof(intensidadesFft))
println("size(intensidadesFft): ", size(intensidadesFft))

contenedoresDeFrecuenciasFft = size(intensidadesFft[1])[1]

ticksPorHzFft = contenedoresDeFrecuenciasFft / frecuenciaMuestreo

limiteEspectroFft = Int(floor(ticksPorHzFft * frecuenciaMaxima + 1))

pasoDe100HzEnTicksFft = Int(floor(ticksPorHzFft * 100))

yticksFft = (1:pasoDe100HzEnTicksFft:limiteEspectroFft, string.(round.(((0:pasoDe100HzEnTicksFft:limiteEspectroFft-1) .|> tick -> (tick / ticksPorHzFft) / 1000), digits=1)) .* " kHz")

pFft = heatmap(1:size(intensidadesFft)[1], 1:limiteEspectroFft, hcat(intensidadesFft...)[1:limiteEspectroFft, :], size=(1900, 900), title="FFT ($(round(duracionFft, digits=1))s)", yticks=yticksFft)

p = plot(pDft, pFft, layout=(1, 2))

display(p)

println("Press Enter to close...")
readline()