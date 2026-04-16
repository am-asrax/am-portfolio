from pydantic import BaseModel, Field

class KeyMetrics(BaseModel):
    portfolio_turnover_ratio: float = Field(..., description="Portfolio turnover ratio")
    risk_level: str = Field(..., description="Risk level description")
    default_exposures: float = Field(..., description="Default exposures percentage")
    derivative_exposures: float = Field(..., description="Derivative exposures percentage")
