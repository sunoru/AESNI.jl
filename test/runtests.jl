using AESNI
using Test

@testset "AESNI.jl" begin
    include("./intrinsics.jl")
    include("./block_ciphers.jl")
end
