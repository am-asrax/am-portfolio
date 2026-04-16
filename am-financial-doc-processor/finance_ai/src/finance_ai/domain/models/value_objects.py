from enum import Enum
from pydantic import BaseModel, Field
from typing import List, Dict, Optional

class PlanType(str, Enum):
    IDCW_PLAN = "IDCW_Plan"
    IDCW_DIRECT = "IDCW_Option_Direct_Plan"
    GROWTH_PLAN = "Growth_Plan"
    GROWTH_DIRECT = "Growth_Option_Direct_Plan"

class StockAllocation(BaseModel):
    isin: str = Field(..., description="ISIN code of the stock")
    company: str = Field(..., description="Name of the company")
    industry: str = Field(..., description="Industry sector of the company")
    quantity: int = Field(..., description="Number of shares held")
    market_value_lakhs: float = Field(..., description="Market value in lakhs")
    nav_percentage: float = Field(..., ge=0, le=100, description="Percentage of NAV")

class CashEquivalents(BaseModel):
    treps: float = Field(..., description="TREPS value in lakhs")
    net_current_assets: float = Field(..., description="Net current assets in lakhs")

class IndustryAllocation(BaseModel):
    industry: str = Field(..., description="Name of the industry")
    percentage: float = Field(..., ge=0, le=100, description="Allocation percentage")
