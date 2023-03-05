const IS_BIG_ENDIAN = ENDIAN_BOM ≡ 0x01020304
const AesByteBlock = NTuple{16,VecElement{UInt8}}
const ByteSequence = Union{AbstractArray{UInt8},Tuple{Vararg{UInt8}},Tuple{Vararg{VecElement{UInt8}}}}

@inline function unsafe_reinterpret_convert(::Type{T}, x) where {T}
    r = Ref(x)
    GC.@preserve r unsafe_load(Ptr{T}(pointer_from_objref(r)))
end

@inline function unsafe_reinterpret_convert(::Type{T}, x, N) where {T}
    r = Ref(x)
    GC.@preserve r begin
        p = Ptr{VecElement{T}}(pointer_from_objref(r))
        Tuple(unsafe_load(p, i) for i in 1:N)
    end::NTuple{N,VecElement{T}}
end

macro check_byte_length(bytes)
    quote
        @assert length($(esc(bytes))) == 16 "Invalid length of byte sequence"
    end
end

@inline function to_byte_block_unchecked(x::UInt128)
    bytes = unsafe_reinterpret_convert(UInt8, x, 16)
    @static if IS_BIG_ENDIAN
        reverse(bytes)
    else
        bytes
    end
end
to_byte_block_unchecked(bytes::ByteSequence) = Tuple(VecElement{UInt8}.(bytes))::AesByteBlock

"""
    to_byte_block(x::UInt128) -> NTuple{16,VecElement{UInt8}}
    to_byte_block(bytes::ByteSequence) -> NTuple{16,VecElement{UInt8}}

Converts a `UInt128` or a byte sequence to a little-endian byte sequence.
"""
@inline to_byte_block(x::UInt128) = to_byte_block_unchecked(x)
@inline to_byte_block(bytes::AesByteBlock) = bytes
@inline function to_byte_block(bytes::ByteSequence)
    @check_byte_length bytes
    to_byte_block_unchecked(bytes)
end

from_byte_block(::Type{UInt128}, bytes::AesByteBlock) = to_uint128(bytes)
from_byte_block(::Type{<:AbstractArray{UInt8}}, bytes::AesByteBlock) = UInt8.(bytes)
from_byte_block(::Type{<:Tuple{Vararg{UInt8}}}, bytes::AesByteBlock) = Tuple(UInt8.(bytes))

@inline to_uint128_unchecked(bytes::AesByteBlock) = unsafe_reinterpret_convert(
    UInt128, @static if IS_BIG_ENDIAN
        reverse(bytes)
    else
        bytes
    end
)
@inline to_uint128_unchecked(bytes::ByteSequence) = to_uint128_unchecked(
    to_byte_block_unchecked(bytes)
)
@inline to_uint128_unchecked(bytes::DenseArray{UInt8}) = only(reinterpret(UInt128, bytes))
"""
    to_uint128(bytes::ByteSequence) -> UInt128

Converts a little-endian byte sequence to a `UInt128` value.
"""
@inline to_uint128(bytes::AesByteBlock) = to_uint128_unchecked(bytes)
@inline to_uint128(bytes::ByteSequence) = to_uint128_unchecked(to_byte_block(bytes))
@inline function to_uint128(bytes::DenseArray{UInt8})
    @check_byte_length bytes
    to_uint128_unchecked(bytes)
end
