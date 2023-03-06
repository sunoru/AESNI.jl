const IS_BIG_ENDIAN = ENDIAN_BOM ≡ 0x01020304
const ByteSequence = Union{AbstractArray{UInt8},Tuple{Vararg{UInt8}},Tuple{Vararg{VecElement{UInt8}}}}

@inline function unsafe_reinterpret_convert(::Type{T}, x) where {T}
    r = Ref(x)
    GC.@preserve r unsafe_load(Ptr{T}(pointer_from_objref(r)))
end
@inline function unsafe_reinterpret_convert(::Type{T}, x, N) where {T}
    r = Ref(x)
    GC.@preserve r begin
        ptr = Ptr{T}(pointer_from_objref(r))
        [unsafe_load(ptr, i) for i in 1:N]
    end
end

macro check_byte_length(bytes)
    :(@assert length($(esc(bytes))) == 16 "Invalid length of byte sequence")
end

"""
    from_uint128(T, x::UInt128) -> T

Converts a `UInt128` value to a little-endian byte sequence.
"""
@inline function from_uint128(::Type{<:AbstractArray{UInt8}}, x::UInt128)
    a = unsafe_reinterpret_convert(UInt8, x, 16)
    @static if IS_BIG_ENDIAN
        reverse(a)
    else
        a
    end
end
@inline from_uint128(::Type{T}, x::UInt128) where {T<:Tuple} = T(from_uint128(Vector{UInt8}, x))

"""
    bytes_to_uint128(bytes::ByteSequence) -> UInt128

Converts a little-endian byte sequence to a `UInt128` value.
"""
@inline bytes_to_uint128(bytes::ByteSequence) = bytes_to_uint128(collect(bytes))
@inline function bytes_to_uint128(bytes::DenseArray{UInt8})
    @check_byte_length bytes
    only(reinterpret(UInt128, @static if IS_BIG_ENDIAN
        reverse(bytes)
    else
        bytes
    end))
end
