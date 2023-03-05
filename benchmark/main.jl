using BenchmarkTools
import Nettle, AESNI

key = hex2bytes("013ff43104f53f5c360a502dbff8adb7db39599be1ade3cc05a72e6e07103302")

aesni_ctx = AESNI.Aes256Key(key)
nettle_enc = Nettle.Encryptor("AES256", key)
nettle_dec = Nettle.Decryptor("AES256", key)

plain = hex2bytes("fac25f0d5274b1d9168b0816753a784a")

cipher = AESNI.encrypt(aesni_ctx, plain)
@assert cipher == Nettle.encrypt(nettle_enc, plain)
@assert AESNI.decrypt(aesni_ctx, cipher) == plain
@assert Nettle.decrypt(nettle_dec, cipher) == plain

@info "Benchmarking block ciphers"
@info "AESNI.encrypt"
@btime AESNI.encrypt($aesni_ctx, $plain)
@info "AESNI.decrypt"
@btime AESNI.decrypt($aesni_ctx, $cipher)
@info "Nettle.encrypt"
@btime Nettle.encrypt($nettle_enc, $plain)
@info "Nettle.decrypt"
@btime Nettle.decrypt($nettle_dec, $cipher)

large_plain = rand(UInt8, 10 * 2^20)
aesni_ecb = AESNI.Aes256Ecb(key)
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
