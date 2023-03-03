using AESNI
using Test

@testset "AESNI.jl" begin
    rkey = 0x823597d93cbfa18e0c4c0d20d65074dd
    key = Aes128Key(rkey)
    plain = 0xaa708807c292c7564a466d2326f1cea3
    cipher = encrypt(plain, key)
    @test cipher == 0xbca7356246fba413479dabec622c9fec
    decrypted = decrypt(cipher, key)
    @test decrypted == plain
end
