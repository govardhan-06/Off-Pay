## Falcon library build

1. `gcc -Wall -Wextra -Wshadow -Wundef -O3 -c randombytes.c -o randombytes.o `
2. Do this repeatedly all the neccessary object files are created.
3. `gcc -shared -o libfalcon.dll codec.o common.o falcon.o fft.o fpr.o keygen.o rng.o shake.o sign.o vrfy.o fmain.o randombytes.o`
4. This is will create the `libflacon.dll` library file

To build `.so` file:

gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c randombytes.c -o randombytes.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c codec.c -o codec.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c common.c -o common.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c falcon.c -o falcon.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c fft.c -o fft.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c fmain.c -o fmain.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c fpr.c -o fpr.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c keygen.c -o keygen.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c rng.c -o rng.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c shake.c -o shake.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c sign.c -o sign.o
gcc -Wall -Wextra -Wshadow -Wundef -O3 -fPIC -c vrfy.c -o vrfy.o

gcc -Wall -Wextra -Wshadow -Wundef -O3 -c _.c -o _.o

gcc -shared -o libfalcon.so codec.o common.o falcon.o fft.o fpr.o keygen.o rng.o shake.o sign.o vrfy.o fmain.o randombytes.o

To build `.so` file with Android Support:
