public class Kyber768Ref {
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
        Kyber768Ref ref = new Kyber768Ref();
        byte[] publicKey = new byte[CRYPTO_PUBLICKEYBYTES];
        byte[] secretKey = new byte[CRYPTO_SECRETKEYBYTES];

        ref.generateKeypair(publicKey, secretKey);
        System.out.println("Public Key: " + bytesToHex(publicKey));
        System.out.println("Secret Key: " + bytesToHex(secretKey));

        byte[] ciphertext = new byte[CRYPTO_CIPHERTEXTBYTES];
        byte[] sharedKey = new byte[CRYPTO_BYTES];
        ref.encrypt(ciphertext, sharedKey, publicKey);
        System.out.println("Ciphertext: " + bytesToHex(ciphertext));
        System.out.println("Shared Key: " + bytesToHex(sharedKey));

        byte[] decryptedKey = new byte[CRYPTO_BYTES];
        ref.decrypt(decryptedKey, ciphertext, secretKey);
        System.out.println("Decrypted Key: " + bytesToHex(decryptedKey));
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
