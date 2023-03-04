const IS_BIG_ENDIAN = ENDIAN_BOM ≡ 0x01020304

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

function to_bytes(x::Core.BuiltinInts; bigendian=false)
    t = unsafe_reinterpret_convert(UInt8, x, Val(sizeof(x)))
    bigendian == IS_BIG_ENDIAN ? t : reverse(t)
end
to_bytes(x::Integer; bigendian=false) = to_bytes(x % UInt128; bigendian)
to_bytes(x::AbstractString; bigendian=false) = Vector{UInt8}(bigendian ? reverse(x) : x)
const ByteSeq = Union{AbstractArray{UInt8},Tuple{Vararg{UInt8}}}
function pad_or_trunc(x::ByteSeq, ::Val{N}) where {N}
    n = length(x)
    if n ≥ N
        Tuple(x[1:N])
    else
        Tuple((x..., zeros(UInt8, N - n)...))
    end::NTuple{N,UInt8}
end
# Always little endian
to_uint128(x::NTuple{16,UInt8}) = unsafe_reinterpret_convert(
    UInt128, IS_BIG_ENDIAN ? reverse(x) : x
)

to_uint128(x::ByteSeq) = to_uint128(pad_or_trunc(x, Val(16)))
