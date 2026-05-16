module Bloques

export hacerBloques

function ventanaHann(bloque)

    N = size(bloque)[1]

    return bloque .* [0.5 * (1 - cos(2 * pi * n / (N - 1))) for n in (0:N-1)]

end

"Separa las muestras en bloques iguales y las preprocesa para mejorar el resultado del analisis de frecuencias"
function hacerBloques(muestras::Vector{Float64}; tamanioBloque::Int=2^12, solapamiento=0.75)

    muestrasConPadding = [zeros(tamanioBloque); muestras; zeros(tamanioBloque)]

    bloques = [
        (muestrasConPadding[inicio:(inicio+tamanioBloque)])
        for inicio in (1:Int(floor(tamanioBloque * (1 - solapamiento))):((size(muestrasConPadding)[1])-tamanioBloque))
    ]

    bloquesSuavizados = ventanaHann.(bloques)

    bloquesConPadding = [[bloque; zeros(size(bloque)[1])] for bloque in bloquesSuavizados]

    return bloquesConPadding

end

end