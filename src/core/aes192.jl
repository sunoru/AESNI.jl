"""
Assistant function for AES192. Compiled from the C++ source code:

```c
void key_192_assist(__m128i* temp1, __m128i * temp2, __m128i * temp3) {
    __m128i temp4;
    *temp2 = _mm_shuffle_epi32 (*temp2, 0x55);
    temp4 = _mm_slli_si128 (*temp1, 0x4);
    *temp1 = _mm_xor_si128 (*temp1, temp4);
    temp4 = _mm_slli_si128 (temp4, 0x4);
    *temp1 = _mm_xor_si128 (*temp1, temp4);
    temp4 = _mm_slli_si128 (temp4, 0x4);
    *temp1 = _mm_xor_si128 (*temp1, temp4);
    *temp1 = _mm_xor_si128 (*temp1, *temp2);
    *temp2 = _mm_shuffle_epi32(*temp1, 0xff);
    temp4 = _mm_slli_si128 (*temp3, 0x4);
    *temp3 = _mm_xor_si128 (*temp3, temp4);
    *temp3 = _mm_xor_si128 (*temp3, *temp2);
}
```
"""
@inline key_192_assist(a::Base.RefValue{__m128i}, b::Base.RefValue{__m128i}, c::Base.RefValue{__m128i}) = GC.@preserve a b c llvmcall(
    """%ptr0 = inttoptr i64 %0 to <2 x i64>*
    %ptr1 = inttoptr i64 %1 to <2 x i64>*
    %ptr2 = inttoptr i64 %2 to <2 x i64>*
    %4 = bitcast <2 x i64>* %ptr1 to <4 x i32>*
    %5 = load <4 x i32>, <4 x i32>* %4, align 16
    %6 = shufflevector <4 x i32> %5, <4 x i32> undef, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
    store <4 x i32> %6, <4 x i32>* %4, align 16
    %7 = load <2 x i64>, <2 x i64>* %ptr0, align 16
    %8 = bitcast <2 x i64> %7 to <16 x i8>
    %9 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %8, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
    %10 = bitcast <16 x i8> %9 to <2 x i64>
    %11 = xor <2 x i64> %7, %10
    %12 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %9, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
    %13 = bitcast <16 x i8> %12 to <2 x i64>
    %14 = xor <2 x i64> %11, %13
    %15 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %12, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
    %16 = bitcast <16 x i8> %15 to <2 x i64>
    %17 = xor <2 x i64> %14, %16
    store <2 x i64> %17, <2 x i64>* %ptr0, align 16
    %18 = load <2 x i64>, <2 x i64>* %ptr1, align 16
    %19 = xor <2 x i64> %17, %18
    store <2 x i64> %19, <2 x i64>* %ptr0, align 16
    %20 = bitcast <2 x i64> %19 to <4 x i32>
    %21 = shufflevector <4 x i32> %20, <4 x i32> undef, <4 x i32> <i32 3, i32 3, i32 3, i32 3>
    store <4 x i32> %21, <4 x i32>* %4, align 16
    %22 = load <2 x i64>, <2 x i64>* %ptr2, align 16
    %23 = bitcast <2 x i64> %22 to <16 x i8>
    %24 = shufflevector <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0>, <16 x i8> %23, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
    %25 = bitcast <16 x i8> %24 to <2 x i64>
    %26 = xor <2 x i64> %22, %25
    store <2 x i64> %26, <2 x i64>* %ptr2, align 16
    %27 = load <2 x i64>, <2 x i64>* %ptr1, align 16
    %28 = xor <2 x i64> %26, %27
    store <2 x i64> %28, <2 x i64>* %ptr2, align 16
    ret void""",
    Cvoid, Tuple{Ptr{__m128i},Ptr{__m128i},Ptr{__m128i}},
    Ptr{__m128i}(pointer_from_objref(a)),
    Ptr{__m128i}(pointer_from_objref(b)),
    Ptr{__m128i}(pointer_from_objref(c)),
)

for imm = 0x0:0x1
    ircode = """%3 = shufflevector <2 x i64> %0, <2 x i64> %1, <2 x i32> <i32 $imm, i32 2>
        ret <2 x i64> %3"""
    @eval _shuffle_pd(a::__m128i, b::__m128i, ::Val{$imm}) = llvmcall(
        $ircode,
        __m128i, Tuple{__m128i,__m128i},
        a, b
    )
