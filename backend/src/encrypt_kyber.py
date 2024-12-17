import ctypes,os
import binascii
from dotenv import load_dotenv

class Kyber:
    def __init__(self):
        load_dotenv()
        self.kyber = ctypes.CDLL(r".\libpqcrystals_kyber768_ref.dll")

        #Constants
        self.CRYPTO_PUBLICKEYBYTES = 1184
        self.CRYPTO_SECRETKEYBYTES = 1542
        self.CRYPTO_CIPHERTEXTBYTES = 1088
        self.CRYPTO_BYTES = 32

        # Allocate buffers for keys and ciphertext
        self.public_key = (ctypes.c_ubyte * self.CRYPTO_PUBLICKEYBYTES)()
        self.secret_key = (ctypes.c_ubyte * self.CRYPTO_SECRETKEYBYTES)()
        self.ciphertext = (ctypes.c_ubyte * self.CRYPTO_CIPHERTEXTBYTES)()
        self.shared_key_enc = (ctypes.c_ubyte * self.CRYPTO_BYTES)()
        self.shared_key_dec = (ctypes.c_ubyte * self.CRYPTO_BYTES)()

        # Define the function signatures
        self.kyber.pqcrystals_kyber768_ref_keypair.argtypes = [ctypes.POINTER(ctypes.c_ubyte), ctypes.POINTER(ctypes.c_ubyte)]
        self.kyber.pqcrystals_kyber768_ref_enc.argtypes = [
            ctypes.POINTER(ctypes.c_ubyte),  # Ciphertext
            ctypes.POINTER(ctypes.c_ubyte),  # Shared key
            ctypes.POINTER(ctypes.c_ubyte),  # Public key
        ]
        self.kyber.pqcrystals_kyber768_ref_dec.argtypes = [
            ctypes.POINTER(ctypes.c_ubyte),  # Shared key
            ctypes.POINTER(ctypes.c_ubyte),  # Ciphertext
            ctypes.POINTER(ctypes.c_ubyte),  # Secret key
        ]

    # Generate keypair
    def generate_keypair(self):
        self.kyber.pqcrystals_kyber768_ref_keypair(self.public_key, self.secret_key)
        return bytes(self.public_key), bytes(self.secret_key)

    # Encrypt
    def encrypt(self,public_key):
        pk = (ctypes.c_ubyte * self.CRYPTO_PUBLICKEYBYTES).from_buffer_copy(public_key)
        self.kyber.pqcrystals_kyber768_ref_enc(self.ciphertext, self.shared_key_enc, pk)
        return bytes(self.ciphertext), bytes(self.shared_key_enc)

    # Decrypt
    def decrypt(self,ciphertext, secret_key):
        ct = (ctypes.c_ubyte * self.CRYPTO_CIPHERTEXTBYTES).from_buffer_copy(ciphertext)
        sk = (ctypes.c_ubyte * self.CRYPTO_SECRETKEYBYTES).from_buffer_copy(secret_key)
        self.kyber.pqcrystals_kyber768_ref_dec(self.shared_key_dec, ct, sk)
        return ct,bytes(self.shared_key_dec)

    def main(self):
        load_dotenv()
        # Generate keypair
        public_key, secret_key = self.generate_keypair()

        # public_key=os.getenv("SERVER_PUBLIC_KEY")
        # secret_key=os.getenv("SERVER_PRIVATE_KEY")

        # public_key=bytes.fromhex(public_key)
        # secret_key=bytes.fromhex(secret_key)

        print("Public Key:", public_key.hex())
        print("Secret Key:", secret_key.hex())

        # Encrypt
        ciphertext, shared_key_enc = self.encrypt(public_key)
        print("Ciphertext:", ciphertext.hex())
        print("Shared Key (Encryption):", shared_key_enc.hex())

        # Decrypt
        ct,shared_key_dec = self.decrypt(ciphertext, secret_key)
        ct=bytes(ct)
        print("Ciphertext:",ct.hex())
        print("Shared Key (Decryption):", shared_key_dec.hex())

        # Verify the shared keys match
        assert shared_key_enc == shared_key_dec, "Shared keys do not match!"
        print("Shared keys match.")

if __name__ == "__main__":
    k=Kyber()
    k.main()
