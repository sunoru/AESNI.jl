abstract type AbstractAesKey end
abstract type AbstractAesEncryptKey <: AbstractAesKey end
abstract type AbstractAesDecryptKey <: AbstractAesKey end

Base.show(io::IO, key::AbstractAesKey) = print(io, typeof(key), "(", map(to_uint128, key.keys), ")")

Base.Tuple(key::AbstractAesKey) = key.keys

encrypt(key::AbstractAesKey, a::AesUInt8Block) = encrypt(key, to_uint128(a)) |> to_bytes
decrypt(key::AbstractAesKey, a::AesUInt8Block) = decrypt(key, to_uint128(a)) |> to_bytes

const AES_KEY_SIZES = (128, 192, 256)
