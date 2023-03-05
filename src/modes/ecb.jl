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
    n = cld(len, 16)
    b = Vector{UInt8}(undef, n * 16)
    b128 = reinterpret(UInt128, b)
    plain128 = reinterpret(UInt128, @view plain[1:n*16])
    @inbounds begin
        for i in 1:n-1
            block_i = plain128[i]
            b128[i] = encrypt(key, block_i)
        end
        block_n = to_uint128([plain[(n-1)*16+1:end]..., Iterators.repeated(0x00, n * 16 - len)...])
        b128[n] = encrypt(key, block_n)
    end
    b
end

function decrypt(ctx::AesEcbCipher, cipher::AbstractArray{UInt8})
    key = ctx.key
    len = length(cipher)
    n = len ÷ 16
    @assert n * 16 == len "Invalid length of cipher text"
    b = Vector{UInt8}(undef, n * 16)
    b128 = reinterpret(UInt128, b)
    cipher128 = reinterpret(UInt128, cipher)
    @inbounds for i in 1:n
        b128[i] = decrypt(key, cipher128[i])
    end
    b
end
