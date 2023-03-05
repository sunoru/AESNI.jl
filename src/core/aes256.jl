"""
Assistant function 1 for AES256. Compiled from the C++ source code:

```c
inline void KEY_256_ASSIST_1(__m128i* temp1, __m128i * temp2) {
    __m128i temp4;
    *temp2 = _mm_shuffle_epi32(*temp2, 0xff);
    temp4 = _mm_slli_si128 (*temp1, 0x4);
    *temp1 = _mm_xor_si128 (*temp1, temp4);
    temp4 = _mm_slli_si128 (temp4, 0x4);
    *temp1 = _mm_xor_si128 (*temp1, temp4);
    temp4 = _mm_slli_si128 (temp4, 0x4);
    *temp1 = _mm_xor_si128 (*temp1, temp4);
    *temp1 = _mm_xor_si128 (*temp1, *temp2);
}
```
"""
@inline key_256_assist_1(a::Base.RefValue{__m128i}, b::Base.RefValue{__m128i}) = GC.@preserve a b llvmcall(
    """%ptr0 = inttoptr i64 %0 to <2 x i64>*
    %ptr1 = inttoptr i64 %1 to <2 x i64>*
    %3 = bitcast <2 x i64>* %ptr1 to <4 x i32>*
    %4 = load <4 x i32>, <4 x i32>* %3, align 16
    %5 = shufflevector <4 x i32> %4, <4 x i32> undef, <4 x i32> <i32 3, i32 3, i32 3, i32 3>
    store <4 x i32> %5, <4 x i32>* %3, align 16
    %6 = load <2 x i64>, <2 x i64>* %ptr0, align 16
    %7 = bitcast <2 x i64> %6 to <16 x i8>
    %8 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %7, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
    %9 = bitcast <16 x i8> %8 to <2 x i64>
    %10 = xor <2 x i64> %6, %9
    %11 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %8, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
    %12 = bitcast <16 x i8> %11 to <2 x i64>
    %13 = xor <2 x i64> %10, %12
    %14 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %11, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
    %15 = bitcast <16 x i8> %14 to <2 x i64>
    %16 = xor <2 x i64> %13, %15
    store <2 x i64> %16, <2 x i64>* %ptr0, align 16
    %17 = load <2 x i64>, <2 x i64>* %ptr1, align 16
    %18 = xor <2 x i64> %16, %17
    store <2 x i64> %18, <2 x i64>* %ptr0, align 16
    ret void""",
    Cvoid, Tuple{Ptr{__m128i},Ptr{__m128i}},
    Ptr{__m128i}(pointer_from_objref(a)),
    Ptr{__m128i}(pointer_from_objref(b)),
)
"""
Assistant function 2 for AES256. Compiled from the C++ source code:

```c
inline void KEY_256_ASSIST_2(__m128i* temp1, __m128i * temp3) {
    __m128i temp2, temp4;
    temp4 = _mm_aeskeygenassist_si128(*temp1, 0x0);
    temp2 = _mm_shuffle_epi32(temp4, 0xaa);
    temp4 = _mm_slli_si128(*temp3, 0x4);
    *temp3 = _mm_xor_si128(*temp3, temp4);
    temp4 = _mm_slli_si128(temp4, 0x4);
    *temp3 = _mm_xor_si128(*temp3, temp4);
    temp4 = _mm_slli_si128(temp4, 0x4);
    *temp3 = _mm_xor_si128(*temp3, temp4);
    *temp3 = _mm_xor_si128(*temp3, temp2);
}
```
"""
@inline function key_256_assist_2(a::Base.RefValue{__m128i}, b::Base.RefValue{__m128i})
    c = aes_key_gen_assist(a[], Val(0x0))
    GC.@preserve a b llvmcall(
        """%ptr0 = inttoptr i64 %0 to <2 x i64>*
        %3 = bitcast <2 x i64> %1 to <4 x i32>
        %4 = shufflevector <4 x i32> %3, <4 x i32> undef, <4 x i32> <i32 2, i32 2, i32 2, i32 2>
        %5 = bitcast <4 x i32> %4 to <2 x i64>
        %6 = load <2 x i64>, <2 x i64>* %ptr0, align 16
        %7 = bitcast <2 x i64> %6 to <16 x i8>
        %8 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %7, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
        %9 = bitcast <16 x i8> %8 to <2 x i64>
        %10 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %8, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
        %11 = bitcast <16 x i8> %10 to <2 x i64>
        %12 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %10, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
        %13 = bitcast <16 x i8> %12 to <2 x i64>
        %14 = xor <2 x i64> %6, %5
        %15 = xor <2 x i64> %14, %9
        %16 = xor <2 x i64> %15, %11
        %17 = xor <2 x i64> %16, %13
        store <2 x i64> %17, <2 x i64>* %ptr0, align 16
        ret void""",
        Cvoid, Tuple{Ptr{__m128i},__m128i},
        Ptr{__m128i}(pointer_from_objref(b)),
        c
    )
