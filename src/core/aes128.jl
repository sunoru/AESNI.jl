"""
Assistant function for AES128. Compiled from the C++ source code:

```c
__m128i AES_128_ASSIST(__m128i temp1, __m128i temp2) {
    __m128i temp3;
    temp2 = _mm_shuffle_epi32 (temp2 ,0xff);
    temp3 = _mm_slli_si128 (temp1, 0x4);
    temp1 = _mm_xor_si128 (temp1, temp3);
    temp3 = _mm_slli_si128 (temp3, 0x4);
    temp1 = _mm_xor_si128 (temp1, temp3);
    temp3 = _mm_slli_si128 (temp3, 0x4);
    temp1 = _mm_xor_si128 (temp1, temp3);
    temp1 = _mm_xor_si128 (temp1, temp2);
    return temp1;
}
```
"""
@inline aes_128_assist(a::__m128i, b::__m128i) = llvmcall(
    """%3 = bitcast <2 x i64> %1 to <4 x i32>
    %4 = shufflevector <4 x i32> %3, <4 x i32> undef, <4 x i32> <i32 3, i32 3, i32 3, i32 3>
    %5 = bitcast <4 x i32> %4 to <2 x i64>
    %6 = bitcast <2 x i64> %0 to <16 x i8>
    %7 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %6, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
    %8 = bitcast <16 x i8> %7 to <2 x i64>
    %9 = xor <2 x i64> %8, %0
    %10 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %7, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
    %11 = bitcast <16 x i8> %10 to <2 x i64>
    %12 = xor <2 x i64> %9, %11
    %13 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %10, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
    %14 = bitcast <16 x i8> %13 to <2 x i64>
    %15 = xor <2 x i64> %12, %5
    %16 = xor <2 x i64> %15, %14
    ret <2 x i64> %16""",
    __m128i, Tuple{__m128i,__m128i},
    a, b
)

struct Aes128EncryptKey <: AbstractAesEncryptKey
    keys::NTuple{11,__m128i}
    Aes128EncryptKey(keys::NTuple{11,__m128i}) = new(keys)
end
Aes128EncryptKey(key::UInt128) = Aes128EncryptKey(from_uint128(Vector{UInt8}, key))
function Aes128EncryptKey(key::ByteSequence)
    _ensure_key_size(key, 128)
    key1 = bytes_to_uint128(key) |> to_m128i
    key2 = aes_128_assist(key1, aes_key_gen_assist(key1, Val(0x1)))
    key3 = aes_128_assist(key2, aes_key_gen_assist(key2, Val(0x2)))
    key4 = aes_128_assist(key3, aes_key_gen_assist(key3, Val(0x4)))
    key5 = aes_128_assist(key4, aes_key_gen_assist(key4, Val(0x8)))
    key6 = aes_128_assist(key5, aes_key_gen_assist(key5, Val(0x10)))
    key7 = aes_128_assist(key6, aes_key_gen_assist(key6, Val(0x20)))
    key8 = aes_128_assist(key7, aes_key_gen_assist(key7, Val(0x40)))
    key9 = aes_128_assist(key8, aes_key_gen_assist(key8, Val(0x80)))
    key10 = aes_128_assist(key9, aes_key_gen_assist(key9, Val(0x1b)))
    key11 = aes_128_assist(key10, aes_key_gen_assist(key10, Val(0x36)))
    Aes128EncryptKey((key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11))
end

struct Aes128DecryptKey <: AbstractAesDecryptKey
    keys::NTuple{11,__m128i}
    Aes128DecryptKey(keys::NTuple{11,__m128i}) = new(keys)
end
Aes128DecryptKey(key) = Aes128DecryptKey(Aes128EncryptKey(key))
function Aes128DecryptKey(enc_key::Aes128EncryptKey)
    enc_keys = enc_key.keys
    Aes128DecryptKey((
        enc_keys[11],
        map(aes_imc, enc_keys[10:-1:2])...,
        enc_keys[1]
    ))
end

struct Aes128Key <: AbstractAesKey
    enc::Aes128EncryptKey
    dec::Aes128DecryptKey
    Aes128Key(enc::Aes128EncryptKey, dec::Aes128DecryptKey=Aes128DecryptKey(enc)) = new(enc, dec)
end
Aes128Key(key) = Aes128Key(Aes128EncryptKey(key))

Aes128EncryptKey(k::Aes128Key) = k.enc
Aes128DecryptKey(k::Aes128Key) = k.dec

@inline function aes128_encrypt(input::UInt128, key::NTuple{11,__m128i})
    key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11 = key
    x = _xor(to_m128i(input), key1)
    x = aes_enc(x, key2)
    x = aes_enc(x, key3)
    x = aes_enc(x, key4)
    x = aes_enc(x, key5)
    x = aes_enc(x, key6)
    x = aes_enc(x, key7)
    x = aes_enc(x, key8)
    x = aes_enc(x, key9)
    x = aes_enc(x, key10)
    aes_enc_last(x, key11) |> to_uint128
end

@inline function aes128_decrypt(input::UInt128, key::NTuple{11,__m128i})
    key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11 = key
    x = _xor(to_m128i(input), key1)
    x = aes_dec(x, key2)
    x = aes_dec(x, key3)
    x = aes_dec(x, key4)
    x = aes_dec(x, key5)
    x = aes_dec(x, key6)
    x = aes_dec(x, key7)
    x = aes_dec(x, key8)
    x = aes_dec(x, key9)
    x = aes_dec(x, key10)
    aes_dec_last(x, key11) |> to_uint128
end

_get_encrypt_key(key::Aes128Key) = Aes128EncryptKey(key)
_get_decrypt_key(key::Aes128Key) = Aes128DecryptKey(key)
encrypt(key::Aes128EncryptKey, input::UInt128) = aes128_encrypt(input, Tuple(key))
decrypt(key::Aes128DecryptKey, input::UInt128) = aes128_decrypt(input, Tuple(key))
