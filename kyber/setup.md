# Kyber C-Library Setup

- Kyber768 in use

Follow these steps to build the `.dll` library for kyber encryption.

1. `cd kyber`
2. To build the library `.dll` : `gcc -shared -o libpqcrystals_kyber768_ref.dll cbd.c fips202.c indcpa.c kem.c ntt.c poly.c polyvec.c randombytes.c reduce.c symmetric-shake.c verify.c -I. -D EXPORTS -Wall`
3. To build the test_lib.c file: `gcc -o test_lib.exe test_lib.c -L. -lpqcrystals_kyber768_ref -Wall`
4. Run the test_lib : `test_lib.exe`
