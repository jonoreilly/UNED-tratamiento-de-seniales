using WAV
using Plots

y, fs = wavread(raw"C:\Windows\Media\Ring01.wav")

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

println("typeof(y):", typeof(y))

println("size(y):", size(y))

println("y[1, :]:", y[1:20, :])

# Interpolación constante

constante = interpolar(y, (inicial, final) -> [inicial, inicial, final])

println("typeof(constante):", typeof(constante))

println("size(constante)::", size(constante))

println("constante[1, :]:", constante[1:20, :])

# Interpolación lineal

lineal = interpolar(y, (inicial, final) -> begin

    distanciaPaso = (final - inicial) / 4

    return ((1:3) .* distanciaPaso) .+ inicial

end)

println("typeof(lineal):", typeof(lineal))

println("size(lineal)::", size(lineal))

println("lineal[1, :]:", lineal[1:20, :])

nuevaFrecuencia = fs * 4

# wavplay(y, fs)
# wavplay(constante, nuevaFrecuencia)
# wavplay(lineal, nuevaFrecuencia)

p = plot(3000:4000, interpolar(y, (inicial, final) -> [inicial, inicial, inicial])[3000:4000, 1], seriestype=:line, size=(1900, 900))
plot!(3000:4000, constante[3000:4000, 1], seriestype=:line, size=(1900, 900))
plot!(3000:4000, lineal[3000:4000, 1], seriestype=:line, size=(1900, 900))

display(p)

println("Press Enter to close...")
readline()