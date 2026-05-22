module Filtros

include("filtrarFrecuencias.jl")

using .FiltrarFrecuencias

export
    filtrarFrecuencias,
    filtrarPasoBajo,
    filtrarPasoAlto,
    filtrarPasoBanda

end