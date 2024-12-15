## Falcon library build

1. `gcc -Wall -Wextra -Wshadow -Wundef -O3 -c randombytes.c -o randombytes.o `
2. Do this repeatedly all the neccessary object files are created.
3. `gcc -shared -o libfalcon.dll codec.o common.o falcon.o fft.o fpr.o keygen.o rng.o shake.o sign.o vrfy.o fmain.o randombytes.o`
4. This is will create the `libflacon.dll` library file
