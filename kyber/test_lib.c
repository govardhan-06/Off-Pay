#include <stdio.h>
#include <windows.h> // for dynamic linking in Windows
#include "kem.h"     // include header files relevant to your functions
#include "randombytes.h"

#define NTESTS 5

// Define function pointers
typedef void (*pqcrystals_kyber768_ref_keypair_func)(unsigned char *, unsigned char *);
typedef void (*pqcrystals_kyber768_ref_enc_func)(unsigned char *, unsigned char *, const unsigned char *);
typedef void (*pqcrystals_kyber768_ref_dec_func)(unsigned char *, const unsigned char *, const unsigned char *);

void print_hex(const unsigned char *data, size_t len)
{
    for (size_t i = 0; i < len; i++)
    {
        printf("%02x", data[i]);
    }
    printf("\n");
}

int main()
{
    // Load the shared library (DLL)
    HINSTANCE hinstLib = LoadLibrary(TEXT("libpqcrystals_kyber768_ref.dll"));
    if (hinstLib == NULL)
    {
        fprintf(stderr, "Error loading library: %ld\n", GetLastError());
        return 1;
    }

    // Map function pointers to library functions
    pqcrystals_kyber768_ref_keypair_func pqcrystals_kyber768_ref_keypair = (pqcrystals_kyber768_ref_keypair_func)GetProcAddress(hinstLib, "pqcrystals_kyber768_ref_keypair");
    pqcrystals_kyber768_ref_enc_func pqcrystals_kyber768_ref_enc = (pqcrystals_kyber768_ref_enc_func)GetProcAddress(hinstLib, "pqcrystals_kyber768_ref_enc");
    pqcrystals_kyber768_ref_dec_func pqcrystals_kyber768_ref_dec = (pqcrystals_kyber768_ref_dec_func)GetProcAddress(hinstLib, "pqcrystals_kyber768_ref_dec");

    if (pqcrystals_kyber768_ref_keypair == NULL || pqcrystals_kyber768_ref_enc == NULL || pqcrystals_kyber768_ref_dec == NULL)
    {
        fprintf(stderr, "Error finding functions: %ld\n", GetLastError());
        FreeLibrary(hinstLib);
        return 1;
    }

    // Test functions
    unsigned int i;
    for (i = 0; i < NTESTS; i++)
    {
        unsigned char pk[CRYPTO_PUBLICKEYBYTES];
        unsigned char sk[CRYPTO_SECRETKEYBYTES];
        unsigned char ct[CRYPTO_CIPHERTEXTBYTES];
        unsigned char key_a[CRYPTO_BYTES];
        unsigned char key_b[CRYPTO_BYTES];

        // Generate keypair
        pqcrystals_kyber768_ref_keypair(pk, sk);

        // Print public key, secret key
        printf("Test %d\n", i + 1);
        printf("Public Key: ");
        print_hex(pk, CRYPTO_PUBLICKEYBYTES);
        printf("Secret Key: ");
        print_hex(sk, CRYPTO_SECRETKEYBYTES);

        // Encrypt to derive Bob's shared key and ciphertext
        pqcrystals_kyber768_ref_enc(ct, key_b, pk);
        printf("Ciphertext: ");
        print_hex(ct, CRYPTO_CIPHERTEXTBYTES);
        printf("Bob's Shared Key: ");
        print_hex(key_b, CRYPTO_BYTES);

        // Decrypt to derive Alice's shared key
        pqcrystals_kyber768_ref_dec(key_a, ct, sk);
        printf("Alice's Shared Key: ");
        print_hex(key_a, CRYPTO_BYTES);

        // Check if the shared keys match
        if (memcmp(key_a, key_b, CRYPTO_BYTES) != 0)
        {
            printf("ERROR: Keys do not match\n");
            FreeLibrary(hinstLib);
            return 1;
        }

        // Print success for the current test
        printf("Test %d passed successfully.\n\n", i + 1);
    }

    // Print success message
    printf("All tests passed successfully.\n");

    // Free the library
    FreeLibrary(hinstLib);

    return 0;
}
