const IS_BIG_ENDIAN = ENDIAN_BOM ≡ 0x01020304
const ByteSequence = Union{AbstractArray{UInt8},Tuple{Vararg{UInt8}}}
const AesByteBlock = NTuple{16, UInt8}

@inline function unsafe_reinterpret_convert(::Type{T}, x) where {T}
    r = Ref(x)
    GC.@preserve r unsafe_load(Ptr{T}(pointer_from_objref(r)))
end

@inline function unsafe_reinterpret_convert(::Type{T}, x, ::Val{N}) where {T,N}
    r = Ref(x)
    GC.@preserve r begin
        p = Ptr{T}(pointer_from_objref(r))
        Tuple(unsafe_load(p, i) for i in 1:N)
    end::NTuple{N,T}
end

"""
    to_bytes(x::UInt128) -> NTuple{16,UInt8}

Converts a `UInt128` value to a little-endian byte sequence.
"""
@inline function to_bytes(x::UInt128)
    bytes = unsafe_reinterpret_convert(UInt8, x, Val(16))
    @static if IS_BIG_ENDIAN
        reverse(bytes)
    else
        bytes
    end
end

"""
    pad_or_trunc(x::ByteSequence, N)

Pads or truncates a little-endian byte sequence to length `N`.
"""
@inline function pad_or_trunc(x::ByteSequence, N)
    n = length(x)
    if n ≥ N
        Tuple(x[1:N])
    else
        Tuple((x..., zeros(UInt8, N - n)...))
    end::NTuple{N,UInt8}
end

"""
    to_uint128(bytes::ByteSequence) -> UInt128

Converts a little-endian byte sequence to a `UInt128` value.
"""
@inline to_uint128(bytes::AesByteBlock) = unsafe_reinterpret_convert(
    UInt128, @static if IS_BIG_ENDIAN
        reverse(bytes)
    else
        bytes
    end
)
@inline to_uint128(bytes::ByteSequence) = to_uint128(pad_or_trunc(bytes, 16))
