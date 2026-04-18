using WAV
using Plots

# y, fs = wavread(raw".\aoe.wav")
# y, fs = wavread(raw"C:\Windows\Media\Alarm02.wav")
y, fs = wavread(raw"C:\Windows\Media\Ring01.wav")
# y, fs = wavread(raw".\example.wav")

function DFT(muestras::Vector{Float64}, frecuenciaMuestreo::Float32)

    N = size(muestras)[1]

    frecuencias = N / 10 + 1

    componentesFrecuencias = (0:frecuencias-1) .|> f -> begin

        angulos = (0:N-1) .* ((-2 * pi * f) / N)

        real = sum(muestras .* cos.(angulos))

        imaginario = sum(muestras .* sin.(angulos))

        frecuencia = f * frecuenciaMuestreo / N

        return (real, imaginario, frecuencia)

    end

    return componentesFrecuencias

end

function hann_window(bloque)
    N = size(bloque)[1]

    return bloque .* [0.5 * (1 - cos(2π * n / (N - 1))) for n in 0:N-1]
end

tamanioBloque = 600

bloquesMuestras = (1:Int(floor(tamanioBloque * 0.25)):((size(y)[1])-tamanioBloque)) .|> inicio -> hann_window(y[inicio:(inicio+tamanioBloque), 1])

println("typeof(bloquesMuestras): ", typeof(bloquesMuestras))

dft = bloquesMuestras .|> x -> DFT([x; zeros(size(x)[1] * 10)], fs)

println("typeof(dft): ", typeof(dft))
println("size(dft): ", size(dft))

intensidades = dft .|> b -> (b .|> f -> abs(f[1] + f[2] * im))

println("typeof(intensidades): ", typeof(intensidades))
println("size(intensidades): ", size(intensidades))

p = heatmap(1:size(intensidades)[1], 1:size(intensidades[1])[1], hcat(intensidades...), size=(1900, 900))

display(p)

println("Press Enter to close...")
readline()