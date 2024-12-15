import java.util.Arrays;

class FalconTransactionSimulator {
    static {
        System.loadLibrary("FalconTransactionSimulatorJNI");
    }

    // Declare the constants
    private static final int PQCLEAN_FALCON512_CLEAN_CRYPTO_SECRETKEYBYTES = 1281;
    private static final int PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES = 897;
    private static final int PQCLEAN_FALCON512_CLEAN_CRYPTO_BYTES = 752;

    // Declare the JNI functions
    public native byte[] generateKeyPair();

    public native byte[] signMessage(byte[] message, byte[] privateKey);

    public native boolean verifySignature(byte[] message, byte[] signature, byte[] publicKey);

    // Utility method to convert bytes to hex
    private static String bytesToHex(byte[] bytes) {
        StringBuilder hexString = new StringBuilder();
        for (byte b : bytes) {
            hexString.append(String.format("%02X", b));
        }
        return hexString.toString();
    }

    // Simulate the transaction signing and verification
    public void simulateTransaction() {
        // Step 1: Sender generates a key pair
        System.out.println("Generating sender's key pair...");
        byte[] senderKeyPair = generateKeyPair();
        byte[] senderPublicKey = Arrays.copyOfRange(senderKeyPair, 0, PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES);
        byte[] senderPrivateKey = Arrays.copyOfRange(senderKeyPair, PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES,
                senderKeyPair.length);

        // Step 2: Receiver generates a key pair
        System.out.println("Generating receiver's key pair...");
        byte[] receiverKeyPair = generateKeyPair();
        byte[] receiverPublicKey = Arrays.copyOfRange(receiverKeyPair, 0,
                PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES);
        byte[] receiverPrivateKey = Arrays.copyOfRange(receiverKeyPair, PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES,
                receiverKeyPair.length);

        // Step 3: Sender creates a transaction
        String transactionData = "Transfer 100 rupees to receiver's address: " + bytesToHex(receiverPublicKey);
        byte[] transactionBytes = transactionData.getBytes();
        System.out.println("Transaction data: " + transactionData);

        // Step 4: Sender signs the transaction
        byte[] transactionSignature = signMessage(transactionBytes, senderPrivateKey);
        System.out.println("Transaction Signature: " + bytesToHex(transactionSignature));

        // Step 5: Receiver verifies the transaction
        boolean isVerified = verifySignature(transactionBytes, transactionSignature, senderPublicKey);
        System.out.println("Is the transaction valid? " + isVerified);
    }

    public static void main(String[] args) {
        FalconTransactionSimulator simulator = new FalconTransactionSimulator();
        simulator.simulateTransaction();
    }
}
