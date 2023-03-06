using BenchmarkTools
import Nettle, AESNI, AES

KEY = hex2bytes("013ff43104f53f5c360a502dbff8adb7db39599be1ade3cc05a72e6e07103302")

for key_size in AESNI.AES_KEY_SIZES

    @info "Key size: $key_size"
    key = KEY[1:key_size÷8]

    aesni_ecb = AESNI.AesCipher(key_size, AESNI.ECB, key)
    aesni_key = aesni_ecb.key

    nettle_enc = Nettle.Encryptor("AES$key_size", key)
    nettle_dec = Nettle.Decryptor("AES$key_size", key)

    aes_key = AES.convert_key(key, Val(key_size))
    aes_ecb = AES.AESCipher(; key_length=key_size, mode=AES.ECB, key=aes_key)

    plain = hex2bytes("fac25f0d5274b1d9168b0816753a784a")

    cipher = AESNI.encrypt(aesni_key, plain)

    @assert cipher == Nettle.encrypt(nettle_enc, plain)
    @assert AESNI.decrypt(aesni_key, cipher) == plain
    @assert Nettle.decrypt(nettle_dec, cipher) == plain

    @info "Benchmarking block ciphers"
    @info "AESNI.encrypt"
    @btime AESNI.encrypt($aesni_key, $plain)
    @info "AESNI.decrypt"
    @btime AESNI.decrypt($aesni_key, $cipher)
    @info "Nettle.encrypt"
    @btime Nettle.encrypt($nettle_enc, $plain)
    @info "Nettle.decrypt"
    @btime Nettle.decrypt($nettle_dec, $cipher)
    if key_size != 256
        # `encrypt` with AES256Key is missing in AES.jl
        @info "AES.encrypt"
        cipher_aes = @btime AES.encrypt($plain, $aes_ecb)
        @info "AES.decrypt"
        @btime AES.decrypt($cipher_aes, $aes_ecb)
    end

    large_plain = rand(UInt8, 10 * 2^20)
    large_cipher = AESNI.encrypt(aesni_ecb, large_plain)

    @info "Benchmarking ECB with larger data (10MB)"
    @info "AESNI.encrypt"
    @btime AESNI.encrypt($aesni_ecb, $large_plain)
    @info "AESNI.decrypt"
    @btime AESNI.decrypt($aesni_ecb, $large_cipher)
    @info "Nettle.encrypt"
    @btime Nettle.encrypt($nettle_enc, $large_plain)
    @info "Nettle.decrypt"
    @btime Nettle.decrypt($nettle_dec, $large_cipher)
    if key_size != 256
        @info "AES.encrypt"
        large_cipher_aes = @btime AES.encrypt($large_plain, $aes_ecb)
        @info "AES.decrypt"
        @btime AES.decrypt($large_cipher_aes, $aes_ecb)
    end

    println(stderr)
end
