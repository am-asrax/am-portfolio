import pandas as pd
from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from ..config.config import settings
from typing import Dict, Any

class ExcelProcessor:
    def __init__(self):
        self.llm = ChatOpenAI(api_key=settings.OPENAI_API_KEY)
        self.prompt = ChatPromptTemplate.from_messages([
            ("system", "You are a financial data analyst. Extract key metrics and insights from the given fund data."),
            ("user", "Analyze the following fund data and extract key metrics:\n{fund_data}")
        ])

    def read_excel(self, file_path: str) -> pd.DataFrame:
        return pd.read_excel(file_path)

    def extract_fund_data(self, df: pd.DataFrame) -> Dict[str, Any]:
        # Convert DataFrame to a more readable format
        data_str = df.to_string()
        
        # Create chain and run analysis
        chain = self.prompt | self.llm
        result = chain.invoke({"fund_data": data_str})
        
        # Process the basic fund data
        fund_data = {
            "fund_name": self._extract_fund_name(df),
            "nav": self._extract_nav(df),
            "aum": self._extract_aum(df),
            "portfolio_data": self._extract_portfolio_data(df),
            "extracted_metrics": self._parse_ai_response(result.content)
        }
        
        return fund_data

    def _extract_fund_name(self, df: pd.DataFrame) -> str:
        # Implement fund name extraction logic
        # This is a placeholder - adjust based on actual Excel structure
        return "HDFC Defence Fund"

    def _extract_nav(self, df: pd.DataFrame) -> float:
        # Implement NAV extraction logic
        # This is a placeholder - adjust based on actual Excel structure
        return 0.0

    def _extract_aum(self, df: pd.DataFrame) -> float:
        # Implement AUM extraction logic
        # This is a placeholder - adjust based on actual Excel structure
        return 0.0

    def _extract_portfolio_data(self, df: pd.DataFrame) -> Dict[str, Any]:
        # Implement portfolio data extraction logic
        # This is a placeholder - adjust based on actual Excel structure
        return {}

    def _parse_ai_response(self, ai_response: str) -> Dict[str, Any]:
        # Convert AI response to structured data
        # This is a placeholder - implement proper parsing logic
        return {"ai_insights": ai_response}
