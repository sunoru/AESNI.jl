module Intrinsics

using ..AESNI: AESNI, unsafe_reinterpret_convert, to_uint128, ByteSequence
export aes_dec, aes_dec_last, aes_enc, aes_enc_last, aes_key_gen_assist, aes_imc

const __m128i = NTuple{2,VecElement{UInt64}}

# This struct is used to indirectly convert between `UInt128` and `__m128i`.
struct AesniUInt128
    value::__m128i
    AesniUInt128(x::__m128i) = new(x)
    AesniUInt128(x::UInt128) = new(unsafe_reinterpret_convert(__m128i, x))
    AesniUInt128(x::ByteSequence) = AesniUInt128(to_uint128(x))
end
Base.convert(::Type{UInt128}, x::AesniUInt128) = unsafe_reinterpret_convert(UInt128, x.value)
Base.UInt128(x::AesniUInt128) = convert(UInt128, x)
to_m128i(x) = AesniUInt128(x).value
AESNI.to_bytes(x::__m128i) = AesniUInt128(x) |> UInt128 |> AESNI.to_bytes
AESNI.to_uint128(x::__m128i) = AesniUInt128(x) |> UInt128

# will be automatically inlined
@inline _xor(a::__m128i, b::__m128i) = to_uint128(a) ⊻ to_uint128(b) |> to_m128i

"""
    aes_enc(a::UInt128, round_key::UInt128) -> UInt128

Encrypts `a` using `round_key` using the AES-NI instruction `AESENC`.
"""
@inline aes_enc(a::__m128i, round_key::__m128i) = ccall(
    "llvm.x86.aesni.aesenc",
    llvmcall,
    __m128i, (__m128i, __m128i),
    a, round_key
)
@inline aes_enc(a::UInt128, round_key::UInt128) = aes_enc(to_m128i(a), to_m128i(round_key)) |> to_uint128

"""
    aes_enc_last(a::UInt128, round_key::UInt128) -> UInt128

Encrypts `a` using `round_key` using the AES-NI instruction `AESENCLAST`.
"""
@inline aes_enc_last(a::__m128i, round_key::__m128i) = ccall(
    "llvm.x86.aesni.aesenclast",
    llvmcall,
    __m128i, (__m128i, __m128i),
    a, round_key
)
@inline aes_enc_last(a::UInt128, round_key::UInt128) = aes_enc_last(to_m128i(a), to_m128i(round_key)) |> to_uint128

"""
    aes_dec(a::UInt128, round_key::UInt128) -> UInt128

Decrypts `a` using `round_key` using the AES-NI instruction `AESDEC`.
"""
@inline aes_dec(a::__m128i, round_key::__m128i) = ccall(
    "llvm.x86.aesni.aesdec",
    llvmcall,
    __m128i, (__m128i, __m128i),
    a, round_key
)
@inline aes_dec(a::UInt128, round_key::UInt128) = aes_dec(to_m128i(a), to_m128i(round_key)) |> to_uint128

"""
    aes_dec_last(a::UInt128, round_key::UInt128) -> UInt128

Decrypts `a` using `round_key` using the AES-NI instruction `AESDECLAST`.
"""
@inline aes_dec_last(a::__m128i, round_key::__m128i) = ccall(
    "llvm.x86.aesni.aesdeclast",
    llvmcall,
    __m128i, (__m128i, __m128i),
    a, round_key
)
@inline aes_dec_last(a::UInt128, round_key::UInt128) = aes_dec_last(to_m128i(a), to_m128i(round_key)) |> to_uint128

"""
    aes_key_gen_assist(a::UInt128, ::Val{R}) -> UInt128

Assist in AES round key generation using the AES-NI instruction `AESKEYGENASSIST`.
`R` is the round constant.
"""
@inline aes_key_gen_assist(a::__m128i, ::Val{R}) where {R} = ccall(
    "llvm.x86.aesni.aeskeygenassist",
    llvmcall,
    __m128i, (__m128i, UInt8),
    a, R
)
@inline aes_key_gen_assist(a::UInt128, ::Val{R}) where {R} = aes_key_gen_assist(to_m128i(a), Val(R)) |> to_uint128

"""
    aes_imc(v::UInt128) -> UInt128

Inverse mix columns using the AES-NI instruction `AESIMC`.
"""
@inline aes_imc(v::__m128i) = ccall(
    "llvm.x86.aesni.aesimc",
    llvmcall,
    __m128i, (__m128i,),
    v
)
@inline aes_imc(v::UInt128) = aes_imc(to_m128i(v)) |> to_uint128

end
