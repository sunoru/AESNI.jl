module AESNI

export encrypt, decrypt

export Aes128EncryptKey, Aes128DecryptKey, Aes128Key
export aes128_encrypt, aes128_decrypt
export Aes192EncryptKey, Aes192DecryptKey, Aes192Key
export aes192_encrypt, aes192_decrypt

using Base: llvmcall

include("./utils.jl")
include("./Intrinsics.jl")
using .Intrinsics
using .Intrinsics: __m128i, AesniUInt128, to_m128i

include("./common.jl")
include("./aes128.jl")
include("./aes192.jl")

end
