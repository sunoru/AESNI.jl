const LITTLE_ENDIAN = ENDIAN_BOM ≡ 0x04030201
const __m128i = NTuple{2,VecElement{UInt64}}

# This struct is used to indirectly convert between `UInt128` and `__m128i`.
struct AesniUInt128
    value::__m128i
    AesniUInt128(x::__m128i) = new(x)
    AesniUInt128(x::UInt128) = new(unsafe_load(Ptr{__m128i}(pointer_from_objref(Ref(x)))))
    AesniUInt128(x::Integer) = AesniUInt128(UInt128(x))
    AesniUInt128(hi::UInt64, lo::UInt64) = LITTLE_ENDIAN ? new((VecElement(lo), VecElement(hi))) : new((VecElement(hi), VecElement(lo)))
end
Base.convert(::Type{UInt128}, x::AesniUInt128) = unsafe_load(Ptr{UInt128}(pointer_from_objref(Ref(x.value))))
Base.convert(::Type{AesniUInt128}, x::Integer) = AesniUInt128(UInt128(x))
Base.cconvert(::Type{__m128i}, x::AesniUInt128) = x.value
Base.UInt128(x::AesniUInt128) = convert(UInt128, x)

@inline aes_enc(a::UInt128, round_key::UInt128) = ccall(
    "llvm.x86.aesni.aesenc",
    llvmcall,
    __m128i, (__m128i, __m128i),
    AesniUInt128(a), AesniUInt128(round_key)
) |> AesniUInt128 |> UInt128

@inline aes_enc_last(a::UInt128, round_key::UInt128) = ccall(
    "llvm.x86.aesni.aesenclast",
    llvmcall,
    __m128i, (__m128i, __m128i),
    AesniUInt128(a), AesniUInt128(round_key)
) |> AesniUInt128 |> UInt128

@inline aes_dec(a::UInt128, round_key::UInt128) = ccall(
    "llvm.x86.aesni.aesdec",
    llvmcall,
    __m128i, (__m128i, __m128i),
    AesniUInt128(a), AesniUInt128(round_key)
) |> AesniUInt128 |> UInt128

@inline aes_dec_last(a::UInt128, round_key::UInt128) = ccall(
    "llvm.x86.aesni.aesdeclast",
    llvmcall,
    __m128i, (__m128i, __m128i),
    AesniUInt128(a), AesniUInt128(round_key)
) |> AesniUInt128 |> UInt128

@inline aes_key_gen_assist(a::UInt128, ::Val{R}) where {R} = ccall(
    "llvm.x86.aesni.aeskeygenassist",
    llvmcall,
    __m128i, (__m128i, UInt8),
    AesniUInt128(a), R
) |> AesniUInt128 |> UInt128

@inline aes_imc(v::UInt128) = ccall(
    "llvm.x86.aesni.aesimc",
    llvmcall,
    __m128i, (__m128i,),
    AesniUInt128(v)
) |> AesniUInt128 |> UInt128