end

function key_256_expansion(
    temp1::Base.RefValue{__m128i},
    temp2::Base.RefValue{__m128i},
    temp3::Base.RefValue{__m128i},
    R
)
    temp2[] = aes_key_gen_assist(temp3[], R)
    key_256_assist_1(temp1, temp2)
    key1 = temp1[]
    key_256_assist_2(temp1, temp3)
    key2 = temp3[]
    key1, key2
end

struct Aes256EncryptKey <: AbstractAesEncryptKey
    keys::NTuple{15,__m128i}
    Aes256EncryptKey(keys::NTuple{15,__m128i}) = new(keys)
end
Aes256EncryptKey(key1::UInt128, key2::UInt128) = Aes256EncryptKey(
    (from_uint128(Vector{UInt8}, key1)..., from_uint128(Vector{UInt8}, key2)...)
)
function Aes256EncryptKey(key::ByteSequence)
    _ensure_key_size(key, 256)
    key1 = to_uint128(key[1:16]) |> to_m128i
    key2 = to_uint128(key[17:32]) |> to_m128i
    temp1 = Ref(key1)
    temp3 = Ref(key2)
    temp2 = Ref{__m128i}()

    key3, key4 = key_256_expansion(temp1, temp2, temp3, Val(0x1))
    key5, key6 = key_256_expansion(temp1, temp2, temp3, Val(0x2))
    key7, key8 = key_256_expansion(temp1, temp2, temp3, Val(0x4))
    key9, key10 = key_256_expansion(temp1, temp2, temp3, Val(0x8))
    key11, key12 = key_256_expansion(temp1, temp2, temp3, Val(0x10))
    key13, key14 = key_256_expansion(temp1, temp2, temp3, Val(0x20))
    temp2[] = aes_key_gen_assist(temp3[], Val(0x40))
    key_256_assist_1(temp1, temp2)
    key15 = temp1[]
    Aes256EncryptKey((
        key1, key2, key3, key4, key5, key6, key7, key8,
        key9, key10, key11, key12, key13, key14, key15
    ))
end

struct Aes256DecryptKey <: AbstractAesDecryptKey
    keys::NTuple{15,__m128i}
    Aes256DecryptKey(keys::NTuple{15,__m128i}) = new(keys)
end
Aes256DecryptKey(key) = Aes256DecryptKey(Aes256EncryptKey(key))
function Aes256DecryptKey(enc_key::Aes256EncryptKey)
    enc_keys = enc_key.keys
    Aes256DecryptKey((
        enc_keys[15],
        map(aes_imc, enc_keys[14:-1:2])...,
        enc_keys[1]
    ))
end

struct Aes256Key <: AbstractAesKey
    keys::NTuple{28,__m128i}
    Aes256Key(keys::NTuple{28,__m128i}) = new(keys)
end
Aes256Key(key) = Aes256Key(Aes256EncryptKey(key))
function Aes256Key(enc_key::Aes256EncryptKey)
    dec_key = Aes256DecryptKey(enc_key)
    Aes256Key((enc_key.keys..., dec_key.keys[2:14]...))
end

Aes256EncryptKey(k::Aes256Key) = Aes256EncryptKey(k.keys[1:15])
Aes256DecryptKey(k::Aes256Key) = Aes256DecryptKey((k.keys[15:28]..., k.keys[1]))

@inline function aes256_encrypt(input::UInt128, key::NTuple{15,__m128i})
    key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13, key14, key15 = key
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
    x = aes_enc(x, key11)
    x = aes_enc(x, key12)
    x = aes_enc(x, key13)
    x = aes_enc(x, key14)
    aes_enc_last(x, key15) |> to_uint128
end

@inline function aes256_decrypt(input::UInt128, key::NTuple{15,__m128i})
    key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13, key14, key15 = key
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
    x = aes_dec(x, key11)
    x = aes_dec(x, key12)
    x = aes_dec(x, key13)
    x = aes_dec(x, key14)
    aes_dec_last(x, key15) |> to_uint128
end

_get_encrypt_key(key::Aes256Key) = Aes256EncryptKey(key)
_get_decrypt_key(key::Aes256Key) = Aes256DecryptKey(key)
encrypt(key::Aes256EncryptKey, input::UInt128) = aes256_encrypt(input, Tuple(key))
decrypt(key::Aes256DecryptKey, input::UInt128) = aes256_decrypt(input, Tuple(key))
