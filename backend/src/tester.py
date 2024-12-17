import hashlib
import ctypes,os
from binascii import hexlify
# from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
# from cryptography.hazmat.backends import default_backend

# Load the Kyber library
kyber_lib = ctypes.CDLL(r".\libpqcrystals_kyber768_ref.dll")

# Constants (these should match the values in the Kyber library)
KYBER_CIPHERTEXTBYTES = 768
KYBER_SYMBYTES = 32
KYBER_PUBLICKEYBYTES = 800
KYBER_SECRETKEYBYTES = 1600

# Utility function to generate random bytes
def generate_random_bytes(size):
    random_bytes = (ctypes.c_uint8 * size)()
    kyber_lib.randombytes(random_bytes, size)
    return bytes(random_bytes)

# Function to generate a keypair (public and private key)
def generate_keypair():
    public_key = (ctypes.c_uint8 * KYBER_PUBLICKEYBYTES)()
    private_key = (ctypes.c_uint8 * KYBER_SECRETKEYBYTES)()
    
    # Generate the keypair
    kyber_lib.PQCLEAN_MLKEM768_CLEAN_crypto_kem_keypair(public_key, private_key)
    
    return bytes(public_key), bytes(private_key)

# Encrypt the transaction data
def encrypt_transaction(public_key, transaction_data):
    """Encrypt the transaction data using Kyber KEM."""
    
    # Prepare the ciphertext and shared secret buffers
    ciphertext = (ctypes.c_uint8 * KYBER_CIPHERTEXTBYTES)()
    shared_secret = (ctypes.c_uint8 * KYBER_SYMBYTES)()

    # Step 1: Generate random coins
    coins = generate_random_bytes(KYBER_SYMBYTES)

    # Step 2: Hash the transaction data
    transaction_data_bytes = transaction_data.encode('utf-8')  # Ensure it's in bytes
    hashed_transaction_data = hashlib.sha256(transaction_data_bytes).digest()

    # Step 3: Combine the coins and the hashed transaction data
    buf = coins + hashed_transaction_data  # This is the combined data

    # Step 4: Encrypt using the public key
    kyber_lib.PQCLEAN_MLKEM768_CLEAN_crypto_kem_enc(ciphertext, shared_secret, public_key)

    # Now encrypt the transaction data using the shared secret (simple AES encryption)
    cipher = Cipher(algorithms.AES(shared_secret), modes.CBC(shared_secret[:16]), backend=default_backend())
    encryptor = cipher.encryptor()
    
    # Ensure the data is padded to be multiple of block size
    padded_data = transaction_data_bytes + b'\0' * (16 - len(transaction_data_bytes) % 16)
    encrypted_data = encryptor.update(padded_data) + encryptor.finalize()

    # Combine the ciphertext and encrypted transaction data
    combined_ciphertext = encrypted_data + bytes(ciphertext)
    
    return combined_ciphertext, bytes(shared_secret)

# Decrypt the transaction data
def decrypt_transaction(private_key, combined_ciphertext):
    """Decrypt the transaction data using Kyber KEM and private key."""
    
    # Prepare the shared secret buffer
    shared_secret = (ctypes.c_uint8 * KYBER_SYMBYTES)()

    # Extract the ciphertext and the encrypted transaction data
    encrypted_data = combined_ciphertext[:-KYBER_CIPHERTEXTBYTES]
    ciphertext = combined_ciphertext[-KYBER_CIPHERTEXTBYTES:]

    # Step 1: Decrypt the ciphertext using the private key
    kyber_lib.PQCLEAN_MLKEM768_CLEAN_crypto_kem_dec(shared_secret, ciphertext, private_key)

    # Use the shared secret to decrypt the encrypted transaction data (using AES)
    cipher = Cipher(algorithms.AES(shared_secret), modes.CBC(shared_secret[:16]), backend=default_backend())
    decryptor = cipher.decryptor()
    
    decrypted_data = decryptor.update(encrypted_data) + decryptor.finalize()
    
    # Remove padding (assuming padding with 0s)
    transaction_data = decrypted_data.rstrip(b'\0').decode('utf-8')

    # Return the decrypted transaction data
    return transaction_data, bytes(shared_secret)

# Simulating the transaction between two devices
def simulate_transaction():
    # Device A generates a public/private keypair
    print("Device A generating keypair...")
    public_key_A, private_key_A = generate_keypair()
    
    # Device B generates a public/private keypair
    print("Device B generating keypair...")
    public_key_B, private_key_B = generate_keypair()

    # Device A wants to send a transaction (e.g., "100 USD to Device B")
    transaction_data = "100 USD to Device B"
    print(f"Device A encrypting transaction: {transaction_data}")

    # Device A encrypts the transaction data using Device B's public key
    combined_ciphertext, shared_secret_A_to_B = encrypt_transaction(public_key_B, transaction_data)
    print(f"Device A sends ciphertext to Device B: {hexlify(combined_ciphertext)}")

    # Device B receives the ciphertext and uses its private key to decrypt it
    print("Device B decrypting the ciphertext...")
    decrypted_transaction_data, shared_secret_B = decrypt_transaction(private_key_B, combined_ciphertext)
    print(f"Device B decrypted transaction data: {decrypted_transaction_data}")

    # Check if the shared secrets are the same
    if shared_secret_A_to_B == shared_secret_B:
        print("Transaction successful: Shared secrets match!")
    else:
        print("Error: Shared secrets do not match.")

# Run the simulation
simulate_transaction()
