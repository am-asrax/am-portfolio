import uuid
from typing import Dict, List, Optional
from ..models.fund import FundData
from ..models.response import FundDataResponse
from ..models.value_objects import PlanType

class FundService:
    @staticmethod
    def create_fund_response(payload: Dict) -> FundDataResponse:
        """
        Create a FundDataResponse from a raw payload
        
        Args:
            payload: Raw fund data dictionary
            
        Returns:
            FundDataResponse: Populated response object
        """
        # Transform nav_history to use PlanType enum
        nav_history = {}
        for date_key, nav_values in payload.get('nav_history', {}).items():
            nav_history[date_key] = {
                PlanType.IDCW_PLAN: nav_values['IDCW_Plan'],
                PlanType.IDCW_DIRECT: nav_values['IDCW_Option_Direct_Plan'],
                PlanType.GROWTH_PLAN: nav_values['Growth_Plan'],
                PlanType.GROWTH_DIRECT: nav_values['Growth_Option_Direct_Plan']
            }
        
        # Create and return the response
        return FundDataResponse(
            id=str(uuid.uuid4()),
            fund_data=FundData(**{
                **payload,
                'nav_history': nav_history
            })
        )
