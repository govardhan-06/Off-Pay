import ctypes

# Load the DLL
kyber = ctypes.CDLL(r".\libpqcrystals_kyber768_ref.dll")

# Buffer sizes (adjust according to Kyber768 parameters)
KYBER_SYMBYTES = 32
KYBER_PUBLICKEYBYTES = 1184
KYBER_CIPHERTEXTBYTES = 1088
KYBER_SSBYTES = 32

# Prepare buffers
public_key = (ctypes.c_ubyte * KYBER_PUBLICKEYBYTES)()
private_key = (ctypes.c_ubyte * KYBER_PUBLICKEYBYTES)()
ciphertext = (ctypes.c_ubyte * KYBER_CIPHERTEXTBYTES)()
shared_secret_enc = (ctypes.c_ubyte * KYBER_SSBYTES)()
shared_secret_dec = (ctypes.c_ubyte * KYBER_SSBYTES)()

# Deterministic randomness (e.g., 32 zero bytes)
coins = (ctypes.c_ubyte * KYBER_SYMBYTES)(*([0] * KYBER_SYMBYTES))

# Generate keypair
kyber.pqcrystals_kyber768_ref_keypair(public_key, private_key)

# Encrypt using deterministic randomness
kyber.pqcrystals_kyber768_ref_enc_derand(ciphertext, shared_secret_enc, public_key, coins)

# Decrypt ciphertext
kyber.pqcrystals_kyber768_ref_dec(shared_secret_dec, ciphertext, private_key)

# Compare shared secrets
assert bytes(shared_secret_enc) == bytes(shared_secret_dec), "Shared keys do not match!"
print("Shared keys match successfully.")
