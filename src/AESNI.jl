module AESNI

export encrypt, decrypt

export Aes128EncryptKey, Aes128DecryptKey, Aes128Key
export aes128_encrypt, aes128_decrypt

using Base: llvmcall

include("./intrinsics.jl")
include("./common.jl")
include("./aes128.jl")

end
