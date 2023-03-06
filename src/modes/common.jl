@data AesMode begin
    ECB
    CBC
    CFB
    OFB
    CTR
end
_get_cipher_type(_, ::AesMode) = error("Not implemented")

abstract type AbstractAesCipher{TMode<:AesMode} end
aes_mode(::AbstractAesCipher{TMode}) where {TMode} = TMode()
function AesCipher(key_size, mode::AesMode, key; kwargs...)
    @assert key_size in AES_KEY_SIZES "key_size must be one of $(AES_KEY_SIZES)"
    _get_cipher_type(Val(key_size), mode)(key; kwargs...)
end
encrypt!(key_size::Integer, mode::AesMode, key, output::AbstractVector{UInt8}, plain; kwargs...) = encrypt!(AesCipher(key_size, mode, key; kwargs...), output, plain)
decrypt!(key_size::Integer, mode::AesMode, key, output::AbstractVector{UInt8}, cipher; kwargs...) = decrypt!(AesCipher(key_size, mode, key; kwargs...), output, cipher)

encrypt(key_size::Integer, mode::AesMode, key, plain; kwargs...) = encrypt(AesCipher(key_size, mode, key; kwargs...), plain)
decrypt(key_size::Integer, mode::AesMode, key, cipher; kwargs...) = decrypt(AesCipher(key_size, mode, key; kwargs...), cipher)
