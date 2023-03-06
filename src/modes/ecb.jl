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

function encrypt!(ctx::AesEcbCipher, cipher::AbstractVector{UInt8}, plain::AbstractVector{UInt8})
    len = length(plain)
    @assert length(cipher) >= len "Output buffer is too small"
    n = len ÷ 16
    @assert n * 16 == len "Invalid length of plain text (must be padded to 16n bytes)"
    key = ctx.key
    plain128 = reinterpret(UInt128, plain)
    b128 = reinterpret(UInt128, cipher)
    @inbounds for i in 1:n
        b128[i] = encrypt(key, plain128[i])
    end
    cipher
end

function decrypt!(ctx::AesEcbCipher, plain::AbstractVector{UInt8}, cipher::AbstractVector{UInt8})
    len = length(cipher)
    @assert length(plain) >= len "Output buffer is too small"
    n = len ÷ 16
    @assert n * 16 == len "Invalid length of cipher text"
    key = ctx.key
    cipher128 = reinterpret(UInt128, cipher)
    b128 = reinterpret(UInt128, plain)
    @inbounds for i in 1:n
        b128[i] = decrypt(key, cipher128[i])
    end
    plain
end

encrypt(ctx::AesEcbCipher, plain::AbstractVector{UInt8}) = encrypt!(ctx, similar(plain), plain)
decrypt(ctx::AesEcbCipher, cipher::AbstractVector{UInt8}) = decrypt!(ctx, similar(cipher), cipher)