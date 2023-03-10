module AESNI

# Test if the CPU supports AES-NI
const AESNI_ENABLED = try
    cmd = Base.julia_cmd()
    push!(
        cmd.exec, "-e",
        "const __m128i = NTuple{2, VecElement{UInt64}};" *
        "@assert ccall(\"llvm.x86.aesni.aeskeygenassist\", " *
        "llvmcall, __m128i, (__m128i, UInt8), " *
        "__m128i((0x0123456789123450, 0x9876543210987654)), 0x1) ≡ " *
        "__m128i((0x857c266f7c266e85, 0x2346382146382023))"
    )
    success(cmd)
catch e
    false
end


@static if AESNI_ENABLED
    export Aes128EncryptKey, Aes128DecryptKey, Aes128Key
    export Aes192EncryptKey, Aes192DecryptKey, Aes192Key
    export Aes256EncryptKey, Aes256DecryptKey, Aes256Key

    export encrypt, decrypt
    export AesMode, ECB, CBC, CFB, OFB, CTR
    export AesCipher, aes_mode
    export Aes128Ecb, Aes192Ecb, Aes256Ecb

    using Base: llvmcall
    using MLStyle: @data

    include("./utils.jl")
    include("./Intrinsics.jl")
    using .Intrinsics
    using .Intrinsics: __m128i, to_m128i, to_uint128, _xor

    include("./core/common.jl")
    include("./core/aes128.jl")
    include("./core/aes192.jl")
    include("./core/aes256.jl")

    include("./modes/common.jl")
    include("./modes/ecb.jl")

else
    @warn "This package requires a CPU with AES-NI support."
end

end
