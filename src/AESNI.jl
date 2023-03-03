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

    export encrypt, decrypt

    export Aes128EncryptKey, Aes128DecryptKey, Aes128Key
    export aes128_encrypt, aes128_decrypt
    export Aes192EncryptKey, Aes192DecryptKey, Aes192Key
    export aes192_encrypt, aes192_decrypt
    export Aes256EncryptKey, Aes256DecryptKey, Aes256Key
    export aes256_encrypt, aes256_decrypt

    using Base: llvmcall

    include("./utils.jl")
    include("./Intrinsics.jl")
    using .Intrinsics
    using .Intrinsics: __m128i, AesniUInt128, to_m128i

    include("./common.jl")
    include("./aes128.jl")
    include("./aes192.jl")
    include("./aes256.jl")

else
    @warn "This package requires a CPU with AES-NI support."
end

end
