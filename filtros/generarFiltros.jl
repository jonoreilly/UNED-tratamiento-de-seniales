
function getFiltroSuperior(frecuencia::Float64, filtros::Vector{Tuple{Int,Float64}})::Union{Tuple{Int,Float64},Nothing}

    superiores = filter(v -> v[1] >= frecuencia, filtros)

    if (isempty(superiores))

        return nothing

    end

    return argmin(v -> v[1], superiores)

end

function getFiltroInferior(frecuencia::Float64, filtros::Vector{Tuple{Int,Float64}})::Union{Tuple{Int,Float64},Nothing}

    inferiores = filter(v -> v[1] <= frecuencia, filtros)

    if (isempty(inferiores))

        return nothing

    end

    return argmax(v -> v[1], inferiores)

end

function getPermisividad(frecuencia::Float64, filtros::Vector{Tuple{Int,Float64}})::Float64

    filtroInferior = getFiltroInferior(frecuencia, filtros)
    filtroSuperior = getFiltroSuperior(frecuencia, filtros)

    if (filtroInferior === nothing && filtroSuperior === nothing)

        return 1.0

    end

    if (filtroInferior === nothing)

        return filtroSuperior[2]

    end

    if (filtroSuperior === nothing)

        return filtroInferior[2]

    end

    frecuenciaInferior = filtroInferior[1]
    frecuenciaSuperior = filtroSuperior[1]

    permisividadInferior = filtroInferior[2]
    permisividadSuperior = filtroSuperior[2]

    distanciaFiltros = frecuenciaSuperior - frecuenciaInferior

    diferenciaPermisividades = permisividadSuperior - permisividadInferior

    porcentajeFrecuencia = (frecuencia - frecuenciaInferior) / distanciaFiltros

    permisividad = (diferenciaPermisividades * porcentajeFrecuencia) + permisividadInferior

    return permisividad

end

# filtros = [(800, 0.0), (801, 1.0), (1200, 0.2), (1500, 1.0), (1501, 0.0)]

# [200.0, 1000.0, 1050.0, 1100.0, 1150.0, 2000.0] .|> f -> begin

#     println("")
#     println("f: ", f)
#     println("filtroInferior: ", getFiltroInferior(f, filtros))
#     println("filtroSuperior: ", getFiltroSuperior(f, filtros))
#     println("permisividad: ", getPermisividad(f, filtros))

# end