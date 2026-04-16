from datetime import datetime
from ..ai_integration.excel_processor import ExcelProcessor
from ..db.mongodb import MongoDB
from ..models.fund_data import FundData, FundDataResponse

class FundService:
    def __init__(self):
        self.excel_processor = ExcelProcessor()
        self.db = MongoDB()

    async def process_fund_file(self, file_path: str) -> FundDataResponse:
        # Read and process the Excel file
        df = self.excel_processor.read_excel(file_path)
        extracted_data = self.excel_processor.extract_fund_data(df)
        
        # Create FundData model
        fund_data = FundData(
            fund_name=extracted_data["fund_name"],
            date=datetime.now(),  # You might want to extract this from the file
            nav=extracted_data["nav"],
            aum=extracted_data["aum"],
            portfolio_data=extracted_data["portfolio_data"],
            extracted_metrics=extracted_data["extracted_metrics"]
        )
        
        # Save to database
        doc_id = self.db.insert_fund_data(fund_data.dict())
        
        return FundDataResponse(id=doc_id, fund_data=fund_data)

    def get_fund_data(self, fund_name: str = None) -> list:
        query = {"fund_name": fund_name} if fund_name else {}
        return self.db.get_fund_data(query)

    def cleanup(self):
        self.db.close()
