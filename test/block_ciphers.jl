using AESNI
using Test

@testset "Block ciphers" begin
    rkey = 0x823597d93cbfa18e0c4c0d20d65074dd
    plain = 0xaa708807c292c7564a466d2326f1cea3

    key128 = Aes128Key(rkey)
    cipher128 = encrypt(key128, plain)
    @test cipher128 == 0xbca7356246fba413479dabec622c9fec
    @test decrypt(key128, cipher128) == plain

    key192 = Aes192Key(rkey)
    cipher192 = encrypt(key192, plain)
    @test cipher192 == 0x5260d2be950d2afee01586ae613a20db
    @test decrypt(key192, cipher192) == plain

    key256 = Aes256Key(rkey)
    cipher256 = encrypt(key256, plain)
    @test cipher256 == 0x03bfb08e0b71bf1a764b9af709558cf5
    @test decrypt(key256, cipher256) == plain
end
