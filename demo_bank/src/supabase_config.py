import os,sys
from supabase import create_client, Client
from dataclasses import dataclass
from dotenv import load_dotenv
from src.utils.exception import customException
from src.utils.logger import logging

@dataclass
class Supabase_config:
    load_dotenv()
    SUPABASE_URL = os.getenv("SUPABASE_URL")
    SUPABASE_KEY = os.getenv("SUPABASE_KEY")

class Supabase:
    def __init__(self):
        self.config=Supabase_config()
        self.supabase: Client = create_client(self.config.SUPABASE_URL, self.config.SUPABASE_KEY)
    
    def insert_data(self,uid,emailid):
        '''
        Insert data into supabase
        '''
        try:
            data={
                "user_id":uid,
                "email_id":emailid
            }
            response = (self.supabase.table("user")
                        .insert(data)
                        .execute()
                        )
            logging.info(f"Inserted data into supabase.")
            return (response.data)[0]
        except Exception as e:
            logging.error(f"Error inserting data into supabase: {e}")
            return {"message":"user already exists","status_code":500}
    
    def fetch_account_data(self,uid):
        '''
        Fetch account data from supabase
        '''
        try:
            response = (
                        self.supabase.table("bank_accounts")
                        .select("*")
                        .eq("account_number", uid)
                        .execute()
                        )
            logging.info(f"Fetched account data from supabase.") 
            return (response.data)[0]
        except:
            logging.error(f"Error fetching account data from supabase.")
            return {"message":"account not found","status_code":404}
    
    def update_balance(self,uid,balance):
        '''
        Update balance in supabase
        '''
        try:
            response = (
                self.supabase.table("bank_accounts")
                .update({"balance": balance})
                .eq("account_number", uid)
                .execute()
                )
            logging.info(f"Updated balance in supabase.")
            return (response.data)[0]
        except Exception as e:
            logging.error(f"Error updating balance in supabase: {e}")
            return {"message":"account not found","status_code":404}
        

# Module testing
if __name__=="__main__":
    supabase=Supabase()
    response=supabase.fetch_account_data(10001)
    print(response)
    response=supabase.update_balance(10001,500)
    print(response)


    

        
    
    
