from pydantic import BaseModel, Field
from datetime import datetime
from typing import Dict, List, Optional, Literal
from enum import Enum

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

class PortfolioSummary(BaseModel):
    total_value_lakhs: float = Field(..., description="Total portfolio value in lakhs")
    cash_equivalents: CashEquivalents = Field(..., description="Cash and equivalents")
    industry_allocations: List[IndustryAllocation] = Field(..., description="Industry-wise allocations")

class NavValues(BaseModel):
    IDCW_Plan: float = Field(..., alias="IDCW_Plan")
    IDCW_Option_Direct_Plan: float = Field(..., alias="IDCW_Option_Direct_Plan")
    Growth_Plan: float = Field(..., alias="Growth_Plan")
    Growth_Option_Direct_Plan: float = Field(..., alias="Growth_Option_Direct_Plan")

class NavHistory(BaseModel):
    current: Dict[PlanType, float] = Field(..., alias="as_of_date")
    previous: Dict[PlanType, float] = Field(..., alias="previous_month")
    previous_date: str = Field(..., alias="previous_month_date")

class KeyMetrics(BaseModel):
    portfolio_turnover_ratio: float = Field(..., description="Portfolio turnover ratio")
    risk_level: str = Field(..., description="Risk level description")
    default_exposures: float = Field(..., description="Default exposures percentage")
    derivative_exposures: float = Field(..., description="Derivative exposures percentage")

class FundData(BaseModel):
    fund_name: str = Field(..., description="Name of the fund")
    portfolio_date: str = Field(..., description="Date of the portfolio in DD-MMM-YYYY format")
    stock_allocations: List[StockAllocation] = Field(..., description="List of stock holdings")
    portfolio_summary: PortfolioSummary = Field(..., description="Summary of the portfolio")
    nav_history: Dict[str, Dict[PlanType, float]] = Field(..., description="NAV history data")
    key_metrics: KeyMetrics = Field(..., description="Key performance and risk metrics")

class FundDataResponse(BaseModel):
    id: str = Field(..., description="Unique identifier for the fund data")
    fund_data: FundData = Field(..., description="Detailed fund data")
    created_at: datetime = Field(default_factory=datetime.utcnow, description="Timestamp of creation")
    updated_at: datetime = Field(default_factory=datetime.utcnow, description="Timestamp of last update")

    @classmethod
    def from_payload(cls, payload: dict) -> 'FundDataResponse':
        # Transform the nav_history to use PlanType enum keys
        nav_history = {}
        for date_key, nav_values in payload.get('nav_history', {}).items():
            nav_history[date_key] = {
                PlanType.IDCW_PLAN: nav_values['IDCW_Plan'],
                PlanType.IDCW_DIRECT: nav_values['IDCW_Option_Direct_Plan'],
                PlanType.GROWTH_PLAN: nav_values['Growth_Plan'],
                PlanType.GROWTH_DIRECT: nav_values['Growth_Option_Direct_Plan']
            }
        
        # Create the FundData instance
        fund_data = FundData(
            fund_name=payload['fund_name'],
            portfolio_date=payload['portfolio_date'],
            stock_allocations=[
                StockAllocation(
                    isin=stock['isin'],
                    company=stock['company'],
                    industry=stock['industry'],
                    quantity=stock['quantity'],
                    market_value_lakhs=stock['market_value_lakhs'],
                    nav_percentage=stock['nav_percentage']
                )
                for stock in payload.get('stock_allocations', [])
            ],
            portfolio_summary=PortfolioSummary(
                total_value_lakhs=payload['portfolio_summary']['total_value_lakhs'],
                cash_equivalents=CashEquivalents(
                    treps=payload['portfolio_summary']['cash_equivalents']['treps'],
                    net_current_assets=payload['portfolio_summary']['cash_equivalents']['net_current_assets']
                ),
                industry_allocations=[
                    IndustryAllocation(
                        industry=ia['industry'],
                        percentage=ia['percentage']
                    )
                    for ia in payload['portfolio_summary'].get('industry_allocations', [])
                ]
            ),
            nav_history=nav_history,
            key_metrics=KeyMetrics(
                portfolio_turnover_ratio=payload['key_metrics']['portfolio_turnover_ratio'],
                risk_level=payload['key_metrics']['risk_level'],
                default_exposures=payload['key_metrics']['default_exposures'],
                derivative_exposures=payload['key_metrics']['derivative_exposures']
            )
        )
        
        # Create and return the response with a new ID
        return cls(
            id=str(uuid.uuid4()),
            fund_data=fund_data
        )
