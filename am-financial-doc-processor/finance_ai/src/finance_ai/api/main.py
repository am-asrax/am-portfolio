from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import os
from ..services.fund_service import FundService
from ..models.fund_data import FundDataResponse

app = FastAPI(title="Finance AI API")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_excel_processor():
    return ExcelProcessor()

@app.post("/api/fund/upload", response_model=FundDataResponse)
async def upload_fund_file(file: UploadFile = File(...)):
    if not file.filename.endswith('.xlsx'):
        raise HTTPException(status_code=400, detail="Only Excel files are supported")
    
    # Save the uploaded file temporarily
    temp_path = f"temp_{file.filename}"
    try:
        # Save the file
        with open(temp_path, "wb") as buffer:
            content = await file.read()
            buffer.write(content)
        
        # Process the file
        fund_service = FundService()
        result = await fund_service.process_fund_file(temp_path)
        fund_service.cleanup()
        
        return result
    
    finally:
        # Clean up the temporary file
        if os.path.exists(temp_path):
            os.remove(temp_path)

@app.get("/api/fund/{fund_name}")
async def get_fund_data(fund_name: str):
    fund_service = FundService()
    try:
        return fund_service.get_fund_data(fund_name)
    finally:
        fund_service.cleanup()

@app.get("/api/fund")
async def get_all_funds():
    fund_service = FundService()
    try:
        return fund_service.get_fund_data()
    finally:
        fund_service.cleanup()
