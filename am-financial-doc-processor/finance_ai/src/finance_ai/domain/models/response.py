from datetime import datetime
from pydantic import BaseModel, Field
from .fund import FundData

class FundDataResponse(BaseModel):
    id: str = Field(..., description="Unique identifier for the fund data")
    fund_data: FundData = Field(..., description="Detailed fund data")
    created_at: datetime = Field(default_factory=datetime.utcnow, description="Timestamp of creation")
    updated_at: datetime = Field(default_factory=datetime.utcnow, description="Timestamp of last update")
