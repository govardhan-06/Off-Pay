# Kyber C-Library Setup

- Kyber768 in use

Follow these steps to build the `.dll` library for kyber encryption.

1. `cd kyber`
2. To build the library `.dll` : `gcc -shared -o libpqcrystals_kyber768_ref.dll cbd.c fips202.c indcpa.c kem.c ntt.c poly.c polyvec.c randombytes.c reduce.c symmetric-shake.c verify.c -I. -D EXPORTS -Wall`
3. To build the test_lib.c file: `gcc -o test_lib.exe test_lib.c -L. -lpqcrystals_kyber768_ref -Wall`
4. Run the test_lib : `test_lib.exe`

Follow these steps to build the `.so` library for kyber encryption.

1. `cd kyber`
2. Recompile the source files with `-fPIC`: \
   `gcc -c -fPIC cbd.c fips202.c indcpa.c kem.c ntt.c poly.c polyvec.c randombytes.c reduce.c symmetric-shake.c verify.c`
3. To build the `.so` file: \
   `gcc -shared -o libpqcrystals_kyber768_ref.so cbd.o fips202.o indcpa.o kem.o ntt.o poly.o polyvec.o randombytes.o reduce.o symmetric-shake.o verify.o -I. -D EXPORTS -Wall`

Follow these steps to build the `.so` library for kyber encryption with Android Support

Before that copy files to windows system to WSL native system

`cp -r /mnt/f/Android/android-ndk-r27c-linux ~/android-ndk-r27c-linux`

1. **Navigate to the Kyber Source Directory**:

   ```bash
   cd kyber
   ```

2. **Set Up NDK Environment Variables** (Replace `<ndk-path>` with your NDK location):

   ```bash
   export NDK=<ndk-path>
   export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
   export TARGET=aarch64-linux-android
   export API=21  # Minimum Android API level
   export CC=$TOOLCHAIN/bin/${TARGET}${API}-clang
   ```

   - **`aarch64-linux-android`** is for **ARM64-v8a** architecture.
   - **`API=21`** ensures backward compatibility with Android 5.0+.

3. **Recompile the Source Files with `-fPIC`**:
   Use the NDK Clang compiler (`$CC`) instead of `gcc`:

   ```bash
   $CC -c -fPIC cbd.c fips202.c indcpa.c kem.c ntt.c poly.c polyvec.c randombytes.c reduce.c symmetric-shake.c verify.c -I.
   ```

4. **Build the Shared Library (`.so` file)**:
   Link the compiled object files into a shared library using `$CC`:
   ```bash
   $CC -shared -o libpqcrystals_kyber768_ref.so cbd.o fips202.o indcpa.o kem.o ntt.o poly.o polyvec.o randombytes.o reduce.o symmetric-shake.o verify.o -I. -D EXPORTS -Wall
   ```
