abstract type AbstractAesKey end
abstract type AbstractAesEncryptKey <: AbstractAesKey end
abstract type AbstractAesDecryptKey <: AbstractAesKey end

Base.show(io::IO, key::AbstractAesKey) = print(io, typeof(key), "(", map(to_uint128, key.keys), ")")

Base.Tuple(key::AbstractAesKey) = key.keys
