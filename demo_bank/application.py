from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from fastapi.responses import RedirectResponse
from fastapi.middleware.cors import CORSMiddleware
import sys,os, uvicorn
from src.utils.exception import customException
from src.utils.logger import logging
from starlette.responses import JSONResponse
from src.supabase_config import Supabase
from pydantic import BaseModel, ConfigDict,  ValidationError
from typing import Optional
import json, requests
from typing import List

app = FastAPI()
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

@app.post("/get-account-info")
async def insert_user(uid:str):
    '''
    This route is used to get bank account information
    '''
    try:
        response=supabase.fetch_account_data(uid)
        try:
            if response["status_code"]:
                return JSONResponse(content=response,status_code=400)
        except:
            return JSONResponse(content=response,status_code=200)
            
    except:
        return JSONResponse(content={"error": "Failed to fetch account data"},status_code=400)

@app.post("/process-transaction")
async def process_transaction(transaction: Transaction):
    '''
    This route is used to process a transaction
    '''
    try:
        sender=supabase.fetch_account_data(transaction.from_account)
        try:
            if sender["status_code"] == 404:
                return JSONResponse(content={"error": "Sender account not found"},status_code=404)
        except:
            pass

        receiver=supabase.fetch_account_data(transaction.to_account)
        try:
            if receiver["status_code"] == 404:
                return JSONResponse(content={"error": "Receiver account not found"},status_code=404)
        except:
            pass
        
        amount=transaction.amount

        if(sender["balance"]-amount < 0):
            raise HTTPException(status_code=400, detail="Insufficient funds")

        sender["balance"]=sender["balance"]-amount
        receiver["balance"]=receiver["balance"]+amount
        supabase.update_balance(sender["account_number"],sender["balance"])
        supabase.update_balance(receiver["account_number"],receiver["balance"])
        return JSONResponse(content={"message":"Transaction Successfull"},status_code=200)
    
    except:
        return JSONResponse(content={"error": "Failed to process transaction"},status_code=400)

if __name__=="__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)