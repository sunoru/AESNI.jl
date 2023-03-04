macro bytes_str(s)
    :($s |> split |> join |> hex2bytes)
end

function test_cipher(type, key, plain, cipher = nothing)
    key = type(key)
    encrypted = encrypt(key, plain)
    cipher = if isnothing(cipher)
        encrypted
    else
        @test encrypted == cipher
        cipher
    end
    @test decrypt(key, cipher) == plain
end