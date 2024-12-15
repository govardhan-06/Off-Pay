## JNI file setup

### Steps:

To build the `.dll` file: \

1. Write the JNI java code and then run `javac -h . OffPay.java` to create both header and class files
2. Then, include this header file in the JNI code written in c
3. While doing this make sure the functions is in this format:
   `JNIEXPORT void JNICALL Java_OffPay_generateKeypair(JNIEnv *env, jobject obj, jbyteArray publicKey, jbyteArray secretKey) {
    // Your key generation logic
}`
4. Run this command:\
   `gcc -shared -o OffPayJNI.dll -I"D:\Java\jdk-23\include" -I"D:\Java\jdk-23\include\win32" offpayJNI.c -L. -lpqcrystals_kyber768_ref`
5. Make sure that you are loading the correct library **(OffPayJNI)** inside the java JNI code file.
6. Run : `javac OffPay.java`
7. Run : `java -Djava.library.path=. OffPay`

#### Note: If running into any errors related to function names declared differently in library and JNI, use this command: `dumpbin /exports F:/OffPay/kyber/OffPayJNI.dll`

To build the `.so` file: \

1. Write the JNI java code and then run `javac -h . OffPay.java` to create both header and class files
2. Then, include this header file in the JNI code written in c
3. While doing this make sure the functions is in this format:
   `JNIEXPORT void JNICALL Java_OffPay_generateKeypair(JNIEnv *env, jobject obj, jbyteArray publicKey, jbyteArray secretKey) {
    // Your key generation logic
}`
4. Run this command:\
   `gcc -shared -o OffPayJNI.dll -I"/usr/lib/jvm/java-17-openjdk-amd64/include" -I"/usr/lib/jvm/java-17-openjdk-amd64/include/linux" offpayJNI.c -L. -lpqcrystals_kyber768_ref`
5. Make sure that you are loading the correct library **(OffPayJNI)** inside the java JNI code file.
6. Run : `javac OffPay.java`
7. Run : `java -Djava.library.path=. OffPay`

#### Note: If running into any errors related to function names declared differently in library and JNI, use this command: `nm -D OffPayJNI.so`
