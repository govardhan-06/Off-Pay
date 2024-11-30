# Off-Pay

### **Final Workflow for OffPay with Offline-Only Transaction Validation**

---

### **1. QR Code for Bluetooth Pairing and Transaction Initialization**
- **Device B (Payee)** generates a **QR Code** containing:
  - Payee account details (wallet ID or bank info).
  - Payee public key for encryption.
  - Bluetooth pairing credentials.
- **Device A (Payer)** scans the QR code to:
  - Establish a secure Bluetooth connection with **Device B**.
  - Retrieve the payee’s account information and public key.

---

### **2. Bluetooth Pairing and Secure Channel Establishment**
- After scanning, **Device A** and **Device B** are paired via Bluetooth.
- A secure communication channel is established using encryption (e.g., AES or ECDH) over the Bluetooth connection.

---

### **3. Transaction Data Exchange**
- **Device A (Payer)** enters the payment amount in the app.
- The app on **Device A**:
  - Encrypts the transaction data (amount, payer details, and transaction ID) with **Device B’s public key**.
  - Sends the encrypted transaction data to **Device B** over the Bluetooth connection.
  
- **Device B (Payee)**:
  - Decrypts the received transaction data using its private key.
  - Verifies the transaction details, including the payer identity and amount.

---

### **4. Local Transaction Validation (Fully Offline)**
- The validation process happens **offline**:
  - **Device A** verifies that it has sufficient funds for the payment.
  - **Device B** checks the integrity of the transaction and confirms receipt.
  - A **mutual digital signature process** is initiated:
    - **Device A** signs the transaction with its private key.
    - **Device B** countersigns it with its private key, confirming the transaction.

---

### **5. Offline Storage of Transaction Data**
- After successful validation:
  - **Device A** stores the signed transaction details locally.
  - **Device B** stores the transaction receipt (confirmation details) locally.

---

### **6. Syncing to Backend and Bank (When Either Device Comes Online)**
- The transaction is fully validated and completed offline. However, syncing ensures that the transaction is recorded in the backend and bank systems.
- When **either device comes online**:
  1. The device uploads its locally stored transaction data (encrypted and signed).
  2. The backend validates the digital signatures and updates the payment records.
  3. The backend notifies the **bank system** to update the account balances.
  4. A **transaction status confirmation** is sent back to both devices (if both are online).

---

### **Key Features of the Workflow**

1. **Offline Completion of Transaction**:
   - All validation (payer funds, payee receipt) happens locally and offline.
   - The transaction is considered complete when both devices have signed the data and stored it.

2. **Syncing for Record-Keeping**:
   - The syncing step is optional for the transaction to work but is crucial for reflecting payment records in the bank system or backend database.

3. **Security Through Cryptography**:
   - Transaction details are encrypted, ensuring secure offline communication.
   - Digital signatures ensure authenticity and prevent tampering.

4. **Bluetooth as the Only Dependency**:
   - The entire transaction is facilitated by QR-based Bluetooth pairing, avoiding any reliance on the internet for validation.

---

### **Example Scenario**

#### **Transaction Flow:**
1. **Device B (Payee)** generates a QR code and displays it.
2. **Device A (Payer)** scans the QR code, pairs via Bluetooth, and initiates a transaction of $100.
3. Over Bluetooth:
   - **Device A** sends encrypted payment details to **Device B**.
   - **Device B** validates the details, countersigns, and confirms the transaction.
4. Both devices store the signed transaction data locally.

#### **Syncing to Backend (Optional Until Online):**
- If **Device A** comes online first:
  - It syncs the transaction details to the backend, which updates the bank records.
  - **Device B** receives a sync update when it later comes online.
- If **Device B** comes online first:
  - It uploads the transaction receipt to the backend, triggering bank updates.
  - **Device A** gets the sync update when it comes online.

---

### **Advantages of This Workflow**

- **Full Offline Capability**: The system doesn’t require internet connectivity to complete payments.
- **Minimal Delay**: Syncing only ensures backend and bank records are updated but doesn’t block the transaction.
- **Security**: Encryption and digital signatures protect transaction integrity and user data.
- **Simplicity for Users**: Scanning a QR code and relying on Bluetooth ensures a seamless experience.
