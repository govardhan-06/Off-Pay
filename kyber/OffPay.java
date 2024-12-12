import java.util.Arrays;

class OffPay {
    static {
        System.loadLibrary("kyber768_ref_jni");
    }

    // Declare the constants
    private static final int CRYPTO_PUBLICKEYBYTES = 1184;
    private static final int CRYPTO_SECRETKEYBYTES = 2400;
    private static final int CRYPTO_CIPHERTEXTBYTES = 1088;
    private static final int CRYPTO_BYTES = 32;

    // Declare native methods
    public native void generateKeypair(byte[] publicKey, byte[] secretKey);

    public native void encrypt(byte[] ciphertext, byte[] sharedKey, byte[] publicKey);

    public native void decrypt(byte[] sharedKey, byte[] ciphertext, byte[] secretKey);

    public static void main(String[] args) {
        // Initialize sender and receiver
        OffPay sender = new OffPay();
        OffPay receiver = new OffPay();

        // Generate key pairs for sender and receiver
        byte[] senderPublicKey = new byte[CRYPTO_PUBLICKEYBYTES];
        byte[] senderSecretKey = new byte[CRYPTO_SECRETKEYBYTES];
        sender.generateKeypair(senderPublicKey, senderSecretKey);

        byte[] receiverPublicKey = new byte[CRYPTO_PUBLICKEYBYTES];
        byte[] receiverSecretKey = new byte[CRYPTO_SECRETKEYBYTES];
        receiver.generateKeypair(receiverPublicKey, receiverSecretKey);

        // Sender sends public key to receiver
        System.out.println("Sender's Public Key: " + bytesToHex(senderPublicKey));

        // Receiver receives sender's public key
        byte[] receivedSenderPublicKey = senderPublicKey.clone();

        // Receiver generates shared key and encrypts it with sender's public key
        byte[] receiverSharedKey = new byte[CRYPTO_BYTES];
        byte[] receiverCiphertext = new byte[CRYPTO_CIPHERTEXTBYTES];
        receiver.encrypt(receiverCiphertext, receiverSharedKey, receivedSenderPublicKey);

        // Receiver sends ciphertext and public key to sender
        System.out.println("Receiver's Public Key: " + bytesToHex(receiverPublicKey));
        System.out.println("Ciphertext: " + bytesToHex(receiverCiphertext));

        // Sender receives receiver's public key and ciphertext
        byte[] receivedCiphertext = receiverCiphertext.clone();

        // Sender decrypts ciphertext with private key to obtain shared key
        byte[] senderSharedKey = new byte[CRYPTO_BYTES];
        sender.decrypt(senderSharedKey, receivedCiphertext, senderSecretKey);

        // Verify that shared keys match
        if (Arrays.equals(senderSharedKey, receiverSharedKey)) {
            System.out.println("Shared keys match!");
        } else {
            System.out.println("Shared keys do not match!");
        }

        // Now that we have a shared key, we can use it to encrypt and decrypt the
        // payment amount
        String paymentAmount = "100.00";
        byte[] paymentAmountBytes = paymentAmount.getBytes();

        // Encrypt payment amount with shared key
        byte[] encryptedPaymentAmount = encryptSymmetric(paymentAmountBytes, senderSharedKey);

        // Decrypt payment amount with shared key
        byte[] decryptedPaymentAmount = decryptSymmetric(encryptedPaymentAmount, senderSharedKey);

        System.out.println("Decrypted Payment Amount: " + new String(decryptedPaymentAmount));
    }

    // Helper function to convert bytes to hex string
    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    // Helper function to encrypt data symmetrically with a shared key
    private static byte[] encryptSymmetric(byte[] data, byte[] sharedKey) {
        // Implement symmetric encryption algorithm (e.g., AES) here
        // For demonstration purposes, we'll just XOR the data with the shared key
        byte[] encryptedData = new byte[data.length];
        for (int i = 0; i < data.length; i++) {
            encryptedData[i] = (byte) (data[i] ^ sharedKey[i % sharedKey.length]);
        }
        return encryptedData;
    }

    // Helper function to decrypt data symmetrically with a shared key
    private static byte[] decryptSymmetric(byte[] encryptedData, byte[] sharedKey) {
        // Implement symmetric decryption algorithm (e.g., AES) here
        // For demonstration purposes, we'll just XOR the encrypted data with the shared
        // key
        byte[] decryptedData = new byte[encryptedData.length];
        for (int i = 0; i < encryptedData.length; i++) {
            decryptedData[i] = (byte) (encryptedData[i] ^ sharedKey[i % sharedKey.length]);
        }
        return decryptedData;
    }
}