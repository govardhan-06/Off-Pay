#include <jni.h>
#include <stdio.h>
#include "OffPay.h"
#include "kem.h"
#include "randombytes.h"

// JNI function to generate keypair
JNIEXPORT void JNICALL Java_Kyber768Ref_generateKeypair(JNIEnv *env, jobject obj, jbyteArray publicKey, jbyteArray secretKey)
{
    unsigned char pk[CRYPTO_PUBLICKEYBYTES];
    unsigned char sk[CRYPTO_SECRETKEYBYTES];
    pqcrystals_kyber768_ref_keypair(pk, sk);

    // Copy the result to Java byte arrays
    (*env)->SetByteArrayRegion(env, publicKey, 0, CRYPTO_PUBLICKEYBYTES, (jbyte *)pk);
    (*env)->SetByteArrayRegion(env, secretKey, 0, CRYPTO_SECRETKEYBYTES, (jbyte *)sk);
}

// JNI function to encrypt
JNIEXPORT void JNICALL Java_Kyber768Ref_encrypt(JNIEnv *env, jobject obj, jbyteArray ciphertext, jbyteArray sharedKey, jbyteArray publicKey)
{
    unsigned char ct[CRYPTO_CIPHERTEXTBYTES];
    unsigned char key_b[CRYPTO_BYTES];
    jbyte *pk = (*env)->GetByteArrayElements(env, publicKey, 0);

    pqcrystals_kyber768_ref_enc(ct, key_b, pk);

    // Copy the result to Java byte arrays
    (*env)->SetByteArrayRegion(env, ciphertext, 0, CRYPTO_CIPHERTEXTBYTES, (jbyte *)ct);
    (*env)->SetByteArrayRegion(env, sharedKey, 0, CRYPTO_BYTES, (jbyte *)key_b);

    (*env)->ReleaseByteArrayElements(env, publicKey, pk, 0);
}

// JNI function to decrypt
JNIEXPORT void JNICALL Java_Kyber768Ref_decrypt(JNIEnv *env, jobject obj, jbyteArray sharedKey, jbyteArray ciphertext, jbyteArray secretKey)
{
    unsigned char key_a[CRYPTO_BYTES];
    jbyte *sk = (*env)->GetByteArrayElements(env, secretKey, 0);
    jbyte *ct = (*env)->GetByteArrayElements(env, ciphertext, 0);

    pqcrystals_kyber768_ref_dec(key_a, (unsigned char *)ct, (unsigned char *)sk);

    // Copy the result to Java byte array
    (*env)->SetByteArrayRegion(env, sharedKey, 0, CRYPTO_BYTES, (jbyte *)key_a);

    (*env)->ReleaseByteArrayElements(env, secretKey, sk, 0);
    (*env)->ReleaseByteArrayElements(env, ciphertext, ct, 0);
}
