import ctypes
import os

# Load the shared library (update the path to your shared library file)
KYBER_LIB_PATH = "./kyber768.so"  # Update with your .dll or .so file path
kyber = ctypes.CDLL(KYBER_LIB_PATH)

# Define constants for Kyber
KYBER_PUBLICKEYBYTES = 1184
KYBER_SECRETKEYBYTES = 2400
KYBER_CIPHERTEXTBYTES = 1088
KYBER_SSBYTES = 32

# Define helper functions to allocate buffers
def create_buffer(size):
    return (ctypes.c_ubyte * size)()

# Function to print bytes as a hex string
def print_hex(label, data, size):
    print(f"{label}: ", end="")
    print("".join(format(data[i], "02x") for i in range(size)))

# 1. Keypair Generation (Sender generates keys)
def generate_keypair():
    pk = create_buffer(KYBER_PUBLICKEYBYTES)  # Public key
    sk = create_buffer(KYBER_SECRETKEYBYTES)  # Secret key
    kyber.pqcrystals_kyber768_ref_keypair(pk, sk)
    return pk, sk

# 2. Encryption (Sender encrypts the message)
def encrypt_message(pk):
    ct = create_buffer(KYBER_CIPHERTEXTBYTES)  # Ciphertext
    ss = create_buffer(KYBER_SSBYTES)          # Shared secret
    kyber.pqcrystals_kyber768_ref_enc(ct, ss, pk)
    return ct, ss

# 3. Decryption (Receiver decrypts the ciphertext)
def decrypt_message(ct, sk):
    ss_recovered = create_buffer(KYBER_SSBYTES)  # Recovered shared secret
    kyber.pqcrystals_kyber768_ref_dec(ss_recovered, ct, sk)
    return ss_recovered

# Main workflow
def main():
    # ---- Sender Side ----
    print("=== Sender Side ===")
    # Generate key pair
    pk, sk = generate_keypair()
    print_hex("Public Key", pk, KYBER_PUBLICKEYBYTES)
    print_hex("Secret Key", sk, KYBER_SECRETKEYBYTES)

    # Encrypt the message
    print("\nEncrypting message: 'hello'")
    ct, ss = encrypt_message(pk)
    print_hex("Ciphertext", ct, KYBER_CIPHERTEXTBYTES)
    print_hex("Shared Secret (Sender)", ss, KYBER_SSBYTES)

    # ---- Receiver Side ----
    print("\n=== Receiver Side ===")
    # Decrypt the message
    ss_recovered = decrypt_message(ct, sk)
    print_hex("Recovered Shared Secret", ss_recovered, KYBER_SSBYTES)

    # Compare shared secrets
    if bytes(ss) == bytes(ss_recovered):
        print("\nMessage successfully decrypted!")
    else:
        print("\nDecryption failed. Shared secrets do not match.")

if __name__ == "__main__":
    main()
