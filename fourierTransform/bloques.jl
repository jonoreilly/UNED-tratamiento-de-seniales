module Bloques

export hacerBloques, invertirBloques

function generarVentanaHann(N::Int)

    return [0.5 * (1 - cos(2 * pi * n / (N - 1))) for n in (0:N-1)]

end

TamanioBloque = 2^12

Solapamiento = 0.75

"Separa las muestras en bloques iguales y las preprocesa para mejorar el resultado del analisis de frecuencias"
function hacerBloques(muestras::Vector{Float64}; tamanioBloque::Int=TamanioBloque, solapamiento=Solapamiento)

    muestrasConPadding = [zeros(tamanioBloque); muestras; zeros(tamanioBloque)]

    bloques = [
        (muestrasConPadding[inicio:(inicio+tamanioBloque-1)])
        for inicio in (1:Int(floor(tamanioBloque * (1 - solapamiento))):((size(muestrasConPadding)[1])-tamanioBloque))
    ]

    ventanaHann = generarVentanaHann(tamanioBloque)

    bloquesSuavizados = [bloque .* ventanaHann for bloque in bloques]

    bloquesConPadding = [[bloque; zeros(size(bloque)[1])] for bloque in bloquesSuavizados]

    return bloquesConPadding

end

"Recombina los bloques para devolver la muestra original"
function invertirBloques(muestrasEnBloques::Vector{Vector{Float64}}; tamanioBloque::Int=TamanioBloque, solapamiento=Solapamiento)

    nBloques = size(muestrasEnBloques)[1]

    longitudOriginal = Int(round((tamanioBloque * solapamiento) + nBloques * (tamanioBloque * (1 - solapamiento))))

    ventanaHann = generarVentanaHann(tamanioBloque)

    ventanaHannCuadrada = ventanaHann .^ 2

    suma = zeros(longitudOriginal)
    pesos = zeros(longitudOriginal)

    for index in 1:nBloques

        inicio = Int(round((index - 1) * (tamanioBloque * (1 - solapamiento)) + 1))

        suma[inicio:(inicio+tamanioBloque-1)] .+= muestrasEnBloques[index][1:tamanioBloque]
        pesos[inicio:(inicio+tamanioBloque-1)] .+= ventanaHannCuadrada

    end

    muestrasReconstruidas = suma ./ pesos

    muestrasSinPadding = muestrasReconstruidas[tamanioBloque:end-tamanioBloque]

    return muestrasSinPadding

end

end