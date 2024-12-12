#ifndef KYBER768_REF_JNI_H
#define KYBER768_REF_JNI_H

#include <jni.h>
#include "kem.h"
#include "randombytes.h"

// Function prototypes for JNI bindings
JNIEXPORT void JNICALL Java_com_example_Kyber768_ref_generateKeypair(JNIEnv *env, jobject obj, jbyteArray publicKey, jbyteArray secretKey);
JNIEXPORT void JNICALL Java_com_example_Kyber768_ref_encrypt(JNIEnv *env, jobject obj, jbyteArray ciphertext, jbyteArray sharedKey, jbyteArray publicKey);
JNIEXPORT void JNICALL Java_com_example_Kyber768_ref_decrypt(JNIEnv *env, jobject obj, jbyteArray sharedKey, jbyteArray ciphertext, jbyteArray secretKey);

#endif
