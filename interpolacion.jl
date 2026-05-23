using WAV
using Plots

y, fs = wavread(raw".\audio\ukelele.wav")

# Injecta los valores producidos por la funcion de interpolación entre los valores de la fuente 
function interpolar(fuente::Matrix{Float64}, funcion::Function)

    longitud = size(fuente)[1]

    indicesSegmentos = 1:(longitud-1)

    resultadoEnCanales = (1:2) .|> canal -> begin

        fuenteCanal = fuente[:, canal]

        segmentosEntreValores = [funcion(fuenteCanal[i], fuenteCanal[i+1]) for i in indicesSegmentos]

        segmentosConValoresIniciales = [[fuenteCanal[i]; segmentosEntreValores[i]] for i in indicesSegmentos]

        segmentosConValoresInicialesYSegmentoFinal = [segmentosConValoresIniciales; [[fuenteCanal[longitud]]]]

        todosLosValores = collect(Base.Flatten(segmentosConValoresInicialesYSegmentoFinal))

        return todosLosValores

    end

    return hcat(resultadoEnCanales...)

end

# Sin interpolar

sinInterpolar = interpolar(y, (inicial, final) -> [inicial, inicial, inicial])

# Interpolación constante

constante = interpolar(y, (inicial, final) -> [inicial, inicial, final])

# Interpolación lineal

lineal = interpolar(y, (inicial, final) -> begin

    distanciaPaso = (final - inicial) / 4

    return ((1:3) .* distanciaPaso) .+ inicial

end)

rangoDeInteres = (100000:100500)
size = (1900, 900)

p = plot(sinInterpolar[rangoDeInteres, 1], label="Original", seriestype=:line, size=size)
plot!(constante[rangoDeInteres, 1], label="Constante", seriestype=:line, size=size)
plot!(lineal[rangoDeInteres, 1], label="Lineal", seriestype=:line, size=size)

display(p)

nuevaFrecuencia = fs * 4

wavplay(y, fs)
wavplay(constante, nuevaFrecuencia)
wavplay(lineal, nuevaFrecuencia)

println("Pulsa Enter para cerrar...")
readline()