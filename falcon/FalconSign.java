import java.util.Arrays;

class FalconSign {
    // Load the shared library
    static {
        System.loadLibrary("falconsignJNI");
    }

    // Declare the constants
    private static final int PQCLEAN_FALCON512_CLEAN_CRYPTO_SECRETKEYBYTES = 1281;
    private static final int PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES = 897;
    private static final int PQCLEAN_FALCON512_CLEAN_CRYPTO_BYTES = 752;

    // Declare the JNI functions
    public native byte[] generateKeyPair();

    public native byte[] signMessage(byte[] message, byte[] privateKey);

    public native boolean verifySignature(byte[] message, byte[] signature, byte[] publicKey);

    public void testFalcon() {
        // Generate a key pair
        byte[] keyPair = generateKeyPair();
        byte[] publicKey = Arrays.copyOfRange(keyPair, 0, PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES);
        byte[] privateKey = Arrays.copyOfRange(keyPair, PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES, keyPair.length);

        // Sign a message
        byte[] message = "Hello, World!".getBytes();
        byte[] signature = signMessage(message, privateKey);

        System.out.println("Signature : " + signature);

        // Verify the signature
        boolean isValid = verifySignature(message, signature, publicKey);
        System.out.println("Signature is valid: " + isValid);
    }

    public static void main(String args[]) {
        FalconSign fs = new FalconSign();
        fs.testFalcon();
    }
}