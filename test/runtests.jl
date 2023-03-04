using AESNI
using Test

include("utils.jl")

@testset "AESNI.jl" begin
    include("./intrinsics.jl")
    include("./ecb.jl")
end
