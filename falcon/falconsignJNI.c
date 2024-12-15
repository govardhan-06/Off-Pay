#include <jni.h>
#include <stdio.h>
#include <string.h>
#include "FalconSign.h"
#include "inner.h"

extern int PQCLEAN_FALCON512_CLEAN_crypto_sign_keypair(uint8_t *pk, uint8_t *sk);
extern int PQCLEAN_FALCON512_CLEAN_crypto_sign_signature(
    uint8_t *sig, size_t *siglen, const uint8_t *msg, size_t msglen, const uint8_t *sk);
extern int PQCLEAN_FALCON512_CLEAN_crypto_sign_verify(
    const uint8_t *sig, size_t siglen, const uint8_t *msg, size_t msglen, const uint8_t *pk);

JNIEXPORT jbyteArray JNICALL Java_FalconSign_generateKeyPair(JNIEnv *env, jobject obj)
{
    uint8_t pk[FalconSign_PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[FalconSign_PQCLEAN_FALCON512_CLEAN_CRYPTO_SECRETKEYBYTES];
    PQCLEAN_FALCON512_CLEAN_crypto_sign_keypair(pk, sk);
    jbyteArray keyPair = (*env)->NewByteArray(env, 2 * FalconSign_PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES);
    (*env)->SetByteArrayRegion(env, keyPair, 0, FalconSign_PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES, (jbyte *)pk);
    (*env)->SetByteArrayRegion(env, keyPair, FalconSign_PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES, FalconSign_PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES, (jbyte *)sk);
    return keyPair;
}

JNIEXPORT jbyteArray JNICALL Java_FalconSign_signMessage(JNIEnv *env, jobject obj, jbyteArray message, jbyteArray privateKey)
{
    uint8_t *msg = (*env)->GetByteArrayElements(env, message, NULL);
    uint8_t *sk = (*env)->GetByteArrayElements(env, privateKey, NULL);
    size_t mlen = (*env)->GetArrayLength(env, message);
    size_t siglen = FalconSign_PQCLEAN_FALCON512_CLEAN_CRYPTO_BYTES;
    uint8_t sig[siglen];
    PQCLEAN_FALCON512_CLEAN_crypto_sign_signature(sig, &siglen, msg, mlen, sk);
    (*env)->ReleaseByteArrayElements(env, message, msg, 0);
    (*env)->ReleaseByteArrayElements(env, privateKey, sk, 0);
    jbyteArray signature = (*env)->NewByteArray(env, siglen);
    (*env)->SetByteArrayRegion(env, signature, 0, siglen, (jbyte *)sig);
    return signature;
}

JNIEXPORT jboolean JNICALL Java_FalconSign_verifySignature(JNIEnv *env, jobject obj, jbyteArray message, jbyteArray signature, jbyteArray publicKey)
{
    uint8_t *msg = (*env)->GetByteArrayElements(env, message, NULL);
    uint8_t *sig = (*env)->GetByteArrayElements(env, signature, NULL);
    uint8_t *pk = (*env)->GetByteArrayElements(env, publicKey, NULL);
    size_t mlen = (*env)->GetArrayLength(env, message);
    size_t siglen = (*env)->GetArrayLength(env, signature);
    int result = PQCLEAN_FALCON512_CLEAN_crypto_sign_verify(sig, siglen, msg, mlen, pk);
    (*env)->ReleaseByteArrayElements(env, message, msg, 0);
    (*env)->ReleaseByteArrayElements(env, signature, sig, 0);
    (*env)->ReleaseByteArrayElements(env, publicKey, pk, 0);
    return result;
}