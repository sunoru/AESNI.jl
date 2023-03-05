abstract type AbstractAesKey end
abstract type AbstractAesEncryptKey <: AbstractAesKey end
abstract type AbstractAesDecryptKey <: AbstractAesKey end

Base.show(io::IO, key::AbstractAesKey) = print(io, typeof(key), "(", map(to_uint128, key.keys), ")")

Base.Tuple(key::AbstractAesKey) = key.keys

const AES_KEY_SIZES = (128, 192, 256)

encrypt(key::AbstractAesKey, block::AesByteBlock) = encrypt(_get_encrypt_key(key), block)
decrypt(key::AbstractAesKey, block::AesByteBlock) = decrypt(_get_decrypt_key(key), block)

encrypt(key::AbstractAesKey, a::T) where {T} = from_byte_block(T, encrypt(key, to_byte_block(a)))
decrypt(key::AbstractAesKey, a::T) where {T} = from_byte_block(T, decrypt(key, to_byte_block(a)))

_ensure_key_size(bytes::ByteSequence, key_size) =
    @assert length(bytes) == key_size ÷ 8 "Key must be $key_size bits"
