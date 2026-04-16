from pydantic import BaseModel, Field
from typing import Dict
from .value_objects import PlanType

class NavValues(BaseModel):
    IDCW_Plan: float = Field(..., alias="IDCW_Plan")
    IDCW_Option_Direct_Plan: float = Field(..., alias="IDCW_Option_Direct_Plan")
    Growth_Plan: float = Field(..., alias="Growth_Plan")
    Growth_Option_Direct_Plan: float = Field(..., alias="Growth_Option_Direct_Plan")

class NavHistory(BaseModel):
    current: Dict[PlanType, float] = Field(..., alias="as_of_date")
    previous: Dict[PlanType, float] = Field(..., alias="previous_month")
    previous_date: str = Field(..., alias="previous_month_date")
