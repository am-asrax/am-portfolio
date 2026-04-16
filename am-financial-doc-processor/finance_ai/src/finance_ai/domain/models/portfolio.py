from pydantic import BaseModel, Field
from typing import List, Dict
from .value_objects import IndustryAllocation, CashEquivalents

class PortfolioSummary(BaseModel):
    total_value_lakhs: float = Field(..., description="Total portfolio value in lakhs")
    cash_equivalents: CashEquivalents = Field(..., description="Cash and equivalents")
    industry_allocations: List[IndustryAllocation] = Field(..., description="Industry-wise allocations")
