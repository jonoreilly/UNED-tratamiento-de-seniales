module NotasMusicales

export Notas

struct Notas
    Si::Vector{Float64}
    LaS_SiB::Vector{Float64}
    La::Vector{Float64}
    SolS_LaB::Vector{Float64}
    Sol::Vector{Float64}
    FaS_SolB::Vector{Float64}
    Fa::Vector{Float64}
    Mi::Vector{Float64}
    ReS_MiB::Vector{Float64}
    Re::Vector{Float64}
    DoS_ReB::Vector{Float64}
    Do::Vector{Float64}
end


Si = [123.47, 246.94, 493.88, 987.77]
LaS_SiB = [116.54, 233.08, 466.16, 932.33]
La = [110.00, 220.00, 440.00, 880.00]
SolS_LaB = [207.65, 415.30, 830.61]
Sol = [196.00, 392.00, 783.99]
FaS_SolB = [185.00, 369.99, 739.99]
Fa = [174.61, 349.23, 698.46]
Mi = [164.81, 329.63, 659.26]
ReS_MiB = [155.56, 311.13, 622.25]
Re = [146.83, 293.66, 587.33]
DoS_ReB = [138.59, 277.18, 554.37, 1174.66]
Do = [130.81, 261.63, 523.25, 1046.50]

# Si = [246.94]
# LaS_SiB = [233.08]
# La = [220.00]
# SolS_LaB = [415.30]
# Sol = [392.00]
# FaS_SolB = [369.99]
# Fa = [349.23]
# Mi = [329.63]
# ReS_MiB = [311.13]
# Re = [293.66]
# DoS_ReB = [277.18]
# Do = [261.63]

Notas(
    ; Si=Si, LaS_SiB=LaS_SiB, La=La, SolS_LaB=SolS_LaB, Sol=Sol, FaS_SolB=FaS_SolB, Fa=Fa, Mi=Mi, ReS_MiB=ReS_MiB, Re=Re, DoS_ReB=DoS_ReB, Do=Do
) = Notas(Si, LaS_SiB, La, SolS_LaB, Sol, FaS_SolB, Fa, Mi, ReS_MiB, Re, DoS_ReB, Do)

end