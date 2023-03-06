abstract type AbstractAesKey end
abstract type AbstractAesEncryptKey <: AbstractAesKey end
abstract type AbstractAesDecryptKey <: AbstractAesKey end

Base.show(io::IO, key::AbstractAesKey) = print(io, typeof(key), "(", map(to_uint128, key.keys), ")")

@inline Base.Tuple(key::AbstractAesKey) = key.keys

const AES_KEY_SIZES = (128, 192, 256)

encrypt(key::AbstractAesKey, block::UInt128) = encrypt(_get_encrypt_key(key), block)
decrypt(key::AbstractAesKey, block::UInt128) = decrypt(_get_decrypt_key(key), block)

encrypt(key::AbstractAesKey, a::T) where {T} = from_uint128(T, encrypt(key, bytes_to_uint128(a)))
decrypt(key::AbstractAesKey, a::T) where {T} = from_uint128(T, decrypt(key, bytes_to_uint128(a)))

_ensure_key_size(bytes::ByteSequence, key_size) =
    @assert length(bytes) == key_size ÷ 8 "Key must be $key_size bits"