end

struct Aes192EncryptKey <: AbstractAesEncryptKey
    keys::NTuple{13,__m128i}
    Aes192EncryptKey(keys::NTuple{13,__m128i}) = new(keys)
end
function Aes192EncryptKey(key::ByteSequence)
    _ensure_key_size(key, 192)
    key1 = bytes_to_uint128(key[1:16]) |> to_m128i
    key2 = bytes_to_uint128([key[17:24]..., 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]) |> to_m128i
    temp1 = Ref(key1)
    temp3 = Ref(key2)

    temp2 = Ref(aes_key_gen_assist(temp3[], Val(0x1)))
    key_192_assist(temp1, temp2, temp3)
    key2 = _shuffle_pd(key2, temp1[], Val(0x0))
    key3 = _shuffle_pd(temp1[], temp3[], Val(0x1))

    temp2[] = aes_key_gen_assist(temp3[], Val(0x2))
    key_192_assist(temp1, temp2, temp3)
    key4 = temp1[]
    key5 = temp3[]

    temp2[] = aes_key_gen_assist(temp3[], Val(0x4))
    key_192_assist(temp1, temp2, temp3)
    key5 = _shuffle_pd(key5, temp1[], Val(0x0))
    key6 = _shuffle_pd(temp1[], temp3[], Val(0x1))

    temp2[] = aes_key_gen_assist(temp3[], Val(0x8))
    key_192_assist(temp1, temp2, temp3)
    key7 = temp1[]
    key8 = temp3[]

    temp2[] = aes_key_gen_assist(temp3[], Val(0x10))
    key_192_assist(temp1, temp2, temp3)
    key8 = _shuffle_pd(key8, temp1[], Val(0x0))
    key9 = _shuffle_pd(temp1[], temp3[], Val(0x1))

    temp2[] = aes_key_gen_assist(temp3[], Val(0x20))
    key_192_assist(temp1, temp2, temp3)
    key10 = temp1[]
    key11 = temp3[]

    temp2[] = aes_key_gen_assist(temp3[], Val(0x40))
    key_192_assist(temp1, temp2, temp3)
    key11 = _shuffle_pd(key11, temp1[], Val(0x0))
    key12 = _shuffle_pd(temp1[], temp3[], Val(0x1))

    temp2[] = aes_key_gen_assist(temp3[], Val(0x80))
    key_192_assist(temp1, temp2, temp3)
    key13 = temp1[]

    Aes192EncryptKey((key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13))
end

struct Aes192DecryptKey <: AbstractAesDecryptKey
    keys::NTuple{13,__m128i}
    Aes192DecryptKey(keys::NTuple{13,__m128i}) = new(keys)
end
Aes192DecryptKey(key) = Aes192DecryptKey(Aes192EncryptKey(key))
function Aes192DecryptKey(enc_key::Aes192EncryptKey)
    enc_keys = enc_key.keys
    Aes192DecryptKey((
        enc_keys[13],
        map(aes_imc, enc_keys[12:-1:2])...,
        enc_keys[1]
    ))
end

struct Aes192Key <: AbstractAesKey
    enc::Aes192EncryptKey
    dec::Aes192DecryptKey
    Aes192Key(enc::Aes192EncryptKey, dec::Aes192DecryptKey=Aes192DecryptKey(enc)) = new(enc, dec)
end
Aes192Key(key) = Aes192Key(Aes192EncryptKey(key))

Aes192EncryptKey(k::Aes192Key) = k.enc
Aes192DecryptKey(k::Aes192Key) = k.dec

@inline function aes192_encrypt(input::UInt128, key::NTuple{13,__m128i})
    key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13 = key
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
    aes_enc_last(x, key13) |> to_uint128
end

@inline function aes192_decrypt(input::UInt128, key::NTuple{13,__m128i})
    key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13 = key
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
    aes_dec_last(x, key13) |> to_uint128
end

_get_encrypt_key(key::Aes192Key) = Aes192EncryptKey(key)
_get_decrypt_key(key::Aes192Key) = Aes192DecryptKey(key)
encrypt(key::Aes192EncryptKey, input::UInt128) = aes192_encrypt(input, Tuple(key))
decrypt(key::Aes192DecryptKey, input::UInt128) = aes192_decrypt(input, Tuple(key))
