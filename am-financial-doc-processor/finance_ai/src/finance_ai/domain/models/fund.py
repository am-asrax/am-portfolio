from datetime import datetime
from pydantic import BaseModel, Field
from typing import List, Dict
from .value_objects import StockAllocation, PlanType
from .portfolio import PortfolioSummary
from .metrics import KeyMetrics

class FundData(BaseModel):
    fund_name: str = Field(..., description="Name of the fund")
    portfolio_date: str = Field(..., description="Date of the portfolio in DD-MMM-YYYY format")
    stock_allocations: List[StockAllocation] = Field(..., description="List of stock holdings")
    portfolio_summary: PortfolioSummary = Field(..., description="Summary of the portfolio")
    nav_history: Dict[str, Dict[PlanType, float]] = Field(..., description="NAV history data")
    key_metrics: KeyMetrics = Field(..., description="Key performance and risk metrics")
