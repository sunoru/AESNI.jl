using Test
using AESNI
using AESNI.Intrinsics

@testset "Intrinsics" begin
    a = 0xae727fbe27203f7c2cc27781353678f5
    b = 0xcb7d50b720b6b76ebde6fae25dabc1f0
    @test aes_enc(a, b) == 0x386a3ec625ed6657abbe4ab3fdfaf070
    @test aes_enc_last(a, b) == 0x0758ec1951b3657e2ba68feeb91c3416
    @test aes_dec(a, b) == 0xacacd788001402c0d872851f8b052a69
    @test aes_dec_last(a, b) == 0x12d575ed9e92b56f80f83b731fffaa87
    @test aes_key_gen_assist(a, Val(0x01)) == 0xaee440d3e440d2ae0c7125f47125f50c
    @test aes_imc(a) == 0x1239f9cfa31733c3c2caa9b913835947
end