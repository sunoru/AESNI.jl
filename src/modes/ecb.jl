struct AesEcbCipher{T<:AbstractAesKey} <: AbstractAesCipher{typeof(ECB)}
    key::T
    AesEcbCipher(aes_key::T) where {T<:AbstractAesKey} = new{T}(aes_key)
    AesEcbCipher{T}(key) where {T} = AesEcbCipher(T(key))
end
for key_size in AES_KEY_SIZES
    alias = Symbol("Aes", key_size, "Ecb")
    key_type = Symbol("Aes", key_size, "Key")
    @eval begin
        const $alias = AesEcbCipher{$key_type}
        _get_cipher_type(::Val{$key_size}, ::typeof(ECB)) = $alias
    end
end

function encrypt(ctx::AesEcbCipher, plain::AbstractArray{UInt8})
    key = ctx.key
    n = cld(length(plain), 16)
    b = Vector{UInt8}(undef, n * 16)
    b128 = reinterpret(UInt128, b)
    for i in 1:n-1
        block_i = to_uint128(plain[(i-1)*16+1:i*16])
        b128[i] = encrypt(key, block_i)
    end
    b128[n] = encrypt(key, pad_or_trunc(plain[(n-1)*16+1:end], Val(16))) |> to_uint128
    b
end

function decrypt(ctx::AesEcbCipher, cipher::Vector{UInt8})
    key = ctx.key
    len = length(cipher)
    n = len ÷ 16
    @assert n * 16 == len "Invalid length of cipher text"
    b = Vector{UInt8}(undef, n * 16)
    b128 = reinterpret(UInt128, b)
    for i in 1:n
        block_i = to_uint128(cipher[(i-1)*16+1:i*16])
        b128[i] = decrypt(key, block_i)
    end
    b
end
