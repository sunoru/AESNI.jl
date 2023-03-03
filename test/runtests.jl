using AESNI
using Test

@testset "AESNI.jl" begin
    rkey = 0x823597d93cbfa18e0c4c0d20d65074dd
    plain = 0xaa708807c292c7564a466d2326f1cea3

    key128 = Aes128Key(rkey)
    cipher128 = encrypt(plain, key128)
    @test cipher128 == 0xbca7356246fba413479dabec622c9fec
    @test decrypt(cipher128, key128) == plain

    key192 = Aes192Key(rkey)
    cipher192 = encrypt(plain, key192)
    @test cipher192 == 0x5260d2be950d2afee01586ae613a20db
    @test decrypt(cipher192, key192) == plain
end
