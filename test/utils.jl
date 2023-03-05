macro bytes_str(s)
    :($s |> split |> join |> hex2bytes)
end

macro test_cipher(type, key, plain, cipher=nothing)
    quote
        key = $(esc(type))($(esc(key)))
        plain = $(esc(plain))
        cipher = $(esc(cipher))
        encrypted = encrypt(key, plain)
        cipher = if isnothing(cipher)
            encrypted
        else
            @test encrypted == cipher
            cipher
        end
        @test decrypt(key, cipher) == plain
    end
end