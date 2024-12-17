from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from fastapi.responses import RedirectResponse
from fastapi.middleware.cors import CORSMiddleware
import sys,os, uvicorn
from dotenv import load_dotenv
from src.utils.exception import customException
from src.utils.logger import logging
from starlette.responses import JSONResponse
from src.supabase_config import Supabase
from pydantic import BaseModel, ConfigDict,  ValidationError
from typing import Optional
import json, requests
from typing import List
from src.encrypt_kyber import Kyber

load_dotenv()
app = FastAPI()
kyber=Kyber()
supabase=Supabase()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Transaction(BaseModel):
    from_account: str
    to_account: str
    amount: float

@app.get("/")
async def home():
    '''
    This route is used to redirect to the swaggerUI page.
    '''
    return RedirectResponse(url="/docs")

@app.get("/public-key")
async def get_public_key():
    '''
    This route is used to get the public key.
    '''
    try:
        public_key=os.getenv("SERVER_PUBLIC_KEY")
        return JSONResponse(content={"public key":public_key},status_code=200)
    except:
        return JSONResponse(content={"error":"Failed to get public key"},status_code=500)


@app.post("/transactions/encrypted")
async def create_transaction(encrypted_transaction: str):
    '''
    This route is used to get the transaction data from local ledger.
    '''
    try:
        secret_key=os.getenv("SERVER_PRIVATE_KEY")
        # Decrypt the transaction data
        # ciphertext,decrypted_transaction = kyber.decrypt(encrypted_transaction,secret_key)

        BANK_SERVER_URL=os.getenv("BANK_SERVER_URL")
        decrypted_data={"from_account":"10001","to_account":"10002","amount":500.0}

        bank_response = requests.post(BANK_SERVER_URL, json=decrypted_data)
        
        if bank_response.status_code != 200:
            raise HTTPException(status_code=bank_response.status_code, detail=bank_response.json().get("detail", "Error"))
        
        return {"message": "Transaction processed successfully", "bank_response": bank_response.json()}
        # return JSONResponse(content={"ciphertext":ciphertext,"decrypted_transaction":decrypted_transaction},status_code=200)
    except Exception as e:
        return JSONResponse(content={"error": f"Failed to sync transaction: {str(e)}"}, status_code=500)

@app.post("/link-account")
async def link_account(account_number: str):
    '''
    This route is used to link a bank account.
    '''
    try:
        bank_account_data = {
            "account_number": account_number,
            "account_holder_name": account_holder_name,
            "phone_number": phone_number,
            "branch": branch
        }

        logging.info(f"Linking account: {bank_account_data}")
        
        return JSONResponse(content={"message": "Bank account linked successfully", "data": bank_account_data}, status_code=200)
    except Exception as e:
        return JSONResponse(content={"error": f"Failed to link bank account: {str(e)}"}, status_code=500)


if __name__=="__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)