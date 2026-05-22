module FftComplejo

export fftComplejo

function esPotencia2(n::Integer)::Bool

    return n > 0 && (n & (n - 1)) === 0

end

"Algoritmo FFT con números complejos"
function fftComplejo(muestras::Vector{ComplexF64})::Vector{ComplexF64}

    N = size(muestras)[1]

    if (N === 1)

        return muestras

    end

    if (!esPotencia2(N))

        siguientePotencia2 = 2^ceil(Int, log2(N))

        muestrasPotencia2 = [muestras; zeros(ComplexF64, siguientePotencia2 - N)]

        return fftComplejo(muestrasPotencia2)

    end

    impar = muestras[1:2:end]
    par = muestras[2:2:end]

    fftImpar = fftComplejo(impar)
    fftPar = fftComplejo(par)

    factoresTwiddle = [exp(-2im * pi * n / N) for n in 0:(N/2)-1]

    fftParProcesado = factoresTwiddle .* fftPar

    resultado = [(fftImpar .+ fftParProcesado); (fftImpar .- fftParProcesado)]

    return resultado

end

end