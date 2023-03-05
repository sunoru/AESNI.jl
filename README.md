# AESNI.jl

[![CI](https://github.com/sunoru/AESNI.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/sunoru/AESNI.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/github/sunoru/AESNI.jl/branch/main/graph/badge.svg)](https://app.codecov.io/github/sunoru/AESNI.jl)

AES in Julia through the AES-NI instruction set.

Only the most basic block cipher mode (ECB) is implemented for now.

## Usage

```julia
julia> using AESNI

# Create a AES-128 key with a 128-bit user key.
julia> key = Aes128Key(0x71a696a4f5efba2bc57e0674786f126e);
julia> plain = 0x3b2f6d60c0187a407fe1feb79f64596c;

# Encrypt a 128-bit block.
julia> cipher = encrypt(key, plain)
0x4140d9613dc8e09880a4b9213606d56e

julia> decrypt(key, cipher) == plain
true

# You can also use `AesCipher` to create a context.
julia> ctx = AesCipher(128, ECB, key);
# It's equivalent to
julia> ctx = Aes128Ecb(key);

# And a context can encrypt/decrypt array of bytes.
julia> cipher = encrypt(ctx, codeunits("Hello, world!"));
julia> println(cipher)
UInt8[0x16, 0x15, 0x1b, 0xa8, 0x3e, 0x14, 0xc6, 0x0e, 0x14, 0x1a, 0xa8, 0x00, 0x8a, 0x9a, 0x05, 0xf8]

julia> decrypt(ctx, cipher) |> String |> println
Hello, world!
```

You can also use `Aes192*` and `Aes256*` for AES-192 and AES-256 respectively.

## Contributing

Contributions are welcome! Please open an issue or a pull request. See [#1](https://github.com/sunoru/AESNI.jl/issues/1) for a list of things to do.

## License

[The MIT License](./LICENSE).
