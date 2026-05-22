module GeneradorMusical

include("notasMusicales.jl")
include("../transformadorFourier/main.jl")

using .NotasMusicales
using .TransformadorFourier

export
    Acorde,
    generarFrecuenciasAcorde,
    generarMuestrasAcordes

struct Acorde
    Si::Bool
    LaS_SiB::Bool
    La::Bool
    SolS_LaB::Bool
    Sol::Bool
    FaS_SolB::Bool
    Fa::Bool
    Mi::Bool
    ReS_MiB::Bool
    Re::Bool
    DoS_ReB::Bool
    Do::Bool
end

Acorde(
    ; Si=false, LaS_SiB=false, La=false, SolS_LaB=false, Sol=false, FaS_SolB=false, Fa=false, Mi=false, ReS_MiB=false, Re=false, DoS_ReB=false, Do=false
) = Acorde(Si, LaS_SiB, La, SolS_LaB, Sol, FaS_SolB, Fa, Mi, ReS_MiB, Re, DoS_ReB, Do)

function generarFrecuenciasAcorde(acorde::Acorde)::Vector{Float64}

    notas = NotasMusicales.Notas()

    frecuencias = [
        (acorde.Si ? notas.Si : []);
        (acorde.LaS_SiB ? notas.LaS_SiB : []);
        (acorde.La ? notas.La : []);
        (acorde.SolS_LaB ? notas.SolS_LaB : []);
        (acorde.Sol ? notas.Sol : []);
        (acorde.FaS_SolB ? notas.FaS_SolB : []);
        (acorde.Fa ? notas.Fa : []);
        (acorde.Mi ? notas.Mi : []);
        (acorde.ReS_MiB ? notas.ReS_MiB : []);
        (acorde.Re ? notas.Re : []);
        (acorde.DoS_ReB ? notas.DoS_ReB : []);
        (acorde.Do ? notas.Do : [])
    ]

    return sort(frecuencias)

end

function getFrecuencia(contenedor::Int, contenedoresDeFrecuencias::Int, hzPorContenedor::Float64)

    # En FT las frecuencias aumentan hasta N/2 y luego disminuyen reflejando la primera parte
    return (
        (contenedor > (contenedoresDeFrecuencias / 2)
         ? (contenedoresDeFrecuencias - contenedor)
         : contenedor)
        *
        hzPorContenedor
    )

end

function getFtFrecuencias(frecuencias::Vector{Float64}, frecuenciaMuestreo::Float64)

    contenedoresDeFrecuencias = TransformadorFourier.TamanioBloque * 2

    hzPorContenedor = frecuenciaMuestreo / contenedoresDeFrecuencias

    return [
        (
            any(f -> (
                    getFrecuencia(i, contenedoresDeFrecuencias, hzPorContenedor) <= f
                    &&
                    f <= getFrecuencia(i + 1, contenedoresDeFrecuencias, hzPorContenedor)
                ), frecuencias) ?
            complex(170.0) : complex(0.0)
        )
        for i in (0:contenedoresDeFrecuencias-1)
    ]

end

function generarMuestrasAcordes(muestrasOriginal::Vector{Float64}, frecuenciaMuestreo::Float64, acordes::Vector{Acorde})

    bloques = TransformadorFourier.hacerBloques(muestrasOriginal)

    frecuenciasPorAcorde = generarFrecuenciasAcorde.(acordes)

    ftAcordes = [
        getFtFrecuencias(frecuencias, frecuenciaMuestreo)
        for frecuencias in frecuenciasPorAcorde
    ]

    bloquesPorAcorde = size(bloques)[1] / size(acordes)[1]

    ftGenerado = repeat(ftAcordes, inner=Int(round(bloquesPorAcorde)))

    # Para evitar interferencias destructivas, hay que mezclar las fases de cada componente
    ftGeneradoMezclado = [bloque .|> f -> (abs(f) * cis(2π * rand())) for bloque in ftGenerado]

    cacheMatrizInversaDftComplejo = TransformadorFourier.CacheMatrizInversaDftComplejo(0, 0, 0, Matrix{ComplexF64}(undef, 0, 0))

    resultadoEnBloques = TransformadorFourier.inversoDftPorMatrizesComplejo.(ftGeneradoMezclado, frecuenciaMuestreo, frecuenciaMuestreo, Ref(cacheMatrizInversaDftComplejo))

    resultado = TransformadorFourier.invertirBloques(resultadoEnBloques)

    return resultado

end

end