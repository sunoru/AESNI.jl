abstract type AbstractAesKey end
abstract type AbstractAesEncryptKey <: AbstractAesKey end
abstract type AbstractAesDecryptKey <: AbstractAesKey end

Base.show(io::IO, key::AbstractAesKey) = print(io, typeof(key), "(", map(to_uint128, key.keys), ")")

Base.Tuple(key::AbstractAesKey) = key.keys

const AES_KEY_SIZES = (128, 192, 256)

encrypt(key::AbstractAesKey, block::AesByteBlock) = encrypt(_get_encrypt_key(key), block)
decrypt(key::AbstractAesKey, block::AesByteBlock) = decrypt(_get_decrypt_key(key), block)

encrypt(key::AbstractAesKey, a::UInt128) = encrypt(key, to_bytes(a)) |> to_uint128
decrypt(key::AbstractAesKey, a::UInt128) = decrypt(key, to_bytes(a)) |> to_uint128
