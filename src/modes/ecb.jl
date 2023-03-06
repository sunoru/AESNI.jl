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
    len = length(plain)
    n = len ÷ 16
    @assert n * 16 == len "Invalid length of plain text (must be padded to 16n bytes)"
    plain128 = reinterpret(UInt128, plain)
    b = Vector{UInt8}(undef, len)
    b128 = reinterpret(UInt128, b)
    @inbounds for i in 1:n
        b128[i] = encrypt(key, plain128[i])
    end
    b
end

function decrypt(ctx::AesEcbCipher, cipher::AbstractArray{UInt8})
    key = ctx.key
    len = length(cipher)
    n = len ÷ 16
    @assert n * 16 == len "Invalid length of cipher text"
    cipher128 = reinterpret(UInt128, cipher)
    b = Vector{UInt8}(undef, n * 16)
    b128 = reinterpret(UInt128, b)
    @inbounds for i in 1:n
        b128[i] = decrypt(key, cipher128[i])
    end
    b
end
